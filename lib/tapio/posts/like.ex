defmodule Tapio.Posts.Like do
  use Ecto.Schema

  import Ecto.Changeset

  alias Tapio.Posts.Post
  alias Tapio.Users.User

  schema "likes" do
    belongs_to(:post, Post)
    belongs_to(:user, User)

    timestamps(updated_at: false)
  end

  def create_changeset(struct, user) do
    struct
    |> change()
    |> put_change(:user_id, user.id)
    |> validate_required([:post_id, :user_id])
    |> foreign_key_constraint(:post_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:user_id, name: :likes_post_id_user_id_index)
  end
end
