defmodule TiccattoeWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:" <> private_room_id, _message, socket) do
    GenServer.call(String.to_atom(private_room_id), {:set_user, socket.id})

    {:ok, :sys.get_state(String.to_atom(private_room_id)), socket}
  end

  def handle_in("put_sign", %{"row" => row, "col" => col}, socket) do
    "room:" <> genserver = socket.topic
    GenServer.call(String.to_atom(genserver), {:put_sign, socket.id, row, col})
    {:noreply, socket}
  end
end
