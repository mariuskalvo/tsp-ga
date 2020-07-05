defmodule Fitness do

  defp get_distance(distance_matrix, x, y) do
    distance_matrix
    |> Enum.at(y)
    |> Enum.at(x)
  end

  @spec calculate_distance([integer], [[integer]]) :: number
  def calculate_distance(individual, distance_matrix) do
    individual
    |> Enum.with_index
    |> Enum.map(fn {_value, index} ->
      next_index = rem(index + 1, length(individual))
      x = Enum.at(individual, index)
      y = Enum.at(individual, next_index)
      distance = get_distance(distance_matrix, x, y)
      distance
    end)
    |> Enum.sum
  end

  @spec assign_fitness([[integer]], [[integer]]) :: [IndividualWithFitness.t]
  def assign_fitness(population, distance_matrix) do
    for individual <- population do
      fitness = 1 / Fitness.calculate_distance(individual, distance_matrix)
      %IndividualWithFitness{
        fitness: fitness,
        individual: individual
      }
    end
  end
end
