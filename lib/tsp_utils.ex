defmodule TspUtils do
  defp format_matrix_string_content(file_body) do
    String.replace(file_body, "\r", "")
    |> String.trim
    |> String.replace_trailing("\n", "")
  end

  @spec generate_individual(integer) :: [integer]
  def generate_individual(ind_length) do
    0..(ind_length - 1) |> Enum.shuffle
  end

  @spec create_distance_matrix(String.t()) :: [[integer]]
  def create_distance_matrix(file_body) do
    format_matrix_string_content(file_body)
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn x -> String.replace(x, ~r/\s+/, " ") end)
    |> Enum.map(fn x -> String.split(x, " ") end)
    |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)
  end

  @spec generate_population(integer, integer) :: [[integer]]
  def generate_population(pop_size, ind_length) do
    for _i <- 1..pop_size do
      generate_individual(ind_length)
    end
  end

end
