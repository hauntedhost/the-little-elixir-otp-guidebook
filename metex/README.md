# Metex

Retrieves temperature from OpenWeatherMap.

First signup and get (free) API key: http://home.openweathermap.org/users/sign_up

Fire up iex: `$ API_KEY=your-api-key iex -S mix`

```elixir
iex> Metex.Worker.temperature_of("Taipei, Taiwan")
"Taipei, Taiwan: 291.62°F"

iex > cities = ["Singapore", "Monaco", "Vatican City", "Hong Kong", "Macau"]
iex > spawner = fn -> spawn(Metex.Worker, :loop, []) end

iex > cities |> (Enum.map fn(city) -> pid = spawner.(); send(pid, {self, city}) end)
[{#PID<0.160.0>, "Singapore"}, {#PID<0.160.0>, "Monaco"},
 {#PID<0.160.0>, "Vatican City"}, {#PID<0.160.0>, "Hong Kong"},
 {#PID<0.160.0>, "Macau"}]

iex> flush
{:ok, "Monaco: 274.35°F"}
{:ok, "Vatican City: 277.48°F"}
{:ok, "Singapore: 298.66°F"}
{:ok, "Hong Kong: 291.15°F"}
{:ok, "Macau: 291.58°F"}
```
