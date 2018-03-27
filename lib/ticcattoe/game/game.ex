defmodule Ticcattoe.Game do
  @moduledoc false

  alias Ticcattoe.Game.Cell

  @doc """
  function returns whose turn to put sign
  """
  def turn(field) do
    calculate_turn(field)
  end

  @doc """
  function returns winner sign on the field, or :none, if nobody win 
  and there are empty cells on field, or returns :draw, if there are
  no empty cells and nobody win
  """
  def find_winner(field, count_for_win) do
    result =
      check_horizontally(field, count_for_win) || check_vertically(field, count_for_win) ||
        check_diagonal(field, count_for_win, &top_to_down/3) ||
        check_diagonal(field, count_for_win, &down_to_top/3)

    case result do
      :xs -> :xs
      :os -> :os
      nil -> :none
    end
  end

  # PRIVATE ZONE

  defp calculate_steps(field) do
    # acc - counter of signs [xs, os]
    field
    |> Enum.reduce([0, 0], fn cell, acc ->
      case cell.value do
        :xs ->
          [xs, os] = acc
          [xs + 1, os]

        :os ->
          [xs, os] = acc
          [xs, os + 1]

        _ ->
          acc
      end
    end)
  end

  defp calculate_turn(field) do
    [xs, os] = calculate_steps(field)

    cond do
      Enum.sum([xs, os]) == length(field) -> :none
      xs > os -> :os
      xs <= os -> :xs
    end
  end

  defp check_diagonal(field, count_for_win, diagonal_function) do
    Enum.map(field, fn cell ->
      for i <- 0..count_for_win do
        cell =
          Enum.find(field, fn search_cell ->
            diagonal_function.(cell, search_cell, i)
          end)

        case cell do
          %Cell{} -> cell.value
          _ -> nil
        end
      end
      |> Enum.filter(fn element -> !is_nil(element) end)
    end)
    |> get_sequence(count_for_win)
  end

  defp top_to_down(main_cell, search_cell, i) do
    search_cell.row == main_cell.row + i && search_cell.col == main_cell.col + i
  end

  defp down_to_top(main_cell, search_cell, i) do
    search_cell.row == main_cell.row - i && search_cell.col == main_cell.col + i
  end

  # finds winner in rows
  defp check_horizontally(field, count_for_win) do
    field
    |> Enum.group_by(fn cell -> cell.row end)
    |> values_for_cells
    |> get_sequence(count_for_win)
  end

  # finds winner in cols
  defp check_vertically(field, count_for_win) do
    field
    |> Enum.group_by(fn cell -> cell.col end)
    |> values_for_cells
    |> get_sequence(count_for_win)
  end

  defp values_for_cells(grouped_hash) do
    grouped_hash
    |> Map.values()
    |> Enum.map(fn list_of_cells ->
      Enum.map(list_of_cells, fn cell ->
        cell.value
      end)
    end)
  end

  # this function returns atom sequence of signs, or nil
  defp get_sequence(list_of_signs, count_to_win) do
    result =
      Enum.map(list_of_signs, fn signs ->
        chunks = Enum.chunk_every(signs, count_to_win, 1, [nil])

        Enum.map(chunks, fn chunk ->
          Enum.uniq(chunk)
        end)
        |> Enum.filter(fn uniq -> length(uniq) == 1 end)
      end)
      |> List.flatten()
      |> Enum.filter(fn val -> !is_nil(val) end)
      |> List.first()

    case result do
      :xs -> :xs
      :os -> :os
      _ -> nil
    end
  end
end
