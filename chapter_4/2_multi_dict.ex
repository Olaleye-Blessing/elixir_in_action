defmodule MultiDict do
  @moduledoc false

  @spec new() :: map
  def new(), do: %{}

  @spec add(map, any, any) :: map
  def add(dict, key, value), do: Map.update(dict, key, [value], &[value | &1])

  @spec get(map, any) :: map
  def get(dict, key), do: Map.get(dict, key, [])
end
