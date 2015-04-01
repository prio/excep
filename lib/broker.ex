defmodule Broker do
  use GenEvent

  def init(factory) do
    {:ok, factory}
  end

  def handle_event(event = {:tick, {symbol, _, _}}, factory) do
    case Process.whereis(symbol) do
      nil -> GenServer.cast(factory, event)
      pid -> GenServer.cast(pid, event)
    end
    {:ok, factory}
  end

  def handle_event(_, factory) do
    {:ok, factory}
  end
end
