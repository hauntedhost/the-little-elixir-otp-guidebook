# Cache

Simple Cache implementation using GenServer.

```
iex> Cache.start_link

iex> Cache.write(:foo, "bar")
iex> Cache.write(:baz, "qux")

iex> Cache.read(:foo)
"bar"

iex> Cache.exists?(:foo)
true
iex> Cache.delete(:foo)
iex> Cache.exists?(:foo)
false

iex> Cache.clear
iex> Cache.read(:baz)
nil
```
