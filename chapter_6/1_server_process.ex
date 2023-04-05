defmodule ServerProcess do
  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init()
      loop(callback_module, initial_state)
    end)
  end

  defp loop(callback_module, current_state) do
    receive do
      {:call, request, caller} ->
        # invokes the callback to send message.
        # Notice that the function in the callback must return similar reponse type, {response, state}
        {response, new_state} = callback_module.handle_call(request, current_state)

        send(caller, {:response, response})

        loop(callback_module, new_state)

      {:cast, request} ->
        new_state = callback_module.handle_cast(request, current_state)

        loop(callback_module, new_state)
    end
  end

  @doc """
  Sends a synchronous requests to the server process.
  """
  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})

    # waiting for a response makes it asynchronous
    receive do
      {:response, response} ->
        response
    end
  end

  @doc """
  Sends an asynchronous request to the server process
  """
  def cast(server_pid, request), do: send(server_pid, {:cast, request})
end

defmodule KeyValueStore do
  # interface functions that run in client processes
  def start(), do: ServerProcess.start(KeyValueStore)

  def put(pid, key, value), do: ServerProcess.cast(pid, {:put, key, value})

  def get(pid, key), do: ServerProcess.call(pid, {:get, key})

  # callback functions that are invoked in the server process
  def init(), do: %{}

  def handle_cast({:put, key, value}, state) do
    Map.put(state, key, value)
  end

  def handle_call({:get, key}, state) do
    {Map.get(state, key), state}
  end
end
