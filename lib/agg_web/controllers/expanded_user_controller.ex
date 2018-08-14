defmodule AggWeb.ExpandedUserController do
  use AggWeb, :controller

  alias Agg.Upstream
  alias Agg.ExpandedUser

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => user_id}) do
    case Upstream.fetch_extended_user(user_id) do
      {:ok, extended_user} ->
        json(conn, ExpandedUser.to_json(extended_user))

      {:error, message} ->
        send_resp(conn, 400, message)
    end
  end

  def users_stream(conn, _) do
    conn =
      conn
      |> put_resp_content_type("application/ndjson")
      |> send_chunked(200)

    Upstream.fetch_users_stream()
    |> Stream.each(fn data ->
      chunk(conn, data)
    end)
    |> Stream.run()

    conn
  end
end
