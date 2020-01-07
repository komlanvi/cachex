defmodule Cachex.Server do
  @moduledoc """
  The cache server. It waits an incoming request, responds then starts again
  """

  alias Cachex.Core

  def run(initial_cache_db) do
    new_cache_db = listen(initial_cache_db)
    run(new_cache_db)
  end

  defp listen(cache_db) do
    receive do
      {:get, {pid, key}} ->
        {new_cache_db, value} = Core.get(cache_db, key)
        send pid, {:number, value.number}

        new_cache_db
      {:put, {_, key, num}} ->
        Core.put(cache_db, key, num)

      {:state, pid} ->
        send pid, {:cache, cache_db}

        cache_db
    end
  end
end
