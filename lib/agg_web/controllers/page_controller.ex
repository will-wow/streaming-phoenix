defmodule AggWeb.PageController do
  use AggWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
