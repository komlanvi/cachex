defmodule Cachex.Core do
  @moduledoc """
  Contain the business logic to retrieve or put a value from / to a cache db
  """

  alias Cachex.Value

  @spec get(map(), atom()) :: {map(), Cachex.Value.t()}
  def get(cache, key) do
    case Map.get(cache, key) do
      nil ->
        random_val = Enum.random(1..100)
        #        value = %Value{number: random_val, access: 1}
        #        new_cache = Map.put(cache, key, value)
        #        {new_cache, value}

        updated_cache = put(cache, key, random_val)
        get(updated_cache, key)

      value ->
        if value.access == 3 do
          random_val = Enum.random(1..100)
          new_cache = put(cache, key, random_val)

          get(new_cache, key)
        else
          new_value = Map.update!(value, :access, &(&1 + 1))
          new_cache = Map.put(cache, key, new_value)

          {new_cache, new_value}
        end
    end
  end

  @spec put(map(), atom(), integer()) :: map()
  def put(cache, key, number) do
    Map.put(cache, key, %Value{number: number, access: 0})
  end
end
