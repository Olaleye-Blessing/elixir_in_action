defmodule Intro do
  @moduledoc false

  @spec slow(String.t()) :: String.t()
  @doc """
  Simulates a long-running database query.
  To make use of this function, go ahead and call it from the iex shell.
  """
  def slow(query) do
    Process.sleep(7_000)
    "#{query} result"
  end

  @doc """
  Creates a simple process.
  """

  # SIDE NOTE: Take a look at these:
  # 1. Enum.each(1..10, &async("query #{&1}"))
  # 2. Enum.map(1..10, &async("query #{&1}"))

  # `1` will print :ok because Enum.each doesn't care about the return value
  # `2` will print a list of pids
  def async(query) do
    caller = self()

    spawn(fn ->
      send(caller, {:query_result, slow(query)})

      # using the below won't work because the spawned process will send message to itself because self() will return the pid of the invoked function
      # send(self(), {:query_result, slow(query)})
    end)
  end

  def get_result() do
    receive do
      {:query_result, result} -> result
    end
  end

  def send_and_receive(range \\ 1..5) do
    range
    |> Enum.map(&async("query #{&1}"))
    |> Enum.map(fn _ -> get_result() end)
  end
end
