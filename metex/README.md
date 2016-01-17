# Metex

Retrieves temperature from OpenWeatherMap.

First signup and get (free) API key: http://home.openweathermap.org/users/sign_up

Fire up iex: `$ API_KEY=your-api-key iex -S mix`

```elixir
iex> Metex.Worker.temperature_of("Taipei, Taiwan")
"Taipei, Taiwan: 291.62°F"

iex > cities = ["Tokyo, Japan", "Berlin, Germany", "Portland, OR"]
iex > temperatures_of(cities)
Berlin, Germany: 271.66°F, Portland, OR: 280.12°F, Tokyo, Japan: 274.15°F
```
