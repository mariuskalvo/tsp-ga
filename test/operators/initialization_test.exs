defmodule InitializationTest do
  use ExUnit.Case
  doctest Initialization

  test "initialize_population generates population of correct size" do
    population_size = 10
    distance_matrix = [
      [1, 2, 3],
      [2, 0, 2],
      [3, 2, 0],
    ]
    population = Initialization.initialize_population(distance_matrix, population_size)
    assert population_size == length(population)
  end

  test "initialize_population generates population with individuals of correct size" do
    individual_length = 3
    distance_matrix = [
      [1, 2, 3],
      [2, 0, 2],
      [3, 2, 0],
    ]
    population = Initialization.initialize_population(distance_matrix, 10)
    Enum.each(population, fn ind ->
      assert individual_length == length(ind)
    end)
  end

  test "initialize_population with empty distance_matrix raises error" do
    assert_raise ArgumentError, fn ->
      Initialization.initialize_population([], 10)
    end
  end

  test "initialize_population with nil distance_matrix raises error" do
    assert_raise ArgumentError, fn ->
      Initialization.initialize_population(nil, 10)
    end
  end

  test "generate_population creates population of correct size" do
    population_size = 10
    individual_size = 10
    population = Initialization.generate_population(population_size, individual_size)

    assert length(population) == population_size
  end

  test "generate_population creates population with individuals of correct size" do
    population_size = 10
    individual_size = 10
    population = Initialization.generate_population(population_size, individual_size)

    Enum.each(population, fn ind ->
      assert length(ind) == individual_size
    end)
  end

  test "generate_population creates individuals with unique allelles" do
    population_size = 10
    individual_size = 10
    population = Initialization.generate_population(population_size, individual_size)
    Enum.each(population, fn ind ->
      assert length(ind) == length(Enum.uniq(ind))
    end)
  end
end
