defmodule GaOperatorsTest do
  use ExUnit.Case
  import Mock
  doctest GaOperators

  test "crossover generates individuals of same length" do
    parent1 = Enum.to_list(1..100)
    parent2 = Enum.to_list(1..100)

    {offspring1, offspring2} = GaOperators.crossover(parent1, parent2)

    assert length(offspring1) == length(offspring2)
    assert length(offspring1) == length(parent1)
  end

  test "crossover generates individuals with unique indices" do
    parent1 = Enum.to_list(1..10)
    parent2 = Enum.to_list(10..1)

    {offspring1, offspring2} = GaOperators.crossover(parent1, parent2)

    assert length(Enum.uniq(offspring1)) == length(parent1)
    assert length(Enum.uniq(offspring2)) == length(parent2)
  end

  test "tournament_selection returns a random individual from the population" do
    tournament_size = 2
    individual_length = 3
    population = [
      %IndividualWithFitness{fitness: 1, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 2, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 3, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 4, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 5, individual: [1, 2, 3]},
    ]

    selected_invididual = GaOperators.tournament_selection(population, tournament_size)

    assert length(selected_invididual) == individual_length
    Enum.each(selected_invididual, fn a ->
      assert is_number(a)
    end)
  end

  test "tournament_selection returns highest element in tournament" do
    expected_winner = [9, 9, 9]
    population = [
      %IndividualWithFitness{fitness: 2, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 3, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 4, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 5, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 1, individual: expected_winner},
    ]
    tournament_size = length(population)

    selected_invididual = GaOperators.tournament_selection(population, tournament_size)
    assert selected_invididual == expected_winner
  end

  test "assign_fitness assigns fitness to population" do
    population = [
      [0, 1, 2, 3],
      [3, 2, 1, 0],
    ]

    distance_matrix = [
      [0, 1, 1, 1],
      [1, 0, 1, 1],
      [1, 1, 0, 1],
      [1, 1, 1, 0],
    ]

    population_with_fitness = GaOperators.assign_fitness(population, distance_matrix)

    Enum.map(population_with_fitness, fn %{fitness: fitness, individual: individual} ->
      assert fitness == length(individual)
      assert individual |> Enum.sort == [0, 1, 2, 3]
    end)
  end

  test "select_next_generation returns new population of same size with even population size" do
    population = [
      [0, 1, 2, 3],
      [3, 2, 1, 0],
    ]

    distance_matrix = [
      [0, 1, 2, 3],
      [1, 0, 1, 2],
      [2, 1, 0, 1],
      [3, 2, 1, 0],
    ]

    next_generation = GaOperators.select_next_generation(population, distance_matrix)
    assert length(next_generation) == length(population)
  end

  test "select_next_generation with odd population returns new even population minus one" do
    population = [
      [0, 1, 2, 3],
      [3, 2, 1, 0],
      [2, 3, 0, 1],
    ]

    distance_matrix = [
      [0, 1, 2, 3],
      [1, 0, 1, 2],
      [2, 1, 0, 1],
      [3, 2, 1, 0],
    ]

    next_generation = GaOperators.select_next_generation(population, distance_matrix)
    assert length(next_generation) == length(population) - 1
  end

  test "mutate should swap two elements if it occurs" do

    link_name = :mutate_swap_test_agent
    Agent.start_link(fn -> 0 end, name: link_name)

    mocked_uniform_max = fn(_number) ->
      call_number = Agent.get(link_name,  &(&1))
      Agent.update(link_name, &(&1 + 1))
      case call_number do
        1 -> 2
        2 -> 3
        _ -> 1.0
      end
    end

    mocked_uniform = fn -> 0 end


    individual = [1, 2, 3, 4, 5]
    expected_diverging = 2

    mutated = with_mock Adapters.Random, [
      uniform_max: mocked_uniform_max,
      uniform: mocked_uniform
    ] do
      GaOperators.mutate(individual, 1.0)
    end

    assert mutated != individual

    diverging = Enum.zip(individual, mutated)
    |> Enum.reduce(0, fn {a, b}, acc -> if a == b, do: acc + 0, else: acc + 1 end)

    assert diverging == expected_diverging
  end

  test "mutate should not swap elements if it does not occur" do

    link_name = :mutate_swap_test_agent
    Agent.start_link(fn -> 0 end, name: link_name)

    mocked_uniform_max = fn(_number) ->
      call_number = Agent.get(link_name,  &(&1))
      Agent.update(link_name, &(&1 + 1))
      case call_number do
        1 -> 2
        2 -> 3
        _ -> 1.0
      end
    end

    mocked_uniform = fn -> 1 end

    individual = [1, 2, 3, 4, 5]
    mutated = with_mock Adapters.Random, [
      uniform_max: mocked_uniform_max,
      uniform: mocked_uniform
    ] do
      GaOperators.mutate(individual, 0.0)
    end

    assert mutated == individual
  end
end
