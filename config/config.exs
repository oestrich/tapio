import Config

config :tapio, ecto_repos: [Tapio.Repo]

config :tapio, Tapio.Repo,
  hostname: "localhost",
  database: "tapio_dev"
