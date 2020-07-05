defmodule Selection do

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

  @spec tournament_selection([IndividualWithFitness.t], non_neg_integer) :: [integer]
  def tournament_selection(population, tournament_size) do
    %{ individual: individual } = Enum.take_random(population, tournament_size)
    |> Enum.max_by(fn %{ fitness: fitness } -> fitness end)
    individual
  end

  @spec roulette_selection([IndividualWithFitness.t]) :: [integer]
  def roulette_selection(population) do

    total_fitness = population
    |> Enum.reduce(0, fn x, acc -> acc + x.fitness end)

    pick_probability = :rand.uniform()

    population
    |> Enum.reduce_while(0, fn x, sum ->
      cumulative_fitness = sum / total_fitness
      case cumulative_fitness > pick_probability do
        true  -> {:halt, x}
        false -> {:cont, x.fitness + sum}
      end
    end)
    |> (fn %{individual: individual} -> individual end).()
  end


  @spec select_next_generation([[integer]], [[integer]], integer) :: [[integer]]
  def select_next_generation(population, distance_matrix, tournament_size) do

    mutation_probability = 0.05
    iterations = trunc(length(population) / 2)
    population_with_fitness = Fitness.assign_fitness(population, distance_matrix)

    next_generation = 1..iterations
    |> Enum.reduce([], fn _i, acc ->
      parent1 = tournament_selection(population_with_fitness, tournament_size)
      parent2 = tournament_selection(population_with_fitness, tournament_size)

      offspring1 = single_ordered_crossover(parent1, parent2)
      offspring2 = single_ordered_crossover(parent1, parent2)

      offspring1_mutated = offspring1 |> Mutation.mutate(mutation_probability)
      offspring2_mutated = offspring2 |> Mutation.mutate(mutation_probability)

      acc ++ [offspring1_mutated, offspring2_mutated]
    end)

    next_generation
  end

end
