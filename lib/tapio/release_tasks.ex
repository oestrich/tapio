# Loosely from https://github.com/bitwalker/distillery/blob/master/docs/Running%20Migrations.md
defmodule Tapio.ReleaseTasks do
  @moduledoc false

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql
  ]

  @repos [
    Tapio.Repo
  ]

  def startup() do
    IO.puts("Loading tapio...")

    # Load the code for tapio, but don't start it
    Application.load(:tapio)

    IO.puts("Starting dependencies..")
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for tapio
    IO.puts("Starting repos..")
    Enum.each(@repos, & &1.start_link(pool_size: 2))
  end
end

defmodule Tapio.ReleaseTasks.Migrate do
  @moduledoc """
  Migrate the database
  """

  alias Tapio.ReleaseTasks
  alias Tapio.Repo

  @apps [
    :tapio
  ]

  @doc """
  Migrate the database
  """
  def run() do
    ReleaseTasks.startup()
    Enum.each(@apps, &run_migrations_for/1)
    IO.puts("Success!")
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(app) do
    IO.puts("Running migrations for #{app}")
    Ecto.Migrator.run(Repo, migrations_path(app), :up, all: true)
  end

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])
end
