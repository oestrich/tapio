defmodule Tapio.Web.Handler do
  @moduledoc false

  import Aino.Middleware.Routes, only: [delete: 3, get: 3, post: 2, post: 3]

  @behaviour Aino.Handler

  def routes() do
    [
      get("/", &Tapio.Web.Page.root/1, as: :root),
      get("/sign-in", &Tapio.Web.Session.show/1, as: :sign_in),
      post("/sign-in", &Tapio.Web.Session.create/1),
      delete("/sign-out", &Tapio.Web.Session.delete/1, as: :sign_out),
      get("/register", &Tapio.Web.Registration.new/1, as: :register),
      post("/register", &Tapio.Web.Registration.create/1),
      get("/posts", &Tapio.Web.Posts.index/1, as: :posts),
      post("/posts", &Tapio.Web.Posts.create/1),
      post("/posts/:id/like", &Tapio.Web.Likes.create/1, as: :post_like),
      get("/events", &Tapio.Web.Events.index/1, as: :events)
    ]
  end

  @impl true
  def handle(token) do
    middleware = [
      Aino.Middleware.common(),
      &Aino.Middleware.assets/1,
      # &Aino.Middleware.Development.recompile/1,
      &Aino.Session.config(&1, %Aino.Session.Cookie{key: "key", salt: "salt"}),
      &Aino.Session.decode/1,
      &Tapio.Web.Session.Fetch.call/1,
      &Aino.Middleware.Routes.routes(&1, routes()),
      &Aino.Middleware.Routes.match_route/1,
      &Aino.Middleware.params/1,
      &Aino.Middleware.Routes.handle_route/1,
      &Tapio.Web.Layout.wrap/1,
      &Aino.Session.encode/1,
      &Aino.Middleware.logging/1
    ]

    Aino.Token.reduce(token, middleware)
  end
end


defmodule Tapio.Web.Handler.Routes do
  @moduledoc false

  require Aino.Middleware.Routes

  Aino.Middleware.Routes.compile(Tapio.Web.Handler.routes())
end
