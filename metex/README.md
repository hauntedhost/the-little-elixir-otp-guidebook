# Metex

Retrieves temperature from OpenWeatherMap.

First signup and get (free) API key: http://home.openweathermap.org/users/sign_up

Fire up iex: `$ DEBUG=true API_KEY=your-api-key iex -S mix`

```elixir
iex> {:ok, pid} = Metex.Worker.start_link
iex> Metex.Worker.get_temp(pid, "Taipei, Taiwan")
Fetching latest for: Taipei, Taiwan
"Taipei, Taiwan: 291.62°F"

iex> Metex.Worker.get_temp(pid, "Taipei, Taiwan")
Using cache for: Taipei, Taiwan
"Taipei, Taiwan: 291.62°F"
```
