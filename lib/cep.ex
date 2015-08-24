defmodule Cep do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false


    {:ok, output} = GenEvent.start_link
    {:ok, factory} = WorkerFactory.start_link(output)

    #GenEvent.add_handler(output, Sink, nil)

    children = [
      worker(Cep.Source, ["tcp://localhost:5555"]),

      worker(FakeTickerSource, [5000, :aapl], id: "apple"),
      worker(FakeTickerSource, [5000, :amzn], id: "amazon"),
      worker(FakeTickerSource, [5000, :goog], id: "google"),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cep.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
