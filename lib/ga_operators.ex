defmodule GaOperators do

  defp single_ordered_crossover(parent1, parent2) do
    individual_length = length(parent1)
    [swath_start, swath_end] = [
      :rand.uniform(individual_length),
      :rand.uniform(individual_length)]
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

  @spec tournament_selection([[integer]], non_neg_integer) :: [integer]
  def tournament_selection(population, tournament_size) do
    Enum.take_random(population, tournament_size)
    |> Enum.at(0)
  end

  def crossover(parent1, parent2) when length(parent1) != length(parent2) do
    raise ArgumentError, message: "Individuals are not of same length"
  end

  @spec crossover([integer], [integer]) :: {[integer], [integer]}
  def crossover(parent1, parent2) do
    offspring1 = single_ordered_crossover(parent1, parent2)
    offspring2 = single_ordered_crossover(parent2, parent1)

    {offspring1, offspring2}
  end
end
