defmodule TodoList do
  @moduledoc false

  alias Enumerable.Date
  alias MultiDict

  @spec new() :: map
  def new(),
    do: MultiDict.new()

  @spec add_entry(list, any, String.t()) :: map
  def add_entry(todo_list, date, title),
    do: MultiDict.add(todo_list, date, title)

  @spec entries(list, any)
  def entries(todo_list, date),
    do: MultiDict.get(todo_list, date)

  def due_today(todo_list),
    do: entries(todo_list, "today's date")
end
