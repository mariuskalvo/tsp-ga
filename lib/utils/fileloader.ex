defmodule FileLoader do

  @spec get_distance_matrix(String.t()) :: [[integer]]
  def get_distance_matrix(file_path) do
    body = File.read!(file_path)
    DistanceMatrix.create_distance_matrix(body)
  end
end
