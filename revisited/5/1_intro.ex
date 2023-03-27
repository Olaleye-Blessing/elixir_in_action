defmodule Intro do
  def sync_query(query, sleep \\ 3_000) do
    # simulate a long running time
    Process.sleep(sleep)
    "#{query} result"
  end

  # The caller process, async_query, doesn't get the result of the spawned process. It rather gets the pid of the spawned process
  def async_query(query, sleep \\ 3_000) do
    caller = self()

    spawn(fn ->
      send(caller, {:query_result, sync_query(query, sleep)})
    end)
  end

  def async_result() do
    receive do
      {:query_result, result} ->
        result
    end
  end

  def send_and_receive_async(range, sleep \\ 3_000) do
    # this works because we know that we are waiting for 5 messages.
    # try to use different array length with `query` and `result`
    1..5
    |> Enum.map(&async_query("Query #{&1}", sleep))
    |> Enum.map(fn _ -> async_result() end)
  end
end
