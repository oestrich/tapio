defmodule Tapio.Web.Page do
  alias Aino.Token
  alias Tapio.Web.Page.View
  alias Tapio.Posts

  def root(token) do
    case token[:current_user] != nil do
      true ->
        posts = Posts.all()

        token
        |> Token.response_status(200)
        |> Token.response_header("Content-Type", "text/html")
        |> Token.response_body(View.render("root.html", %{posts: posts}))

      false ->
        token
        |> Token.response_status(200)
        |> Token.response_header("Content-Type", "text/html")
        |> Token.response_body(View.render("marketing.html"))
    end
  end
end

defmodule Tapio.Web.Page.View do
  require Aino.View

  Aino.View.compile [
    "lib/tapio/web/templates/pages/marketing.html.eex",
    "lib/tapio/web/templates/pages/root.html.eex"
  ]

  def posted_at(timestamp, timezone) do
    timestamp
    |> DateTime.from_naive!("Etc/UTC")
    |> DateTime.shift_zone!(timezone)
    |> Timex.format!("%I:%M %p", :strftime)
  end
end
