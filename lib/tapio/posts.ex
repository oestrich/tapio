defmodule Tapio.Posts.Post do
  use Ecto.Schema

  import Ecto.Changeset

  alias Tapio.Posts.Like
  alias Tapio.Users.User

  schema "posts" do
    field(:body, :string)
    field(:likes_count, :integer, virtual: true, default: 0)

    belongs_to(:user, User)

    has_many(:likes, Like)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [:body])
    |> validate_required([:body, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end

defmodule Tapio.Posts do
  import Ecto.Query

  alias Tapio.Posts.Like
  alias Tapio.Posts.Post
  alias Tapio.Repo

  def create(user, params) do
    changeset =
      user
      |> Ecto.build_assoc(:posts)
      |> Post.create_changeset(params)

    case Repo.insert(changeset) do
      {:ok, post} ->
        post = Repo.preload(post, [:user])

        event = %Tapio.Event{
          event: "posts/new",
          data: post
        }

        Phoenix.PubSub.broadcast(Tapio.PubSub, "posts", event)

        {:ok, post}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def like(post, user) do
    changeset =
      post
      |> Ecto.build_assoc(:likes)
      |> Like.create_changeset(user)

    case Repo.insert(changeset) do
      {:ok, like} ->
        like = Repo.preload(like, [:post])

        event = %Tapio.Event{
          event: "likes/new",
          data: like
        }

        Phoenix.PubSub.broadcast(Tapio.PubSub, "posts", event)

        {:ok, like}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def all() do
    Post
    |> join(:left, [p], l in assoc(p, :likes), as: :likes)
    |> select_merge([p, likes: l], %{likes_count: count(l)})
    |> order_by([p], desc: p.inserted_at)
    |> group_by([p], p.id)
    |> preload([:user])
    |> Repo.all()
  end

  def get(id) do
    case Repo.get(Post, id) do
      nil ->
        {:error, :not_found}

      post ->
        {:ok, post}
    end
  end
end
