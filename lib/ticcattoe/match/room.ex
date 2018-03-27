defmodule Ticcattoe.Room do
  alias Ticcattoe.Match
  alias Ticcattoe.Game
  alias Ticcattoe.Game.Field
  require Logger
  use GenServer

  def start_link(%Match{} = initial_data) do
    Logger.info("starting #{initial_data.room_name}")
    GenServer.start_link(__MODULE__, initial_data, name: initial_data.room_name)
  end

  def init(initial_data) do
    state = Map.merge(initial_data, %{field: Field.create_field(initial_data.field_size)})
    stop_after_1_hour()
    {:ok, state}
  end

  def handle_call({:set_user, user_id}, _from, %Match{} = state) do
    state =
      case state.users do
        nil -> Map.merge(state, %{users: %{xs: user_id}})
        %{xs: xs_id} -> Map.merge(state, %{users: %{xs: xs_id, os: user_id}})
        _ -> state
      end

    {:reply, state, state}
  end

  def handle_call({:put_sign, user_id, row, col}, _from, %Match{} = state) do
    {result, state} =
      state.users
      |> Enum.filter(fn {_k, v} -> v == user_id end)
      |> Enum.map(fn {k, _v} -> k end)
      |> List.first()
      |> case do
        nil -> state
        :xs -> put_sign(:xs, row, col, state)
        :os -> put_sign(:os, row, col, state)
      end

    {:reply, result, state}
  end

  # PRIVATE ZONE

  defp put_sign(sign, row, col, state) do
    case check_allowity(state, sign) do
      :ok ->
        field =
          case sign do
            :xs -> Field.put_xs(state.field, row, col)
            :os -> Field.put_os(state.field, row, col)
          end

        state = change_game_state(state, field)

        TiccattoeWeb.Endpoint.broadcast("room:#{state.room_name}", "change", state)

        {state, state}

      other ->
        TiccattoeWeb.Endpoint.broadcast("room:#{state.room_name}", "info", %{information: other})

        {other, state}
    end
  end

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
    spawn(fn ->
      GenServer.stop(state.room_name)
    end)

    {:noreply, state}
  end
end
