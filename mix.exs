defmodule Tapio.MixProject do
  use Mix.Project

  def project do
    [
      app: :tapio,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Tapio.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:aino, path: "../aino"},
      {:bcrypt_elixir, "~> 2.0"},
      {:ecto_sql, "~> 3.7"},
      {:phoenix_pubsub, "~> 2.0"},
      {:postgrex, "~> 0.15.11"},
      {:timex, "~> 3.7"},
      {:vapor, "~> 0.10.0"}
    ]
  end

  defp aliases() do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.migrate.reset": ["ecto.drop", "ecto.create", "ecto.migrate"]
    ]
  end
end
