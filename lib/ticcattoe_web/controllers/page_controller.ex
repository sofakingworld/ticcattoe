defmodule TiccattoeWeb.PageController do
  alias Ticcattoe.Room
  alias Ticcattoe.Match

  use TiccattoeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, %{"field_size" => size}) do
    room_name = String.to_atom(UUID.uuid4())
    Room.start_link(%Match{room_name: room_name, field_size: String.to_atom(size)})
    redirect conn, to: "/join?lobby=#{room_name}"
  end

  def join(conn, %{"lobby" => lobby_uuid}) do
    case is_nil(conn.cookies["player_cookie"]) do
      true -> Plug.Conn.put_resp_cookie(conn, "player_cookie", UUID.uuid4(), http_only: false)
      false -> conn
    end
    |> render("join.html", lobby: lobby_uuid)
  end
end
