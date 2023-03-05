defmodule Calculator do
  def start(), do: spawn(fn -> loop(0) end)

  def loop(current_value) do
    new_value =
      receive do
        message -> process_message(current_value, message)
      end

    loop(new_value)
  end

  def process_message(current_value, {:value, caller}) do
    send(caller, {:response, current_value})
    current_value
  end

  def process_message(current_value, {:add, value}), do: current_value + value
  def process_message(current_value, {:sub, value}), do: current_value - value
  def process_message(current_value, {:mul, value}), do: current_value * value
  def process_message(current_value, {:div, value}), do: current_value / value

  def process_message(current_value, invalid_request) do
    IO.puts("Invalid request #{inspect(invalid_request)}")
    current_value
  end
end
