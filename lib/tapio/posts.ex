defmodule Tapio.Posts.Post do
  use Ecto.Schema

  import Ecto.Changeset

  alias Tapio.Users.User

  schema "posts" do
    field(:body, :string)

    belongs_to(:user, User)

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

  def all() do
    Post
    |> order_by([p], desc: p.inserted_at)
    |> preload([:user])
    |> Repo.all()
  end
end
