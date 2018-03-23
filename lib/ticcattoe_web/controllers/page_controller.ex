defmodule TiccattoeWeb.PageController do
  use TiccattoeWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
