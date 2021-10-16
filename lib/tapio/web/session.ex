defmodule Tapio.Web.Session do
  alias Aino.Session
  alias Aino.Token
  alias Tapio.Web.Session.View
  alias Tapio.Users

  def show(token) do
    token
    |> Token.response_status(200)
    |> Token.response_header("Content-Type", "text/html")
    |> Token.response_body(View.render("sign_in.html"))
  end

  def create(%{params: %{"password" => password, "username" => username}} = token) do
    case Users.validate_login(username, password) do
      {:ok, user} ->
        token
        |> Token.response_status(302)
        |> Token.response_header("Content-Type", "text/html")
        |> Token.response_header("Location", "/")
        |> Token.response_body("Redirecting...")
        |> Session.Token.put("token", user.token)

      {:error, :invalid} ->
        token
        |> Token.response_status(422)
        |> Token.response_header("Content-Type", "text/html")
        |> Token.response_body(View.render("sign_in.html"))
    end
  end

  def delete(token) do
    token
    |> Session.Token.clear()
    |> Token.response_status(302)
    |> Token.response_header("Content-Type", "text/html")
    |> Token.response_header("Location", "/")
    |> Token.response_body("Redirecting...")
  end
end

defmodule Tapio.Web.Session.View do
  require Aino.View

  Aino.View.compile [
    "lib/tapio/web/templates/session/sign_in.html.eex"
  ]
end

defmodule Tapio.Web.Session.Fetch do
  alias Tapio.Users

  def call(token) do
    user_token = token.session["token"]

    case !is_nil(user_token) do
      true ->
        case Users.from_token(user_token) do
          {:ok, user} ->
            Map.put(token, :current_user, user)

          {:error, :not_found} ->
            Aino.Session.Token.clear(token)
        end

      false ->
        token
    end
  end
end
