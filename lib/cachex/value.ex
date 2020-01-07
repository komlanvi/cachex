defmodule Cachex.Value do
  @moduledoc """
  Hold a single value object
  number - the value
  access - the number of time it was accessed in the cache db
  """

  @type t :: %__MODULE__{number: integer(), access: integer()}

  @enforce_keys [:number]
  defstruct [:number, access: 0]
end
