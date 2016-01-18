defmodule ActorAdder.Coordinator do

  def loop(results \\ [], total_results) do
    receive do
      {:ok, result} ->
        new_results = [result|results]
        exit_if_done(self, new_results, total_results)
        loop(new_results, total_results)
      {:error, bad_data} ->
        IO.puts("Bad input: #{inspect(bad_data)}")
        new_total_results = total_results - 1
        exit_if_done(self, results, new_total_results)
        loop(results, new_total_results)
      :exit ->
        IO.puts("Results: #{pretty_results(results)}")
    end
  end

  defp exit_if_done(pid, new_results, total_results) do
    done?(new_results, total_results) && send(self, :exit)
  end

  defp done?(results, total_results) do
    Enum.count(results) == total_results
  end

  defp pretty_results(results) do
    results |> Enum.join(", ")
  end
end
