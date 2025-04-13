defmodule Calenzy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CalenzyWeb.Telemetry,
      Calenzy.Repo,
      {DNSCluster, query: Application.get_env(:calenzy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Calenzy.PubSub},
      # Events store
      Calenzy.CalendarEvents,
      # Start the Finch HTTP client for sending emails
      {Finch, name: Calenzy.Finch},
      # Start a worker by calling: Calenzy.Worker.start_link(arg)
      # {Calenzy.Worker, arg},
      # Start to serve requests, typically the last entry
      CalenzyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Calenzy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CalenzyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
