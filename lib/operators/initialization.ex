defmodule Initialization do

  @spec generate_population(integer, integer) :: [[integer]]
  def generate_population(pop_size, ind_length) do
    for _i <- 1..pop_size do
      generate_individual(ind_length)
    end
  end

  @spec generate_individual(integer) :: [integer]
  def generate_individual(ind_length) do
    0..(ind_length - 1) |> Enum.shuffle
  end

  def initialize_population([], _pop_size) do
    raise ArgumentError, message: "Distance matrix is empty. Unable to run."
  end

  def initialize_population(nil, _pop_size) do
    raise ArgumentError, message: "Distance matrix is null. Unable to run."
  end

  @spec initialize_population([[integer]], integer) :: [[integer]]
  def initialize_population(distance_matrix, pop_size) do
    ind_length = length(Enum.at(distance_matrix, 0))
    generate_population(pop_size, ind_length)
  end

end
