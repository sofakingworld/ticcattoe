defmodule Ticcattoe.GameTest do
  use ExUnit.Case
  alias Ticcattoe.Game
  alias Ticcattoe.Game.Cell
  alias Ticcattoe.Game.Field

  describe "Ticcattoe.Game" do
    test "find_winner(field) - early for winner" do
      field = Field.create_field(:small)
      assert Game.find_winner(field, 3) == :none
    end

    test "find_winner(field) - horizontally winner" do
      field = [
        %Cell{row: 2, col: 1, value: :xs},
        %Cell{row: 2, col: 2, value: :xs},
        %Cell{row: 2, col: 3, value: :xs}
      ]

      assert Game.find_winner(field, 3) == :xs
    end

    test "find_winner(field) - vertically winner" do
      field = [
        %Cell{row: 1, col: 2, value: :os},
        %Cell{row: 2, col: 2, value: :os},
        %Cell{row: 3, col: 2, value: :os}
      ]

      assert Game.find_winner(field, 3) == :os
    end

    test "find_winner(field) - no winner if no sequence" do
      field = [
        %Cell{row: 1, col: 2, value: :os},
        %Cell{row: 2, col: 2, value: :xs},
        %Cell{row: 3, col: 2, value: :os}
      ]

      assert Game.find_winner(field, 3) == :none
    end

    test "find_winner(field) - diogonal (top to down) winner" do
      field = [
        %Cell{row: 2, col: 4, value: :os},
        %Cell{row: 3, col: 5, value: :os},
        %Cell{row: 4, col: 6, value: :os}
      ]

      assert Game.find_winner(field, 3) == :os
    end

    test "find_winner(field) - diogonal (down to top) winner" do
      field = [
        %Cell{row: 4, col: 5, value: :xs},
        %Cell{row: 3, col: 6, value: :xs},
        %Cell{row: 2, col: 7, value: :xs}
      ]

      assert Game.find_winner(field, 3) == :xs
    end

    test "find_winner(field) - diogonal (down to top) no winner if 5 for win" do
      field = [
        %Cell{row: 4, col: 5, value: :xs},
        %Cell{row: 3, col: 6, value: :xs},
        %Cell{row: 2, col: 7, value: :xs}
      ]

      assert Game.find_winner(field, 5) == :none
    end

    test "find_winner(field) - horizontal (down to top) winner if 5 for win" do
      field = [
        %Cell{row: 2, col: 1, value: nil},
        %Cell{row: 2, col: 2, value: :xs},
        %Cell{row: 2, col: 3, value: :xs},
        %Cell{row: 2, col: 4, value: :xs},
        %Cell{row: 2, col: 5, value: :xs},
        %Cell{row: 2, col: 6, value: :xs}
      ]

      assert Game.find_winner(field, 5) == :xs
    end

    test "turn(field)" do
      # empty field
      field = [%Cell{}, %Cell{}]
      assert Game.turn(field) == :xs

      field_1 = [%Cell{value: :xs}, %Cell{}]
      assert Game.turn(field_1) == :os

      field_2 = [%Cell{value: :xs}, %Cell{value: :os}]
      assert Game.turn(field_2) == :none
    end
  end
end
