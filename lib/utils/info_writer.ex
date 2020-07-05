defmodule InfoWriter do

  @spec write_progress([IndividualWithFitness.t()], [[non_neg_integer]], non_neg_integer) :: :ok
  def write_progress(population, distance_matrix, generation_count) do
    %{individual: next_gen_ind, fitness: next_gen_fitness } = population
    |> Fitness.assign_fitness(distance_matrix)
    |> Enum.max_by(fn %{fitness: fitness} -> fitness end)

    distance = Fitness.calculate_distance(next_gen_ind, distance_matrix)
    IO.write("Generation: #{generation_count}\tFitness:#{next_gen_fitness}\tDistance: #{distance}\n")
  end

end
