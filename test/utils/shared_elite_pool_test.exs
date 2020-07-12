defmodule SharedPoolTest do
  use ExUnit.Case
  doctest SharedElitePool

  test "add individual sets individual in shared pool state" do
    elite_individual = [1, 2, 3]
    SharedElitePool.start_link()
    SharedElitePool.save_elite_individual(elite_individual)
    elite_pool = SharedElitePool.get_elite_pool()

    assert length(elite_pool) == 1
    assert elite_pool |> Enum.at(0) == elite_individual
    SharedElitePool.stop()
  end

  test "add individual twice from same process sets single individual in shared pool state" do
    elite_individual_first = [1, 2, 3]
    elite_individual_second = [4, 5, 6]

    SharedElitePool.start_link()
    SharedElitePool.save_elite_individual(elite_individual_first)
    SharedElitePool.save_elite_individual(elite_individual_second)
    elite_pool = SharedElitePool.get_elite_pool()

    assert length(elite_pool) == 1
    assert elite_pool |> Enum.at(0) == elite_individual_second
    SharedElitePool.stop()
  end

  test "get shared elite pool without content returns empty list" do
    SharedElitePool.start_link()
    elite_pool = SharedElitePool.get_elite_pool()

    assert length(elite_pool) == 0
    assert elite_pool == []
    SharedElitePool.stop()
  end
end
