defmodule Tapio.Repo do
  use Ecto.Repo,
    otp_app: :tapio,
    adapter: Ecto.Adapters.Postgres
end
