defmodule Tapio.Users.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Tapio.Posts.Post

  schema "users" do
    field(:username, :string)
    field(:token, Ecto.UUID)
    field(:timezone, :string, read_after_writes: true)

    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:password_hash, :string)

    has_many(:posts, Post)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [:username, :password, :password_confirmation])
    |> validate_required([:username, :password, :password_confirmation])
    |> validate_confirmation(:password)
    |> put_change(:token, Ecto.UUID.generate())
    |> hash_password()
    |> validate_required([:password])
  end

  def hash_password(changeset) do
    case changeset.valid? do
      true ->
        password = get_change(changeset, :password)

        case is_nil(password) do
          true ->
            changeset

          false ->
            hashed_password = Bcrypt.hash_pwd_salt(password)
            put_change(changeset, :password_hash, hashed_password)
        end

      false ->
        changeset
    end
  end
end

defmodule Tapio.Users do
  alias Tapio.Repo
  alias Tapio.Users.User

  def create(params) do
    %User{}
    |> User.create_changeset(params)
    |> Repo.insert()
  end

  def validate_login(username, password) do
    case Repo.get_by(User, username: username) do
      nil ->
        Bcrypt.no_user_verify()
        {:error, :invalid}

      user ->
        case Bcrypt.verify_pass(password, user.password_hash) do
          true ->
            {:ok, user}

          false ->
            {:error, :invalid}
        end
    end
  end

  def from_token(token) do
    case Repo.get_by(User, token: token) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end
end
