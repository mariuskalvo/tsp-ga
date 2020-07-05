defmodule Runner do
  use Application
  @spec init(binary) :: :ok
  def init(file_path) when is_bitstring(file_path) do

    distance_matrix = FileLoader.get_distance_matrix(file_path)
    generations = 10000
    population_size = 100
    tournament_size = 5

    initial_population = Initialization.initialize_population(distance_matrix, population_size)

    1..generations
    |> Enum.reduce(initial_population, fn gen_count, previous_gen ->

      next_generation = Selection.select_next_generation(previous_gen, distance_matrix, tournament_size)
      if (rem(gen_count, 10) == 0) do
        InfoWriter.write_progress(next_generation, distance_matrix, gen_count)
      end
      next_generation
    end)
    :ok
  end

  def start(_type, _args) do
    input_file = "dantzig42_d.tsp"
    file_path = "#{__ENV__.file |> Path.dirname}/data/#{input_file}"
    GenServer.start_link(Runner, file_path)
  end
end
