defmodule FakeTickerSource do
  use GenServer
  use Timex

  def start_link(interval, symbol) do
    GenServer.start_link(__MODULE__, {interval, symbol})
  end

  def price do
    :random.seed(:erlang.now())
    :random.uniform(25) + 100
  end

  def start_timer(state) do
    :erlang.send_after(state.interval, self(),
                       {:tick, {state.symbol, state.time, price()}})
  end

  def init({events, interval, symbol}) do
    state = %{events: events, symbol: symbol,
              time: trunc(Time.to_secs(Time.now)), interval: interval}
    start_timer(state)
    {:ok, state}
  end

  def handle_info(event, state) do
    Cep.Source.send(event)

    ups = %{ state | time: state.time + state.interval/1000}
    start_timer(ups)
    {:noreply, ups}
  end
end
