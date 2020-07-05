defmodule Mutation do

  @spec mutate([integer], number) :: [integer]
  def mutate(individual, mutation_probability) do
    should_mutate = mutation_probability > Adapters.Random.uniform()

    if (!should_mutate) do
      individual
    else
      individual_length = length(individual)

      index1 = trunc(Adapters.Random.uniform_max(individual_length) - 1)
      index2 = trunc(Adapters.Random.uniform_max(individual_length) - 1)

      value1 = Enum.at(individual, index1)
      value2 = Enum.at(individual, index2)

      individual
      |> Enum.to_list
      |> List.replace_at(index1, value2)
      |> List.replace_at(index2, value1)
    end
  end

end
