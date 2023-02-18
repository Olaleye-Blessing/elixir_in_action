defmodule TodoList do
  @moduledoc false

  @type entry :: %{
          date: any,
          title: String.t()
        }

  @type t :: %__MODULE__{auto_id: integer(), entries: entry()}

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

  @spec update_entry(t, entry) :: t
  def update_entry(todo_list, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end

  @spec update_entry(t, integer(), (t -> t)) :: t
  def update_entry(todo_list, entry_id, updater_func) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      {_, old_entry} ->
        # ensure that the updater_func
        # 1. hasn't changed the entry id
        # 2. the data type still remains the same

        new_entry = %{id: ^entry_id} = updater_func.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)

        %TodoList{todo_list | entries: new_entries}
    end
  end
end
