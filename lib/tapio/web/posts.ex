defmodule Tapio.Web.Posts do
  alias Aino.Token
  alias Tapio.Posts
  alias Tapio.Web.Posts.View

  def create(%{current_user: current_user, params: params} = token) do
    case Posts.create(current_user, params) do
      {:ok, post} ->
        case Token.request_header(token, "accept") do
          ["application/json"] ->
            token
            |> Token.response_status(201)
            |> Token.response_header("Content-Type", "application/json")
            |> Token.response_body(Jason.encode!(View.render("post.json", %{post: post})))

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
  def render("post.json", %{post: post}) do
    %{
      id: post.id,
      body: post.body
    }
  end
end
