defmodule TodoList do
  @moduledoc false

  @type entry :: %{
          date: any,
          title: String.t()
        }

  @type t :: %__MODULE__{auto_id: number(), entries: entry()}

  defstruct auto_id: 1, entries: %{}

  @spec new() :: t
  @doc """
  Instantaites a new %TodoList.
  """
  def new(), do: %TodoList{}

  @spec add_entry(t, entry) :: t
  @doc """
  Adds a new entry to %TodoList
  """
  def add_entry(todo_list, entry) do
    # set the new entry's ID
    entry = Map.put(entry, :id, todo_list.auto_id)

    # add the new entry to the entries list
    new_entries = Map.put(todo_list.entries, todo_list.auto_id, entry)

    # update the struct
    %TodoList{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end

  @spec entries(t, any) :: [entry]
  @doc """
  Returns a list of todolists with the same date.
  """
  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end
end
