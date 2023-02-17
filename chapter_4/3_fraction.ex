defmodule Fraction do
  # this is a struct with the initial values
  defstruct a: nil, b: nil

  # this is a struct without initial values
  # defstruct [:a, :b]

  @type t :: %__MODULE__{a: integer, b: integer}

  @spec new(integer, integer) :: t
  @doc """
  Create a new Fraction instance.
  """
  def new(a, b) do
    %Fraction{a: a, b: b}
  end

  @spec value(t) :: float
  @doc """
  Return the value of a fraction.

  The function could have defined like so:
    def value(fraction) do
      fraction.a / fraction.b
    end

  The code is clearer, but it will run slightly more slowly than what we have below where you read all fields in a match.
  This performance penalty shouldn’t make much of a difference in most situations, so you can choose the approach you find more readable.
  """
  def value(%Fraction{a: a, b: b}) do
    a / b
  end

  @spec add(t, t) :: t
  @doc """
  Return the sum of two fractions
  """
  def add(%Fraction{a: a1, b: b1}, %Fraction{a: a2, b: b2}) do
    new(a1 * b2 + a2 * b1, b2 * b1)
  end
end
