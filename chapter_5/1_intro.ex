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
    # starts a process with spawn/1
    spawn(fn ->
      query
      |> slow()
      |> IO.puts()
    end)
  end
end
