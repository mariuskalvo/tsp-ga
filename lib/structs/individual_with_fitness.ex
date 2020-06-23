defmodule IndividualWithFitness do
  defstruct individual: nil, fitness: 0
  @type t :: %IndividualWithFitness{ individual: [integer], fitness: number }
end
