defmodule Exercise1 do
  @moduledoc """
  Solutions to the exercise in the chapter. The solutions are arranged in the order the tasks are given.
  """

  @spec list_len(list) :: integer
  @doc """
  Returns the length of a list.

  ## Examples

      iex> Exercise.list_len([1, 2, 3])
      3

      iex> Exercise.list_len([])
      0
  """
  def list_len(list), do: get_length(0, list)

  defp get_length(length, []),
    do: length

  defp get_length(length, [_head | tail]),
    do: get_length(length + 1, tail)

  @spec range(integer, integer) :: list
  @doc """
  Returns the list of all integer numbers in the given range.

  ## Examples

     iex> Exercise.range(1, 4)
     [1, 2, 3, 4]

     iex> Exercise.range(4, 1)
     [4, 3, 2, 1]
  """
  def range(from, to), do: get_range([], from, to, from > to)

  defp get_range(current_list, from, to, reverse) when from == to do
    # + KEEP PERFORMANCE IN MIND
    case reverse do
      true -> [from | current_list]
      false -> [to | current_list]
    end
  end

  defp get_range(current_list, from, to, reverse) do
    new_to = if from > to, do: to + 1, else: to - 1

    get_range([to | current_list], from, new_to, reverse)

    # case from > to do
    #   true -> get_range([to | current_list], from, to + 1, reverse)
    #   false -> get_range([to | current_list], from, to - 1, reverse)
    # end
  end

  @spec positive(list) :: list
  @doc """
  Returns the list of positive numbers in a list in the reversed order.

  ## Examples

      iex> Exercise.positive([-2, 4, 6, 0, -9])
      [0, 6, 4]
  """
  def positive(list), do: get_positive([], list)

  defp get_positive(positive_list, []), do: positive_list

  defp get_positive(positive_list, [head | tail]) do
    positive_list = if head >= 0, do: [head | positive_list], else: positive_list
    get_positive(positive_list, tail)

    # case head > 0 do
    #   true -> get_positive([head | positive_list], tail)
    #   false -> get_positive(positive_list, tail)
    # end
  end
end
