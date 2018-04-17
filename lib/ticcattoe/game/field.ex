defmodule Ticcattoe.Game.Field do
  @moduledoc false

  alias Ticcattoe.Game.Cell

  @doc """
  Function creates Field of setted size:

  small - 3x3

  medium - 5x5

  large - 10x10

  # example

  Ticcattoe.Game.Field.create_field(:small) => [%Cell{}, ...]
  """
  def create_field(size) do
    case size do
      :small -> field_by_size(3, 3)
      :medium -> field_by_size(5, 5)
      :large -> field_by_size(10, 10)
    end
  end

  @doc """
  returns count of signs in one line for win
  """
  def win_count(size) do
    case size do
      :small -> 3
      :medium -> 4
      :large -> 5
    end
  end

  @doc """
  Functions set cell sign to :xs and returns changed field
  """
  def put_xs(current_field, row, col) do
    set_value_to_cell(current_field, row, col, :xs)
  end

  @doc """
  Functions set cell sign to :os and returns changed field
  """
  def put_os(current_field, row, col) do
    set_value_to_cell(current_field, row, col, :os)
  end

  defp set_value_to_cell(field, row, col, value) do
    field
    |> Enum.map(fn cell ->
      case cell.row == row && cell.col == col && is_nil(cell.value) do
        true -> Map.merge(cell, %{value: value})
        false -> cell
      end
    end)
  end

  defp field_by_size(rows, cols) do
    for r <- 1..rows do
      for c <- 1..cols do
        %Cell{row: r, col: c}
      end
    end
    |> List.flatten()
  end
end
