defmodule Cep.Source do
  use GenServer
  use Timex

  def send(message)do
    GenServer.cast(__MODULE__, {:send, message})
  end

  def start_link(addr) do
    GenServer.start_link(__MODULE__, {addr}, name: __MODULE__)
  end

  def init({addr}) do
    {:ok, ctx} = :czmq.start_link()
    socket = :czmq.zsocket_new(ctx, :czmq_const.zmq_req)
    :ok = :czmq.zsocket_connect(socket, addr)
    {:ok, {socket, ctx}}
  end

  def handle_cast({:send, message}, state = {socket, _}) do
    :czmq.zstr_send(socket, message)
    {:noreply, state}
  end

end
