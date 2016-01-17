defmodule Metex do
  def temperatures_of(cities) do
    coordinator_pid = spawn(Metex.Coordinator, :loop, [[], Enum.count(cities)])
    cities |> Enum.map(city_to_worker(coordinator_pid))
  end

  # takes coordinator pid, returns fn that takes a city and sends message to new worker
  defp city_to_worker(coordinator_pid) do
    fn(city) -> send(new_worker_pid, {coordinator_pid, city}) end
  end

  defp new_worker_pid do
    spawn(Metex.Worker, :loop, [])
  end
end
