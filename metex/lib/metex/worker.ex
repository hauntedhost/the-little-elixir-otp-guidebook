defmodule Metex.Worker do

  def loop do
    receive do
      {pid, location} when is_binary(location) ->
        send(pid, {:ok, temperature_of(location)})
      {pid, _} ->
        send(pid, {:error, "Unknown message"})
    end
    loop
  end

  def temperature_of(location) do
    result = url_for(location)
    |> HTTPoison.get
    |> parse_response

    case result do
      {:ok, temp} ->
        "#{location}: #{temp}°F"
      :error ->
        "#{location} not found"
    end
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
end
