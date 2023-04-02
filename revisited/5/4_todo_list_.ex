defmodule TodoServer do
  def start() do
    spawn(fn ->
      _process_name = Process.register(self(), :todo_server)
      loop(TodoList.new())
    end)
  end

  defp loop(todo_list) do
    new_todo_list =
      receive do
        message ->
          process_message(todo_list, message)
      end

    loop(new_todo_list)
  end

  def entries(date) do
    send(:todo_server, {:entries, self(), date})

    receive do
      {:todo_entries, todo_entries} ->
        todo_entries
    after
      5_000 -> {:error, :timeout}
    end
  end

  def add_entry(new_entry) do
    send(:todo_server, {:add_entry, new_entry})
  end

  def update_entry(new_entry) do
    send(:todo_server, {:update_entry, new_entry})
  end

  def delete_entry(entry_id) do
    send(:todo_server, {:delete_entry, entry_id})
  end

  defp process_message(todo_list, {:entries, caller, date}) do
    todo_entries = TodoList.entries(todo_list, date)
    send(caller, {:todo_entries, todo_entries})

    # return state
    todo_list
  end

  defp process_message(todo_list, {:add_entry, new_entry}) do
    TodoList.add_entry(todo_list, new_entry)
  end

  defp process_message(todo_list, {:update_entry, new_entry}) do
    TodoList.update_entry(todo_list, new_entry)
  end

  defp process_message(todo_list, {:delete_entry, entry_id}) do
    TodoList.delete_entry(todo_list, entry_id)
  end
end

defmodule TodoList do
  @moduledoc false

  @type entry :: %{
          date: any,
          title: String.t()
        }

  @type t :: %__MODULE__{auto_id: integer(), entries: entry()}

  defstruct auto_id: 1, entries: %{}

  @spec new([entry]) :: t
  @doc """
  Instantaites a new %TodoList.
  """

  def new(entries \\ []),
    do:
      Enum.reduce(
        entries,
        %TodoList{},
        &add_entry(&2, &1)
      )

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

  @spec delete_entry(t, integer()) :: t
  def delete_entry(todo_list, entry_id) do
    new_entries = Map.delete(todo_list.entries, entry_id)

    %TodoList{todo_list | entries: new_entries}
  end
end
