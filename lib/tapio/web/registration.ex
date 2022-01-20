defmodule Tapio.Web.Registration do
  alias Aino.Session
  alias Aino.Token
  alias Tapio.Users
  alias Tapio.Web.Registration.View

  def new(token) do
    token
    |> Token.response_status(200)
    |> Token.response_header("Content-Type", "text/html")
    |> View.render("new.html")
  end

  def create(%{params: params} = token) do
    case Users.create(params) do
      {:ok, user} ->
        token
        |> Token.response_status(302)
        |> Token.response_header("Content-Type", "text/html")
        |> Token.response_header("Location", "/")
        |> Token.response_body("Redirecting...")
        |> Session.Token.put("token", user.token)

      {:error, _changeset} ->
        token
        |> Token.response_status(422)
        |> Token.response_header("Content-Type", "text/html")
        |> View.render("new.html")
    end
  end
end

defmodule Tapio.Web.Registration.View do
  require Aino.View

  alias Tapio.Web.Handler.Routes

  Aino.View.compile([
    "lib/tapio/web/templates/registration/new.html.eex"
  ])
end
