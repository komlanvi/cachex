defmodule Cachex.CoreTest do
  use ExUnit.Case

  alias Cachex.{Core, Value}

  setup do
    {:ok,
     %{cache: %{first: %Value{number: 33}, second: %Value{number: 5}, third: %Value{number: 12}}}}
  end

  test "get(cache, key) return the value at key in cache, if key does not exist a new value is added at key and the same value is returned",
       %{cache: cache} do
    {new_cache_1, first_value} = Core.get(cache, :first)
    assert first_value.access == 1

    {new_cache_2, updated_first_value_1} = Core.get(new_cache_1, :first)
    assert updated_first_value_1.access == 2

    {new_cache_3, updated_first_value_2} = Core.get(new_cache_2, :first)
    assert updated_first_value_2.access == 3

    # when accessed for the third time, a new value is added at the same key
    {_new_cache_4, new_first_value} = Core.get(new_cache_3, :first)
    assert new_first_value.access == 1
    refute new_first_value.number == first_value.number

    # get a key that does not exist
    {_, five_value} = Core.get(cache, :fifth)

    assert five_value.access == 1
  end

  test "post(cache, key, number) add %Value{access: 0, number: 0} at key in cache", %{cache: cache} do
    # in the first place, key four does not exist in cache
    assert Map.get(cache, :four) == nil
    num = 44

    # add key four
    new_cache = Core.put(cache, :four, num)

    {_, four_value} = Core.get(new_cache, :four)

    assert four_value.number == num
    assert four_value.access == 1
  end
end
