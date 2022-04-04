defmodule Tapio.Config do
  alias Vapor.Provider.Dotenv
  alias Vapor.Provider.Env

  def application() do
    Vapor.load!(application_providers())
  end

  defp application_providers() do
    [
      %Dotenv{},
      %Env{
        bindings: [
          {:environment, "DEPLOY_ENV"},
          {:port, "PORT", map: &String.to_integer/1},
          {:host, "HOST"}
        ]
      }
    ]
  end

  def database() do
    Vapor.load!(database_providers())
  end

  defp database_providers() do
    [
      %Dotenv{},
      %Env{
        bindings: [
          {:database_url, "DATABASE_URL"},
          {:pool_size, "POOL_SIZE", map: &String.to_integer/1}
        ]
      }
    ]
  end
end
