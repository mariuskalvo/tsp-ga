defmodule TspGaTest do
  use ExUnit.Case
  doctest TspGa

  test "initialize_population generates population of correct size" do
    population_size = 10
    distance_matrix = [
      [1, 2, 3],
      [2, 0, 2],
      [3, 2, 0],
    ]
    population = TspGa.initialize_population(distance_matrix, population_size)
    assert population_size == length(population)
  end

  test "initialize_population generates population with individuals of correct size" do
    individual_length = 3
    distance_matrix = [
      [1, 2, 3],
      [2, 0, 2],
      [3, 2, 0],
    ]
    population = TspGa.initialize_population(distance_matrix, 10)
    Enum.each(population, fn ind ->
      assert individual_length == length(ind)
    end)
  end
end
