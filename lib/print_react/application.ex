defmodule PrintReact.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # PrintReact.Repo,
      # Start the Telemetry supervisor
      PrintReactWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PrintReact.PubSub},
      # Start the Endpoint (http/https)
      PrintReactWeb.Endpoint,
      # Start a worker by calling: PrintReact.Worker.start_link(arg)
      PUP.PrinterConfigAgent,
      PrintReact.Supervisors.JobRowsManager,
      PrintReact.Supervisors.StartPrintingManager,
      PrintReact.Supervisors.PrinterManager
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PrintReact.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PrintReactWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
