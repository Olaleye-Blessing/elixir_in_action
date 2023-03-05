defmodule DatabaseServer do
  # this is like client process because it's called by clients
  def start do
    # start listening to messages
    spawn(fn ->
      # initialize a state
      connection = :rand.uniform(1_000)
      loop(connection)
    end)
  end

  # server process
  defp loop(connection) do
    receive do
      {:run_query, caller, query_def} ->
        # make use of connection while running query
        query_result = run_query(connection, query_def)
        send(caller, {:query_result, query_result})
    end

    # continue to listen to messages and keep state
    loop(connection)
  end

  defp run_query(connection, query_def) do
    Process.sleep(3_000)
    "Connection: (#{connection}): #{query_def} result"
  end

  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self(), query_def})
  end

  def get_result do
    receive do
      {:query_result, result} -> result
    after
      5_000 -> {:error, :timeout}
    end
  end

  def run_program() do
    server_pid = start()

    1..4
    |> Enum.each(fn query_number ->
      run_async(server_pid, "query #{query_number}")
      get_result() |> IO.inspect()
    end)
  end
end
