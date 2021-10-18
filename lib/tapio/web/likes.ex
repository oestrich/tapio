defmodule Tapio.Web.Likes do
  alias Aino.Token
  alias Tapio.Posts

  def create(%{current_user: current_user, params: %{"id" => id}} = token) do
    {:ok, post} = Posts.get(id)

    case Posts.like(post, current_user) do
      {:ok, _list} ->
        case Token.request_header(token, "accept") do
          ["application/json"] ->
            token
            |> Token.response_status(201)
            |> Token.response_header("Content-Type", "application/json")
            |> Token.response_body("{}")

          _ ->
            token
            |> Token.response_status(302)
            |> Token.response_header("Content-Type", "text/html")
            |> Token.response_header("Location", "/")
            |> Token.response_body("Redirecting...")
        end

      {:error, _changeset} ->
        case Token.request_header(token, "accept") do
          ["application/json"] ->
            token
            |> Token.response_status(400)
            |> Token.response_header("Content-Type", "application/json")
            |> Token.response_body("{}")
        end
    end
  end
end
