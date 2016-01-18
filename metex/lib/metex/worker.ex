defmodule Metex.Worker do
  use GenServer
  use Timex

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def get_temp(pid, location) do
    GenServer.call(pid, {:location, location})
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:location, location}, _from, state) when is_binary(location) do
    if use_cache?(state[location]) do
      IO.puts("Using cache for: #{location}")
      response = get_in(state, [location, :response])
      new_state = update_counter(state, location, response)
      {:reply, response, new_state}
    else
      IO.puts("Fetching latest for: #{location}")
      case temperature_of(location) do
        {:ok, temp} ->
          response = "#{location}: #{temp}°F"
          new_state = update_stats(state, location, response)
          {:reply, response, new_state}
        :error ->
          {:reply, :error, state}
      end
    end
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  ## Helper Functions

  def temperature_of(location) do
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

  defp use_cache?(%{updated_at: updated_at}) do
    shifted = updated_at |> Date.shift(mins: 5)
    Date.compare(shifted, Date.now) == 1 # shifted is still greater than now
  end

  defp use_cache?(_), do: false

  defp update_counter(state, location, response) do
    default = %{response: response, count: 1, updated_at: Date.now}
    Map.update(state, location, default, fn(current) ->
      %{current | count: current.count + 1}
    end)
  end

  defp update_stats(state, location, response) do
    default = %{response: response, count: 1, updated_at: Date.now}
    Map.update(state, location, default, fn(current) ->
      %{response: response, count: current.count + 1, updated_at: Date.now}
    end)
  end
end

# {:ok, pid} = Metex.Worker.start_link
# Metex.Worker.get_temp(pid, "Memphis, TN")
