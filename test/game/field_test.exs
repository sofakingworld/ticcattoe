defmodule TicCatToe.Game.FieldTest do
  use ExUnit.Case
  alias TicCatToe.Game.Field
  alias TicCatToe.Game.Cell

  describe "TicCatToe.Game.Field" do
    test "create_field(:small)" do
      assert Field.create_field(:small) |> length == 9
    end

    test "create_field(:medium)" do
      assert Field.create_field(:medium) |> length == 25
    end

    test "create_field(:large)" do
      assert Field.create_field(:large) |> length == 100
    end

    test "put_xs(current_field, row, col)" do
      field = Field.create_field(:small)
      assert [_1_1_n, %Cell{row: 1, col: 2, value: :xs},_1_3_n | _] = Field.put_xs(field, 1, 2) 
    end

    test "put_os(current_field, row, col)" do
      field = Field.create_field(:small)
      assert [%Cell{row: 1, col: 1, value: :os} | _] = Field.put_os(field, 1, 1) 
    end
  end

  describe "TicCatToe.Game.Field - wrong data" do
    test "create_field(:huge)" do
      assert_raise CaseClauseError, fn -> Field.create_field(:huge) end
    end

    test "trying put sign putside field" do
      field = Field.create_field(:small)
      assert field == Field.put_os(field, 1, 5)
    end

    test "trying put sign on other sign" do
      field = Field.create_field(:small)
      field_with_os = Field.put_os(field, 1, 3)
      assert field_with_os == Field.put_xs(field_with_os, 1,3)
    end
    
  end
end