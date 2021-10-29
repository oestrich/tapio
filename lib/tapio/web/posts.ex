defmodule Tapio.Web.Posts do
  alias Aino.Token
  alias Tapio.Posts
  alias Tapio.Web.Posts.View

  def index(%{current_user: current_user} = token) do
    posts = Posts.all()

    token
    |> Token.response_status(200)
    |> Token.response_header("Content-Type", "application/json")
    |> Token.response_body(Jason.encode!(View.render("posts.json", %{posts: posts, user: current_user})))
  end

  def create(%{current_user: current_user, params: params} = token) do
    case Posts.create(current_user, params) do
      {:ok, post} ->
        case Token.request_header(token, "accept") do
          ["application/json"] ->
            token
            |> Token.response_status(201)
            |> Token.response_header("Content-Type", "application/json")
            |> Token.response_body(Jason.encode!(View.render("post.json", %{post: post, user: current_user})))

          _ ->
            token
            |> Token.response_status(302)
            |> Token.response_header("Content-Type", "text/html")
            |> Token.response_header("Location", "/")
            |> Token.response_body("Redirecting...")
        end

      {:error, _changeset} ->
        token
        |> Token.response_status(302)
        |> Token.response_header("Content-Type", "text/html")
        |> Token.response_header("Location", "/")
        |> Token.response_body("Redirecting...")
    end
  end
end

defmodule Tapio.Web.Posts.View do
  def render("posts.json", %{posts: posts, user: user}) do
    %{
      items: Enum.map(posts, &render("post.json", %{post: &1, user: user}))
    }
  end

  def render("post.json", %{post: post, user: user}) do
    %{
      id: post.id,
      body: post.body,
      username: post.user.username,
      likes_count: post.likes_count,
      inserted_at: posted_at(post.inserted_at, user.timezone)
    }
  end

  def posted_at(timestamp, timezone) do
    timestamp
    |> DateTime.from_naive!("Etc/UTC")
    |> DateTime.shift_zone!(timezone)
    |> Timex.format!("%I:%M %p", :strftime)
  end
end
