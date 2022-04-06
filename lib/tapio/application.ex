defmodule Tapio.Application do
  @moduledoc false

  use Application

  alias Tapio.Config

  @impl true
  def start(_type, _args) do
    config = Vapor.load!(Config)

    children = [
      {Tapio.Repo, []},
      {Phoenix.PubSub, name: Tapio.PubSub}
      | aino(config.application)
    ]

    opts = [strategy: :one_for_one, name: Tapio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp aino(config) do
    case config.environment != "test" do
      true ->
        [
          {Aino,
           callback: Tapio.Web.Handler,
           otp_app: :example,
           port: config.port,
           host: config.host,
           environment: config.environment},
          {Aino.Watcher, name: Tapio.Watcher, watchers: watchers(config.environment)}
        ]

      false ->
        []
    end
  end

  def watchers("development") do
    [
      [
        command: "node_modules/yarn/bin/yarn",
        args: ["build:js:watch"],
        directory: "assets/"
      ],
      [
        command: "node_modules/yarn/bin/yarn",
        args: ["build:css:watch"],
        directory: "assets/"
      ]
    ]
  end

  def watchers(_), do: []
end
