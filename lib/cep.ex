defmodule Cep do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    {:ok, input} = GenEvent.start_link
    {:ok, output} = GenEvent.start_link
    {:ok, factory} = WorkerFactory.start_link(output)
    GenEvent.add_handler(input, Broker, factory)
    GenEvent.add_handler(output, Sink, nil)

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Cep.Worker, [arg1, arg2, arg3])
      worker(Source, [input, 5000, :aapl], id: "apple"),
      worker(Source, [input, 5000, :amzn], id: "amazon"),
      worker(Source, [input, 5000, :goog], id: "google"),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cep.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
