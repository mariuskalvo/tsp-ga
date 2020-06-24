defmodule TspGa do
  alias TspUtils, as: Utils

  def initialize_population([], _pop_size) do
    raise ArgumentError, message: "Distance matrix is empty. Unable to run."
  end

  def initialize_population(nil, _pop_size) do
    raise ArgumentError, message: "Distance matrix is null. Unable to run."
  end

  @spec initialize_population([[integer]], integer) :: [[integer]]
  def initialize_population(distance_matrix, pop_size) do
    ind_length = length(Enum.at(distance_matrix, 0))
    Utils.generate_population(pop_size, ind_length)
  end

  @spec run(String.t) :: nil
  def run(file_path) when is_bitstring(file_path) do
    body = File.read!(file_path)
    distance_matrix = Utils.create_distance_matrix(body)

    generations = 1000
    population_size = 4000

    initial_population = initialize_population(distance_matrix, population_size)

    1..generations
    |> Enum.reduce(initial_population, fn _gen_count, previous_gen ->
      next_generation = GaOperators.select_next_generation(previous_gen, distance_matrix)

      next_gen_fitted = next_generation
      |> GaOperators.assign_fitness(distance_matrix)

      next_gen_fitted
      |> Enum.min_by(fn %{fitness: fitness} -> fitness end)
      |> IO.inspect



      next_generation
    end)
  end
end

input_file = "dantzig42_d.tsp"
file_path = "#{__ENV__.file |> Path.dirname}/data/#{input_file}"
TspGa.run(file_path)
