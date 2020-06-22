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
end
