defmodule ActorAdder.Worker do

  def loop do
    receive do
      {pid, [a, b]} when is_number(a) and is_number(b) ->
        send(pid, {:ok, a + b})
      {pid, bad_data} ->
        send(pid, {:error, bad_data})
    end
    loop
  end
end
