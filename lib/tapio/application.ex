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
        aino_config = %Aino.Config{
          callback: Tapio.Web.Handler,
          otp_app: :tapio,
          port: config.port,
          host: config.host,
          url_port: config.url_port,
          url_scheme: config.url_scheme,
          environment: config.environment,
          config: %{
            session_salt: config.session_salt
          }
        }

        [{Aino, aino_config}]

      false ->
        []
    end
  end
end
