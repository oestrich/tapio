defmodule Tapio.Web.Events do
  alias Aino.Token

  def index(token) do
    token
    |> Token.response_status(200)
    |> Token.response_header("Content-Type", "text/event-stream")
    |> Map.put(:chunk, true)
    |> Map.put(:handler, Tapio.Web.Events.Handler)
  end
end

defmodule Tapio.Web.Events.Handler do
  @behaviour Aino.ChunkedHandler

  @impl true
  def init(token) do
    :timer.send_interval(30_000, :ping)

    Phoenix.PubSub.subscribe(Tapio.PubSub, "posts")

    {:ok, token}
  end

  @impl true
  def handle({_pid, :ok}, token) do
    {:ok, token}
  end

  def handle(:ping, token) do
    json = Jason.encode!(%{time: DateTime.utc_now()})
    response = "event: ping\ndata: #{json}\n\n"
    {:ok, response, token}
  end

  def handle(%Tapio.Event{event: event, data: data}, token) do
    case event do
      "likes/new" ->
        new_like(token, data)

      "posts/new" ->
        new_post(token, data)
    end
  end

  defp new_like(token, like) do
    response = %Aino.Event{
      event: "likes/new",
      data: Jason.encode!(Map.take(like, [:post_id]))
    }

    {:ok, response, token}
  end

  defp new_post(token, post) do
    %{current_user: user} = token

    response = %Aino.Event{
      event: "posts/new",
      data: Jason.encode!(%{
        id: post.id,
        body: post.body,
        username: post.user.username,
        likes_count: post.likes_count,
        inserted_at: Tapio.Web.Page.View.posted_at(post.inserted_at, user.timezone)
      })
    }

    {:ok, response, token}
  end
end
