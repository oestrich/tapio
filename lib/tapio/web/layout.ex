defmodule Tapio.Web.Layout do
  alias Aino.Token
  alias Tapio.Web.Handler.Routes

  require Aino.View

  import Aino.View, only: [safe: 1]

  Aino.View.compile([
    "lib/tapio/web/templates/layout/app.html.eex"
  ])

  def wrap(token) do
    case Token.response_header(token, "content-type") do
      ["text/html"] ->
        assigns = Map.take(token, [:current_user])
        assigns = Map.put(assigns, :inner_content, safe(token.response_body))

        render(token, "app.html", assigns)

      _ ->
        token
    end
  end
end
