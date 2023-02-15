defmodule TodoList do
  @moduledoc false

  @spec new() :: map
  def new(), do: %{}

  @spec add_entry(list, any, String.t()) :: map
  def add_entry(todo_list, date, title) do
    Map.update(
      todo_list,
      date,
      [title],
      fn titles -> [title | titles] end
    )
  end

  @spec entries(list, any)
  def entries(todo_list, date) do
    Map.get(todo_list, date, [])
  end
end
