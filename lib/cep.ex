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

    children = Enum.zip(1..30000, Stream.cycle([:appl, :amzn, :goog])) |>
               Enum.map(fn({i, id}) ->
                  uid = String.to_atom("#{id}#{i}")
                  worker(Source, [input, 1000, uid], id: "#{uid}")
               end)
    """
    children = [
      # Define workers and child supervisors to be supervised
      # worker(Cep.Worker, [arg1, arg2, arg3])
      worker(Source, [input, 50, :aapl], id: "apple"),
      worker(Source, [input, 50, :amzn], id: "amazon"),
      worker(Source, [input, 50, :goog], id: "google"),
      worker(Source, [input, 50, :aapl1], id: "apple1"),
      worker(Source, [input, 50, :amzn1], id: "amazon1"),
      worker(Source, [input, 50, :goog1], id: "google1"),
      worker(Source, [input, 50, :aapl2], id: "apple2"),
      worker(Source, [input, 50, :amzn2], id: "amazon2"),
      worker(Source, [input, 50, :goog3], id: "google2"),
    ]
    """
    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cep.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
# GenEvent.sync_notify(manager, {:tick, {:aapl, 0, 100}})
