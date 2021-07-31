defmodule RenrakuWeb.PageController do
  use RenrakuWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
