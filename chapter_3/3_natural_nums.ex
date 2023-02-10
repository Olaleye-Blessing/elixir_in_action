defmodule NaturalNums do
  @spec print(integer | float) :: :ok
  @doc """
  Prints a given number in the ascending ascending order, that is, from 1 to n.

  ## Examples

      iex> NaturalNums.print(3)
      1, 2, 3
  """
  def print(n) when n < 1, do: IO.puts("Value should be a positive number")

  def print(n) when is_float(n), do: n |> trunc() |> print()

  def print(1), do: IO.puts(1)

  def print(n) do
    print(n - 1)
    IO.puts(n)
  end

  @spec sum(list) :: integer
  @doc """
  Returns the sum of the elements of an array.

  ## Examples

      iex> NaturalNums.sum([1, 2, 3])
      6

      iex> NaturalNums.sum([])
      0
  """
  def sum([]), do: 0
  def sum([head | tail]), do: head + sum(tail)

  @spec optimized_sum(list) :: integer
  @doc """
  Returns the sum of integers in an array.

  ## Examples

      iex> NaturalNums.optimized_sum([1, 2, 4])
      7

      iex> NaturalNums.optimized_sum([])
      0
  """
  def optimized_sum(list), do: op_sum(0, list)

  # This function makes use of tail-call optimization to perform the sum operation.
  defp op_sum(current_sum, []),
    do: current_sum

  defp op_sum(current_sum, [head | tail]),
    do: op_sum(head + current_sum, tail)
end
