defmodule Tapio.Web.Handler do
  @moduledoc false

  import Aino.Middleware.Routes, only: [routes: 1, delete: 3, get: 3, post: 2, post: 3]

  @behaviour Aino.Handler

  routes([
    get("/", &Tapio.Web.Page.root/1, as: :root),
    get("/sign-in", &Tapio.Web.Session.show/1, as: :sign_in),
    post("/sign-in", &Tapio.Web.Session.create/1),
    delete("/sign-out", &Tapio.Web.Session.delete/1, as: :sign_out),
    post("/posts", &Tapio.Web.Posts.create/1, as: :posts),
    post("/posts/:id/like", &Tapio.Web.Likes.create/1, as: :post_like)
  ])

  @impl true
  def handle(token) do
    middleware = [
      &Aino.Middleware.Development.recompile/1,
      Aino.Middleware.common(),
      &Aino.Middleware.assets/1,
      &Aino.Session.config(&1, %Aino.Session.Cookie{key: "key", salt: "salt"}),
      &Aino.Session.decode/1,
      &Tapio.Web.Session.Fetch.call/1,
      &Aino.Middleware.Routes.routes(&1, routes()),
      &Aino.Middleware.Routes.match_route/1,
      &Aino.Middleware.params/1,
      &Aino.Middleware.Routes.handle_route/1,
      &Tapio.Web.Layout.wrap/1,
      &Aino.Session.encode/1,
      &Tapio.Web.Logging.call/1
    ]

    Aino.Token.reduce(token, middleware)
  end

  @impl true
  def sockets() do
    [{"/socket", Tapio.Web.Socket}]
  end
end

defmodule Tapio.Web.Logging do
  require Logger

  def call(token) do
    method = String.upcase(to_string(token.method))
    path = "/" <> Enum.join(token.path, "/")

    case Map.keys(token.params) == [] do
      true ->
        Logger.info("#{method} #{path}")

      false ->
        Logger.info("#{method} #{path}\nParameters: #{inspect(token.params)}")
    end

    token
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

    case Map.has_key?(state, :current_user) do
      true ->
        state = Map.put(state, :session, %{current_user: state.current_user})
        {:ok, state}

      false ->
        :shutdown
    end
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
          id: post.id,
          body: post.body,
          username: post.user.username,
          inserted_at: Tapio.Web.Page.View.posted_at(post.inserted_at, user.timezone)
        }
      }

    Map.put(token, :response, response)
  end

  def info(token, %Tapio.Event{event: "likes/new", data: like}) do
    response =
      %Aino.WebSocket.Event{
        event: "likes/new",
        data: Map.take(like, [:post_id])
      }

    Map.put(token, :response, response)
  end

  def info(token, _event) do
    token
  end
end
