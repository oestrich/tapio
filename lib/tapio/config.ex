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
end
