defmodule Tapio.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string, null: false)
      add(:password_hash, :string, null: false)
      add(:token, :uuid, null: false)
      add(:timezone, :string, default: "America/New_York", null: false)

      timestamps()
    end

    create index(:users, :username, unique: true)
    create index(:users, :token, unique: true)
  end
end
