defmodule Worker do
  use GenServer

  def start_link(events, symbol) do
    GenServer.start_link(__MODULE__, {events, symbol})
  end

  def init({events, symbol}) do
    window = Window.timed(60)
    {:ok, %{symbol: symbol, events: events, window: window}}
  end

  def handle_cast({:tick, {symbol, timestamp, value}}, state) do
     w = Window.add(state.window, {timestamp, value})
     avg = Enum.sum(w)/Enum.count(w)
     GenEvent.sync_notify(state.events, {:avg, {symbol, timestamp, avg}})
     {:noreply, %{ state | window: w}}
   end
end
