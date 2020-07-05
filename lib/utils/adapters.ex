defmodule Adapters.Random do
  @spec uniform_max(pos_integer) :: pos_integer
  def uniform_max(max) do
    :rand.uniform(max)
  end

  @spec uniform :: float
  def uniform() do
    :rand.uniform()
  end
end
