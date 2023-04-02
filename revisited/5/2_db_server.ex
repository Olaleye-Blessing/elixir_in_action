defmodule DbServer do
  # starts the loop concurrently
  def start do
    spawn(fn ->
      # create an initial state
      connection = :rand.uniform(1_000)

      loop(connection)
    end)
  end

  defp loop(connection) do
    # handle message
    receive do
      {:run_query, from_pid, query_def} ->
        query_result = run_query(connection, query_def)

        send(from_pid, {:query_result, query_result})
    end

    # keep the connection in the loop argument
    loop(connection)
  end

  defp run_query(connection, query_def) do
    Process.sleep(2_000)
    "Connection #{connection}: #{query_def} result"
  end

  # Clients use run_async/2 to send a request
  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self(), query_def})
  end

  # Clients use get_result/0 to get a response
  def get_result() do
    receive do
      {:query_result, result} -> result
    after
      5_000 -> {:error, :timeout}
    end
  end
end
