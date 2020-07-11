
defmodule FitnessTest do
  use ExUnit.Case
  doctest Fitness

  test "calculate_distance calculates correct distance" do
    # 0 -> 1 = 1
    # 1 -> 2 = 2
    # 2 -> 0 = 2

    individual = [0, 1, 2]
    expected_distance = 5
    distance_matrix = [
      [0, 1, 2],
      [1, 0, 1],
      [2, 2, 0],
    ]
    distance = Fitness.calculate_distance(individual, distance_matrix)
    assert expected_distance == distance
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

    population_with_fitness = Fitness.assign_fitness(population, distance_matrix)

    Enum.map(population_with_fitness, fn %{fitness: fitness, individual: individual} ->
      assert fitness == 1 / length(individual)
      assert individual |> Enum.sort == [0, 1, 2, 3]
    end)
  end
end
