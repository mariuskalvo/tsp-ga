defmodule Crossover do
  def single_ordered_crossover(parent1, parent2) when length(parent1) != length(parent2) do
    raise ArgumentError, message: "Parent individuals are not of same length"
  end

  @spec single_ordered_crossover([integer], [integer]) :: [integer]
  def single_ordered_crossover(parent1, parent2) do
    individual_length = length(parent1)

    [swath_start, swath_end] = [
      Adapters.Random.uniform_max(individual_length) - 1,
      Adapters.Random.uniform_max(individual_length) - 1]
    |> Enum.sort

    parent1_swath = parent1
    |> Enum.slice(swath_start, swath_end - swath_start)

    {p2_remaining_start, p2_remaining_end} = parent2
    |> Enum.filter(fn x -> not Enum.member?(parent1_swath, x) end)
    |> Enum.split(swath_start)

    offspring = p2_remaining_start
    |> Enum.concat(parent1_swath)
    |> Enum.concat(p2_remaining_end)

    offspring
  end
end
