defmodule Tapio.Repo do
  use Ecto.Repo,
    otp_app: :tapio,
    adapter: Ecto.Adapters.Postgres

  alias Tapio.Config

  def init(_type, config) do
    vapor_config = Config.database()

    config =
      Keyword.merge(config,
        ssl: vapor_config.ssl,
        pool_size: vapor_config.pool_size,
        url: vapor_config.url
      )

    {:ok, config}
  end
end
