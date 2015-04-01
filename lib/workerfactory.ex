defmodule WorkerFactory do
  use GenServer

  def start_link(events) do
    GenServer.start_link(__MODULE__, events)
  end

  def handle_cast(event = {:tick, {symbol, _, _}}, events) do
    {:ok, pid} = Worker.start_link(events, symbol)
    Process.register(pid, symbol)
    GenServer.cast(pid, event)
    {:noreply, events}
  end
end
