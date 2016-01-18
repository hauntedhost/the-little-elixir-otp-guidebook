# ActorAdder

Practice wrapping my head around actors with a very simple example.

```
iex> pairs = [[1,2], [3,5]]
iex> ActorAdder.add_pairs(pairs)
Results: 8, 3

iex> pairs = [[nil], [1,2], [3,5], ["hello"]]
iex> ActorAdder.add_pairs(pairs)
Bad input: [nil]
Bad input: ["hello"]
Results: 8, 3
```
