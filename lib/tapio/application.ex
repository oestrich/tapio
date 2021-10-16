defmodule Tapio.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Tapio.Repo, []},
      {Phoenix.PubSub, name: Tapio.PubSub},
      {Aino, callback: Tapio.Web.Handler, port: 3000}
    ]

    opts = [strategy: :one_for_one, name: Tapio.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
