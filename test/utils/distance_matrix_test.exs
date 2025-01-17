defmodule DistanceMatrixTest do
  use ExUnit.Case
  doctest DistanceMatrix

  setup do
    distance_file_content =
      "0 1 2 3
       1 0 2 2
       2 2 0 1
       3 2 1 0
      "
    { :ok, distance_file_content: distance_file_content }
  end

  test "create_distance_matrix creates distance matrix of correct length", %{ distance_file_content: file_content } do
    distance_matrix = DistanceMatrix.create_distance_matrix(file_content)
    expected_length = 4
    assert length(distance_matrix) == expected_length

    Enum.each(distance_matrix, fn row ->
      assert length(row) == expected_length
    end)

  end

  test "create_distance_matrix creates matrix with only numbers", %{ distance_file_content: file_content } do
    distance_matrix = DistanceMatrix.create_distance_matrix(file_content)

    Enum.each(distance_matrix, fn row ->
      Enum.each(row, fn val ->
        assert is_number(val)
      end)
    end)

  end
end
