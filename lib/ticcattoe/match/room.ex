defmodule TicCatToe.Room do
  alias TicCatToe.Match
  alias TicCatToe.Game
  alias TicCatToe.Game.Field
  use GenServer

  def start_link(%Match{} = initial_data) do
    GenServer.start_link(__MODULE__, initial_data, name: initial_data.room_name)
  end

  def init(initial_data) do
    state = Map.merge(initial_data, %{field: Field.create_field(initial_data.field_size)})
    stop_after_1_hour()
    {:ok, state}
  end

  def handle_call({:put_xs, row, col}, _from, %Match{} = state) do
    case check_allowity(state, :xs) do
      :ok ->
        field = Field.put_xs(state.field, row, col)

        state = change_game_state(state, field)

        {:reply, state, state}

      other ->
        {:reply, other, state}
    end
  end

  def handle_call({:put_os, row, col}, _from, %Match{} = state) do
    case check_allowity(state, :os) do
      :ok ->
        field = Field.put_os(state.field, row, col)

        state = change_game_state(state, field)

        {:reply, state, state}

      other ->
        {:reply, other, state}
    end
  end

  # PRIVATE ZONE

  defp check_allowity(%Match{} = state, sign) do
    cond do
      sign not in [:xs, :os] -> :wrong_sign
      state.turn != sign -> :wrong_turn
      state.turn == :none -> :game_ended
      state.winner not in [nil, :none] -> :game_ended
      true -> :ok
    end
  end

  defp change_game_state(%Match{} = state, field) do
    Map.merge(state, %{
      field: field,
      winner: Game.find_winner(field, Field.win_count(state.field_size)),
      turn: Game.turn(field)
    })
  end

  defp stop_after_1_hour() do
    Process.send_after(self(), :stop, 1000 * 3600)
  end

  def handle_info(:stop, state) do
    GenServer.stop(state.room_name)
    {:noreply, state}
  end
end
