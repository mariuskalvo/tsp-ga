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

  @spec run(bitstring) :: nil
  def run(file_path) when is_bitstring(file_path) do
    body = File.read!(file_path)
    distance_matrix = Utils.create_distance_matrix(body)

    _initial_population = initialize_population(distance_matrix, 10)

    nil
  end

end
