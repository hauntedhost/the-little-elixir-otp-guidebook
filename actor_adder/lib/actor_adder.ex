defmodule ActorAdder do

  def add_pairs(pairs) do
    coordinator_pid = spawn(ActorAdder.Coordinator, :loop, [[], Enum.count(pairs)])
    pairs |> (Enum.map(fn(pair) -> send(new_worker_pid, {coordinator_pid, pair}) end))
  end

  defp new_worker_pid do
    spawn(ActorAdder.Worker, :loop, [])
  end
end
