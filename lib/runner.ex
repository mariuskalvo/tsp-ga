defmodule Runner do
  use Application

  @spec process_generation([[integer]], [[integer]], integer, integer) :: [[integer]]
  def process_generation(previous_gen, distance_matrix, tournament_size, gen_count) do
    next_generation = Selection.select_next_generation(previous_gen, distance_matrix, tournament_size)
    if (rem(gen_count, 10) == 0) do

      %{individual: elite_ind } = next_generation
      |> Fitness.assign_fitness(distance_matrix)
      |> Enum.max_by(fn %{fitness: fitness} -> fitness end)

      SharedElitePool.save_elite_individual(elite_ind)
      elite_pool = SharedElitePool.get_elite_pool()

      elitist_next_generation = next_generation
      |> Enum.take(length(next_generation) - length(elite_pool))
      |> Enum.concat(elite_pool)

      elitist_next_generation
    else
      next_generation
    end
  end

  @spec init(bitstring()) :: :ok
  def init(file_path) when is_bitstring(file_path) do

    distance_matrix = FileLoader.get_distance_matrix(file_path)
    generations = 10000
    population_size = 150
    tournament_size = 5

    initial_population = Initialization.initialize_population(distance_matrix, population_size)

    1..generations
    |> Enum.reduce(initial_population, fn gen_count, previous_gen ->
      process_generation(previous_gen, distance_matrix, tournament_size, gen_count)
    end)
    :ok
  end

  def run_loop(distance_matrix) do
    :timer.sleep(:timer.seconds(1))

    elite_pool = SharedElitePool.get_elite_pool()
    if Enum.any?(elite_pool) do
      elite = SharedElitePool.get_elite_pool()
      |> Fitness.assign_fitness(distance_matrix)
      |> Enum.max_by(fn %{fitness: fitness} -> fitness end)

      %{individual: elite_individual} = elite
      distance = Fitness.calculate_distance(elite_individual, distance_matrix)
      IO.write("#{distance}\n")
    end

    run_loop(distance_matrix)
  end

  def start(_type, _args) do
    input_file = "dantzig42_d.tsp"
    file_path = "#{__ENV__.file |> Path.dirname}/data/#{input_file}"

    distance_matrix = FileLoader.get_distance_matrix(file_path)
    SharedElitePool.start_link()

    number_of_processes = 4
    1..number_of_processes
    |> Enum.map(fn _p -> spawn(fn -> init(file_path) end) end)

    run_loop(distance_matrix)
    end
end
