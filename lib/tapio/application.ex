defmodule Tapio.Application do
  @moduledoc false

  use Application

  alias Tapio.Config

  @impl true
  def start(_type, _args) do
    config = Config.application()

    children = [
      {Tapio.Repo, []},
      {Phoenix.PubSub, name: Tapio.PubSub},
      {Aino, callback: Tapio.Web.Handler, port: config.port, host: config.host, otp_app: :tapio}
    ]

    opts = [strategy: :one_for_one, name: Tapio.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
