defmodule Exercise2 do
  @moduledoc """
  This exercise is built on stream implementation.
  """

  @spec file_lines!(String.t()) :: Enumerable.t()

  # Returns the lines in a file using the Stream module.
  defp file_lines!(path),
    do: File.stream!(path) |> Stream.map(&String.replace(&1, "\n", ""))

  @spec lines_length!(String.t()) :: list(integer)
  @doc """
  Returns the length of each line in a file.

  ## Examples

      iex> Exercise2.lines_length!("summaries/2.txt")
      [1, 69, 1, 130, 0, 23, 0, 24, 23, 0, 1, 34, 1, 0, 95, 1, 25, 1, 0, 0, 20, 110,
      0, 155, 0, 3, 106, 3, 0, 22, 160, 3, 88, 3, 0, 8, 23, 0, 117, 148, 0, 160, 0,
      3, 23, 3, 0, 9, 53, 0, ...]
  """
  def lines_length!(path) do
    path
    |> file_lines!()
    |> Enum.map(&String.length/1)
  end

  @spec longest_line_length!(String.t()) :: integer
  @doc """
  Returns the value of the longest line in a file.

  ## Examples

      iex> Exercise2.longest_line_length!("summaries/2.txt")
      160
  """
  def longest_line_length!(path) do
    path
    |> file_lines!()
    |> Stream.map(&String.length/1)
    |> Enum.max()
  end

  @spec longest_line!(String.t()) :: String.t()
  @doc """
  Returns the longest line in a file.any()

  ## Examples

      iex> Exercise2.longest_line!("summaries/2.txt")
      "monthly_salary = 11_000"
  """
  def longest_line!(path) do
    path
    |> file_lines!()
    |> Enum.max()
  end

  @spec words_per_line!(String.t()) :: list(integer)
  @doc """
  Returns the length of each word per line in a file.

  ## Examples

      iex> Exercise2.words_per_line!("summaries/2.txt")
      [1, 13, 1, 20, 0, 3, 0, 4, 3, 0, 1, 5, 1, 0, 18, 1, 4, 1, 0, 0, 3, 19, 0, 26, 0,
      1, 11, 1, 0, 3, 20, 1, 2, 1, 0, 2, 3, 0, 22, 29, 0, 27, 0, 1, 4, 1, 0, 2, 7, 0,
      ...]
  """
  def words_per_line!(path) do
    path
    |> file_lines!()
    |> Enum.map(&length(String.split(&1)))
  end
end
