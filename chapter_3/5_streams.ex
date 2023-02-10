defmodule Streams do
  @list [1, 2, 3, 4, 5, 6]

  def enum_ex do
    # the iteration here is too much.
    @list
    # this first go throught the list to produce another list of tuples
    |> Enum.with_index()
    # then this perform the iteration on the new list
    |> Enum.each(fn {x, i} -> IO.puts("the index of #{x} is #{i}") end)
  end

  def stream_take do
    @list
    # lazy transformation happens here
    |> Stream.with_index()
    # returns two elements
    |> Enum.take(2)
  end

  def stream_ex do
    @list
    # lazy transformation happens here
    |> Stream.with_index()
    |> Enum.each(fn {x, i} -> IO.puts("the index of #{x} is #{i}") end)
  end
end
