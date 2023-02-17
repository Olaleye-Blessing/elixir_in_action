defmodule Enums do
  @moduledoc false

  @spec sum(list) :: integer
  @doc """
  Returns the sum of the numbers in a list.
  """
  def sum(list) do
    Enum.reduce(
      list,
      0,
      fn
        elem, acc when is_number(elem) -> sum + elem
        _, sum -> sum
    )
  end
end
