defmodule Sink do
  use GenEvent
  use Timex

  def handle_event({:avg, {symbol, timestamp, value}}, factory) do
    date = Date.from(timestamp, :secs) |> DateFormat.format!("{RFC1123}")
    IO.puts("#{date}: #{symbol} average: #{value}")
    {:ok, factory}
  end

  def handle_event(_, factory) do
    {:ok, factory}
  end
end
