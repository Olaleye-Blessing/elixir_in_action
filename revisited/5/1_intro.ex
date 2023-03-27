defmodule Into do
  def sync_query(query, sleep \\ 3_000) do
    # simulate a long running time
    Process.sleep(sleep)
    "#{query} result"
  end

  # The caller process, async_query, doesn't get the result of the spawned process. It rather gets the pid of the spawned process
  def async_query(query, sleep \\ 3_000) do
    spawn(fn ->
      IO.puts(sync_query(query, sleep))
    end)
  end
end
