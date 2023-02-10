defmodule Chapter3.Fact do
  @moduledoc false

  @doc """
  Calculate the factorial of a number.
  """
  @spec fact(number) :: number
  def fact(0), do: 1
  def fact(n), do: n * fact(n - 1)
end
