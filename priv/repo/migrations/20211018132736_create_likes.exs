defmodule Tapio.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add(:post_id, references(:posts), null: false)
      add(:user_id, references(:users), null: false)

      timestamps(updated_at: false)
    end

    create index(:likes, [:post_id, :user_id], unique: true)
  end
end
