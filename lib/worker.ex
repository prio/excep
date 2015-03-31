defmodule Worker do
  use GenServer

  def start_link(broker, symbol) do
    GenServer.start_link(__MODULE__, {broker, symbol})
  end

  def init({broker, symbol}) do
    window = Window.timed(60)
    {:ok, %{symbol: symbol, broker: broker, window: window}}
  end

  def handle_cast({:tick, {symbol, timestamp, value}}, state) do
     w = Window.add(state.window, {timestamp, value})
     avg = Enum.sum(w)/Enum.count(w)
     GenEvent.sync_notify(state.broker, {:avg, {symbol, timestamp, avg}})
     {:noreply, { state | window: w}}
   end
end
