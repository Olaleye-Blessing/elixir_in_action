defmodule Chapter2.Circle do
  @moduledoc """
  Implements basic circle functions
  """

  @pi 3.14159

  @doc """
  Computes the area of a circle.
  """
  @spec area(number) :: number
  def area(r), do: r * r * @pi

  @doc """
  Computes the circumference of a circle. This is the same as the perimeter.
  """
  @spec circumference(number) :: number
  def circumference(r), do: 2 * r * @pi

  @doc """
  Computes the perimeter of a circle. This is the same as the circumference.
  """
  @spec perimeter(number) :: number
  def perimeter(number), do: circumference(number)

  @doc """
  Computes the diameter of a circle.
  """
  @spec diameter(number) :: number
  def diameter(r), do: 2 * r

  @doc """
  Computes the radius of a circle.
  """
  @spec radius(number) :: number
  def radius(diameter), do: diameter / 2
end
