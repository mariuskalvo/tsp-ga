
defmodule SelectionTest do
  use ExUnit.Case
  doctest Selection

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
    selected_invididual = Selection.tournament_selection(population, tournament_size)
    assert length(selected_invididual) == individual_length
  end

  test "tournament_selection returns highest element in tournament" do
    expected_winner = [9, 9, 9]
    population = [
      %IndividualWithFitness{fitness: 2, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 3, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 4, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 5, individual: [1, 2, 3]},
      %IndividualWithFitness{fitness: 10, individual: expected_winner},
    ]
    tournament_size = length(population)

    selected_invididual = Selection.tournament_selection(population, tournament_size)
    assert selected_invididual == expected_winner
  end


  test "select_next_generation returns new population of same size with even population size" do
    tournament_size = 5
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

    next_generation = Selection.select_next_generation(population, distance_matrix, tournament_size)
    assert length(next_generation) == length(population)
  end

  test "select_next_generation with odd population returns new even population minus one" do
    tournament_size = 5
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

    next_generation = Selection.select_next_generation(population, distance_matrix, tournament_size)
    assert length(next_generation) == length(population) - 1
  end

end
