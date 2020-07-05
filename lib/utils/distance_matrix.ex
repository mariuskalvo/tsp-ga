defmodule DistanceMatrix do
  defp format_matrix_string_content(file_body) do
    String.replace(file_body, "\r", "")
    |> String.trim
    |> String.replace_trailing("\n", "")
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
end
