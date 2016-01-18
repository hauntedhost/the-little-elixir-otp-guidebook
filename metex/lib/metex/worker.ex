defmodule Metex.Worker do
  use GenServer
  use Timex

  @name MW
  @cache_minutes 5

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: MW])
  end

  def stop do
    GenServer.cast(@name, :stop)
  end

  def get_temp(location) do
    GenServer.call(@name, {:location, location})
  end

  def get_state do
    GenServer.call(@name, :get_state)
  end

  def reset_state do
    GenServer.cast(@name, :reset_state)
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:location, location}, _from, state) when is_binary(location) do
    if (temp = cached_temp(state, location)) do
      debug? && IO.puts("Using cache for: #{location}")
      new_state = update_state(state, location, temp, touch = false)
      {:reply, display_temp(location, temp), new_state}
    else
      debug? && IO.puts("Fetching latest for: #{location}")
      case temperature_of(location) do
        {:ok, temp} ->
          new_state = update_state(state, location, temp)
          {:reply, display_temp(location, temp), new_state}
        :error ->
          {:reply, :error, state}
      end
    end
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:reset_state, _state) do
    {:noreply, %{}}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def terminate(reason, state) do
    IO.puts("Server terminated: #{inspect(reason)}")
    IO.inspect(state)
    :ok
  end

  ## Helper Functions

  defp display_temp(location, temp) do
    "#{location}: #{temp}°F"
  end

  defp temperature_of(location) do
    url_for(location)
    |> HTTPoison.get
    |> parse_response
  end

  defp url_for(location) do
    api_key = System.get_env("API_KEY")
    location_param = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location_param}&APPID=#{api_key}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(%{"main" => %{ "temp" => temp}}) do
    {:ok, temp}
  end

  defp compute_temperature(_) do
    :error
  end

  defp cached_temp(state, location) do
    use_cache?(state[location]) && get_in(state, [location, :temp])
  end

  defp use_cache?(%{updated_at: updated_at}) do
    shifted = updated_at |> Date.shift(mins: @cache_minutes)
    Date.compare(shifted, Date.now) == 1 # shifted is still greater than now
  end

  defp use_cache?(_) do
    false
  end

  defp update_state(state, location, temp, touch \\ true) do
    default = %{temp: temp, count: 1, updated_at: Date.now}
    Map.update(state, location, default, fn(current) ->
      %{
        temp: temp,
        count: current.count + 1,
        updated_at: (touch && Date.now) || current.updated_at
      }
    end)
  end

  defp debug? do
    !!System.get_env("DEBUG")
  end
end

# {:ok, pid} = Metex.Worker.start_link
# Metex.Worker.get_temp(pid, "Memphis, TN")
