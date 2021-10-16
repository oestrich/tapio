defmodule Tapio.Web.Handler do
  @moduledoc false

  import Aino.Middleware.Routes, only: [delete: 2, get: 2, post: 2]

  @behaviour Aino.Handler

  @impl true
  def handle(token) do
    routes = [
      get("/", &Tapio.Web.Page.root/1),
      get("/sign-in", &Tapio.Web.Session.show/1),
      post("/sign-in", &Tapio.Web.Session.create/1),
      delete("/sign-out", &Tapio.Web.Session.delete/1),
      post("/posts", &Tapio.Web.Posts.create/1)
    ]

    middleware = [
      &Aino.Middleware.Development.recompile/1,
      Aino.Middleware.common(),
      &Aino.Session.config(&1, %Aino.Session.Cookie{key: "key", salt: "salt"}),
      &Aino.Session.decode/1,
      &Tapio.Web.Session.Fetch.call/1,
      &Aino.Middleware.Routes.routes(&1, routes),
      &Aino.Middleware.Routes.match_route/1,
      &Aino.Middleware.params/1,
      &Aino.Middleware.Routes.handle_route/1,
      &Tapio.Web.Layout.wrap/1,
      &Aino.Session.encode/1
    ]

    Aino.Token.reduce(token, middleware)
  end

  @impl true
  def sockets() do
    [{"/socket", Tapio.Web.Socket}]
  end
end

defmodule Tapio.Web.Socket do
  @behaviour Aino.WebSocket.Handler

  @impl true
  def init(state) do
    Phoenix.PubSub.subscribe(Tapio.PubSub, "posts")

    middleware = [
      &Aino.Middleware.headers/1,
      &Aino.Middleware.cookies/1,
      &Aino.Session.config(&1, %Aino.Session.Cookie{key: "key", salt: "salt"}),
      &Aino.Session.decode/1,
      &Tapio.Web.Session.Fetch.call/1
    ]

    state = Aino.Token.reduce(state, middleware)

    state = Map.put(state, :session, %{current_user: state.current_user})

    {:ok, state}
  end

  @impl true
  def handle(token, _message) do
    token
  end

  @impl true
  def info(token, %Tapio.Event{event: "posts/new", data: post}) do
    %{current_user: user} = token.session

    response =
      %Aino.WebSocket.Event{
        event: "posts/new",
        data: %{
          body: post.body,
          username: post.user.username,
          inserted_at: Tapio.Web.Page.View.posted_at(post.inserted_at, user.timezone)
        }
      }

    Map.put(token, :response, response)
  end
end
