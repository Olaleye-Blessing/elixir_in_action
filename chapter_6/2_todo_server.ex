defmodule ServerProcess do
  @moduledoc false

  def start(callback_module) do
    spawn(fn ->
      init_state = callback_module.init()

      loop(callback_module, init_state)
    end)
  end

  defp loop(callback_module, current_state) do
    receive do
      {:call, request, caller} ->
        {response, new_state} = callback_module.handle_call(request, current_state)

        send(caller, {:response, response})

        loop(callback_module, new_state)

      {:cast, request} ->
        new_state = callback_module.handle_cast(request, current_state)

        loop(callback_module, new_state)
    end
  end

  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})

    receive do
      {:response, response} ->
        response
    end
  end

  def cast(server_pid, request), do: send(server_pid, {:cast, request})
end

defmodule TodoServer do
  def start(), do: ServerProcess.start(TodoServer)

  def entries(pid, date) do
    ServerProcess.call(pid, {:entries, date})
  end

  def add_entry(pid, entry) do
    ServerProcess.cast(pid, {:add_entry, entry})
  end

  def update_entry(pid, new_entry) do
    ServerProcess.cast(pid, {:update_entry, new_entry})
  end

  def update_entry(pid, entry_id, updater_func) do
    ServerProcess.cast(pid, {:update_entry, entry_id, updater_func})
  end

  def delete_entry(pid, entry_id) do
    ServerProcess.cast(pid, {:delete_entry, entry_id})
  end

  def init(), do: TodoList.new()

  def handle_call({:entries, date}, state) do
    {TodoList.entries(state, date), state}
  end

  def handle_cast({:add_entry, entry}, state) do
    TodoList.add_entry(state, entry)
  end

  def handle_cast({:update_entry, new_entry}, state) do
    TodoList.update_entry(state, new_entry)
  end

  def handle_cast({:update_entry, entry_id, updater_fun}, state) do
    TodoList.update_entry(state, entry_id, updater_fun)
  end

  def handle_cast({:delete_entry, entry_id}, state) do
    TodoList.delete_entry(state, entry_id)
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
