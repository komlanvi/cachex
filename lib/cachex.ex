defmodule Cachex do
  @moduledoc """
  The client API
  """

  @spec start(map()) :: pid()
  def start(initial_cache_db) do
    spawn(fn -> Cachex.Server.run(initial_cache_db) end)
  end

  @spec get(pid(), atom()) :: integer()
  def get(pid, key) do
    send pid, {:get, {self(), key}}

    receive do
      {:number, num} -> num
    end
  end

  @spec put(pid(), atom(), integer()) :: :ok
  def put(pid, key, num) do
    send pid, {:put, {self(), key, num}}

    :ok
  end

  @spec state(pid()) :: map()
  def state(pid) do
    send pid, {:state, self()}

    receive do
      {:cache, cache} -> cache
    end
  end
end
