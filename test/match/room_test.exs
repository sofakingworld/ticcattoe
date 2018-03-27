defmodule Ticcattoe.RoomTest do
  use ExUnit.Case

  alias Ticcattoe.Match

  describe "Ticcattoe.Game" do
    test "win" do
      Ticcattoe.Room.start_link(%Ticcattoe.Match{room_name: Win})
      GenServer.call(Win, {:set_user, :xs})
      GenServer.call(Win, {:set_user, :os})
      assert %Match{} = GenServer.call(Win, {:put_sign, :xs, 1, 1})
      GenServer.call(Win, {:put_sign, :os, 2, 1})
      GenServer.call(Win, {:put_sign, :xs, 1, 2})
      GenServer.call(Win, {:put_sign, :os, 2, 2})
      result = GenServer.call(Win, {:put_sign, :xs, 1, 3})
      assert result.winner == :xs
    end

    test "draw" do
      Ticcattoe.Room.start_link(%Ticcattoe.Match{room_name: Draw})
      GenServer.call(Draw, {:set_user, :xs})
      GenServer.call(Draw, {:set_user, :os})
      assert %Match{} = GenServer.call(Draw, {:put_sign, :xs, 1, 1})
      GenServer.call(Draw, {:put_sign, :os, 2, 1})
      GenServer.call(Draw, {:put_sign, :xs, 1, 2})
      GenServer.call(Draw, {:put_sign, :os, 2, 2})
      GenServer.call(Draw, {:put_sign, :xs, 2, 3})
      GenServer.call(Draw, {:put_sign, :os, 1, 3})
      GenServer.call(Draw, {:put_sign, :xs, 3, 1})
      GenServer.call(Draw, {:put_sign, :os, 3, 2})
      result = GenServer.call(Draw, {:put_sign, :xs, 3, 3})
      assert result.turn == :none && result.winner == :none
    end

    test "wrong moves" do
      Ticcattoe.Room.start_link(%Ticcattoe.Match{room_name: WrongMoves})
      GenServer.call(WrongMoves, {:set_user, :xs})
      GenServer.call(WrongMoves, {:set_user, :os})
      assert %Match{} = GenServer.call(WrongMoves, {:put_sign, :xs, 1, 1})
      assert :wrong_turn = GenServer.call(WrongMoves, {:put_sign, :xs, 2, 1})
      game_state = GenServer.call(WrongMoves, {:put_sign, :os, 2, 1})
      assert :wrong_turn = GenServer.call(WrongMoves, {:put_sign, :os, 2, 2})
      # Game state doesnt change if put sign on not empty cell
      assert game_state == GenServer.call(WrongMoves, {:put_sign, :xs, 2, 1})
      GenServer.call(WrongMoves, {:put_sign, :xs, 1, 2})
      GenServer.call(WrongMoves, {:put_sign, :os, 2, 2})
      GenServer.call(WrongMoves, {:put_sign, :xs, 1, 3})
      assert :game_ended = GenServer.call(WrongMoves, {:put_sign, :os, 2, 3})
    end
  end
end
