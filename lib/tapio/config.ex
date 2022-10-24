defmodule Tapio.Config do
  use Vapor.Planner

  dotenv()

  config :application,
         env([
           {:environment, "DEPLOY_ENV", default: "development"},
           {:port, "PORT", default: 4000, map: &String.to_integer/1},
           {:host, "HOST", default: "localhost"},
           {:session_salt, "SESSION_SALT"},
           {:url_port, "URL_PORT", default: 4000, map: &String.to_integer/1},
           {:url_scheme, "URL_SCHEME", default: :http, map: &String.to_atom/1}
         ])

  config :database,
         env([
           {:ssl, "DATABASE_SSL", map: &to_boolean/1},
           {:url, "DATABASE_URL"},
           {:pool_size, "POOL_SIZE", default: 5, map: &String.to_integer/1}
         ])

  defp to_boolean("true"), do: true

  defp to_boolean(_), do: false
end
