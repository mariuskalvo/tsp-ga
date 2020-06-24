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

  @spec tournament_selection([IndividualWithFitness.t], non_neg_integer) :: [integer]
  def tournament_selection(population, tournament_size) do
    Enum.take_random(population, tournament_size)
    |> Enum.min_by(fn %{ fitness: fitness } -> fitness end)
    |> (fn %{ individual: individual } -> individual end).()
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

  @spec assign_fitness([[integer]], [[integer]]) :: [IndividualWithFitness.t]
  def assign_fitness(population, distance_matrix) do
    for individual <- population do
      %IndividualWithFitness{
        fitness: TspUtils.calculate_fitness(individual, distance_matrix),
        individual: individual
      }
    end
  end

  @spec select_next_generation([[integer]], [[integer]]) :: [[integer]]
  def select_next_generation(population, distance_matrix) do

    tournament_size = 10
    population_with_fitness = assign_fitness(population, distance_matrix)
    iterations = trunc(length(population) / 2)

    next_generation = 1..iterations
    |> Enum.reduce([], fn _i, acc ->
      parent1 = tournament_selection(population_with_fitness, tournament_size)
      parent2 = tournament_selection(population_with_fitness, tournament_size)

      {offspring1, offspring2} = crossover(parent1, parent2)
      acc ++ [offspring1, offspring2]
    end)

    next_generation
  end
end
