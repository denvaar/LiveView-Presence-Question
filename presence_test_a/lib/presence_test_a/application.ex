defmodule PresenceTestA.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      PresenceTestA.Repo,
      PresenceTestAWeb.Telemetry,
      {Phoenix.PubSub, name: PresenceTestA.PubSub},
      {PresenceTestA.GameSupervisor, []},
      PresenceTestA.Presence,
      PresenceTestAWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PresenceTestA.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PresenceTestAWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
