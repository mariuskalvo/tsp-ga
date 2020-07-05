
defmodule MutationTest do
  use ExUnit.Case
  import Mutation
  import Mock
  doctest Mutation

  defp create_mocked_uniform_max(link_name) do
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
    mocked_uniform_max
  end

  test "mutate should swap two elements if it occurs" do
    link_name = :mutate_swap_test_agent

    mocked_uniform_max = create_mocked_uniform_max(link_name)
    mocked_uniform = fn -> 0 end

    individual = [1, 2, 3, 4, 5]
    expected_diverging = 2

    mutated = with_mock Adapters.Random, [
      uniform_max: mocked_uniform_max,
      uniform: mocked_uniform
    ] do
      Mutation.mutate(individual, 1.0)
    end

    diverging = Enum.zip(individual, mutated)
    |> Enum.reduce(0, fn {a, b}, acc -> if a == b, do: acc + 0, else: acc + 1 end)

    assert mutated != individual
    assert diverging == expected_diverging
  end

  test "mutate should not swap elements if it does not occur" do
    link_name = :mutate_swap_test_agent

    mocked_uniform_max = create_mocked_uniform_max(link_name)
    mocked_uniform = fn -> 1 end

    individual = [1, 2, 3, 4, 5]
    mutated = with_mock Adapters.Random, [
      uniform_max: mocked_uniform_max,
      uniform: mocked_uniform
    ] do
      Mutation.mutate(individual, 0.0)
    end

    assert mutated == individual
  end
end
