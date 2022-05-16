defmodule HttpService.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: HttpService.PubSub},
      HttpService.Telemetry,
      HttpService.Endpoint,
      DataService,
      {HnService.Worker, minutes: 5}
    ]

    opts = [strategy: :one_for_one, name: HttpService.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    HttpService.Endpoint.config_change(changed, removed)
    :ok
  end
end
