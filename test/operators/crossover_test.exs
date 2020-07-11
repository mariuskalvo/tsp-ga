defmodule CrossoverTest do
  use ExUnit.Case
  doctest Crossover

  test "single_ordered_crossover generates individuals of same length as parents" do
    parent1 = Enum.to_list(1..100)
    parent2 = Enum.to_list(1..100)

    offspring = Crossover.single_ordered_crossover(parent1, parent2)

    assert length(offspring) == length(parent1)
    assert length(offspring) == length(parent2)
  end

  test "single_ordered_crossover generates individuals with unique indices" do
    parent1 = Enum.to_list(1..10)
    parent2 = Enum.to_list(10..1)

    offspring = Crossover.single_ordered_crossover(parent1, parent2)

    assert length(Enum.uniq(offspring)) == length(parent1)
    assert length(Enum.uniq(offspring)) == length(parent2)
  end
end
