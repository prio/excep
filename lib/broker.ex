defmodule Broker do
  use GenServer

  def start_link(addr) do
    GenServer.start_link(__MODULE__, {addr}, [])
  end

  def init(addr) do
    {:ok, ctx} = :czmq.start_link()
    source_socket = :czmq.zsocket_new(ctx, :czmq_const.zmq_rep)
    :ok = :czmq.zsocket_bind(source_socket, addr)

    {:ok, ctx} = :czmq.start_link()
    socket = :czmq.zsocket_new(ctx, :czmq_const.zmq_rep)
    :ok = :czmq.zsocket_bind(socket, addr)

    {:ok, {socket, ctx}}
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
