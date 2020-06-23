defmodule GaOperatorsTest do
  use ExUnit.Case
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
    tournament_size = 5
    expected_winner = [9, 9, 9]
    population = [
      %IndividualWithFitness{fitness: 1, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 2, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 3, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 4, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 5, individual: expected_winner},
    ]

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
end
