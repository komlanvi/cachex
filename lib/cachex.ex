defmodule Cachex do
  @moduledoc """
  The client API
  """

  def start(initial_cache_db) do
    spawn(fn -> Cachex.Server.run(initial_cache_db) end)
  end

  def get(pid, key) do
    send pid, {:get, {self(), key}}

    receive do
      {:number, num} -> num
    end
  end

  def put(pid, key, num) do
    send pid, {:put, {self(), key, num}}

    :ok
  end

  def state(pid) do
    send pid, {:state, self()}

    receive do
      {:cache, cache} -> cache
    end
  end
end
