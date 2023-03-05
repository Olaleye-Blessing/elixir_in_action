defmodule DatabaseServer do
  # this is like client process because it's called by clients
  def start do
    # start listening to messages
    spawn(&loop/0)
  end

  # server process
  defp loop do
    receive do
      {:run_query, caller, query_def} ->
        send(caller, {:query_result, run_query(query_def)})
    end

    # continue to listen to messages
    loop()
  end

  defp run_query(query_def) do
    Process.sleep(3_000)
    "#{query_def} result"
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
end
