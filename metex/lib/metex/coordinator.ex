defmodule Metex.Coordinator do

  def loop(results \\ [], results_expected) do
    receive do
      {:ok, result} ->
        new_results = [result|results]
        Enum.count(new_results) == results_expected && send(self, :exit)
        loop(new_results, results_expected)
      :exit ->
        IO.puts(pretty_results(results))
      _ ->
        loop(results, results_expected)
    end
  end

  defp pretty_results(results) do
    results |> Enum.sort |> Enum.join(", ")
  end
end
