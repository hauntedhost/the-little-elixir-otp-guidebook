# Metex

Retrieves temperature from OpenWeatherMap.

First signup and get (free) API key: http://home.openweathermap.org/users/sign_up

Fire up iex: `$ DEBUG=true API_KEY=your-api-key iex -S mix`

```elixir
iex> Metex.Worker.start_link

iex> Metex.Worker.get_temp("Taipei, Taiwan")
Fetching latest for: Taipei, Taiwan
"Taipei, Taiwan: 288.62°F"

iex> Metex.Worker.get_temp("Taipei, Taiwan")
Using cache for: Taipei, Taiwan
"Taipei, Taiwan: 288.62°F"

iex> Metex.Worker.get_state
%{"Asheville, NC" => %{count: 4, temp: 271.15,
    updated_at: %Timex.DateTime{calendar: :gregorian, day: 18, hour: 7,
     minute: 20, month: 1, ms: 680, second: 28,
     timezone: %Timex.TimezoneInfo{abbreviation: "UTC", from: :min,
      full_name: "UTC", offset_std: 0, offset_utc: 0, until: :max},
     year: 2016}},
  "Taipei, Taiwan" => %{count: 2, temp: 288.62,
    updated_at: %Timex.DateTime{calendar: :gregorian, day: 18, hour: 7,
     minute: 21, month: 1, ms: 116, second: 19,
     timezone: %Timex.TimezoneInfo{abbreviation: "UTC", from: :min,
      full_name: "UTC", offset_std: 0, offset_utc: 0, until: :max},
     year: 2016}}}
```
