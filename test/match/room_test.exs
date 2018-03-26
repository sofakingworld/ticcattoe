defmodule TicCatToe.RoomTest do
  use ExUnit.Case

  alias TicCatToe.Match
  
  describe "TicCatToe.Game" do
    test "win" do
      TicCatToe.Room.start_link(%TicCatToe.Match{room_name: Win})
      assert %Match{} = GenServer.call(Win, {:put_xs, 1,1})
      GenServer.call(Win, {:put_os, 2,1})
      GenServer.call(Win, {:put_xs, 1,2})
      GenServer.call(Win, {:put_os, 2,2})
      result = GenServer.call(Win, {:put_xs, 1,3})
      assert result.winner == :xs
    end

    test "draw" do
      TicCatToe.Room.start_link(%TicCatToe.Match{room_name: Draw})
      assert %Match{} = GenServer.call(Draw, {:put_xs, 1,1})
      GenServer.call(Draw, {:put_os, 2,1})
      GenServer.call(Draw, {:put_xs, 1,2})
      GenServer.call(Draw, {:put_os, 2,2})
      GenServer.call(Draw, {:put_xs, 2,3})
      GenServer.call(Draw, {:put_os, 1,3})
      GenServer.call(Draw, {:put_xs, 3,1})
      GenServer.call(Draw, {:put_os, 3,2})
      result = GenServer.call(Draw, {:put_xs, 3,3})
      assert result.turn == :none && result.winner == :none
    end

    test "wrong moves" do
      TicCatToe.Room.start_link(%TicCatToe.Match{room_name: WrongMoves})
      assert %Match{} = GenServer.call(WrongMoves, {:put_xs, 1,1})
      assert :wrong_turn = GenServer.call(WrongMoves, {:put_xs, 2,1})
      game_state = GenServer.call(WrongMoves, {:put_os, 2,1})
      assert :wrong_turn = GenServer.call(WrongMoves, {:put_os, 2,2})
      # Game state doesnt change if put sign on not empty cell
      assert game_state == GenServer.call(WrongMoves, {:put_xs, 2,1})
      GenServer.call(WrongMoves, {:put_xs, 1,2})
      GenServer.call(WrongMoves, {:put_os, 2,2})
      GenServer.call(WrongMoves, {:put_xs, 1,3})
      assert :game_ended = GenServer.call(WrongMoves, {:put_os, 2,3})
    end
  end
end