defmodule Ticcattoe.Matchmaking do
  def rooms_for_join do
    room_list
    |> Enum.map(&room_state/1)
    |> Enum.map(fn state ->
      %{
        room_name: state.room_name,
        user_count: length(Map.keys(state.users)),
        field_size: state.field_size
      }
    end)
    |> Enum.filter(fn room -> room[:user_count] == 1 end)
  end

  defp room_state(pid) do
    :sys.get_state(pid)
  end

  defp room_list do
    Process.list()
    |> Enum.filter(fn pid ->
      case to_string(Process.info(pid)[:registered_name]) do
        "room:" <> _part -> true
        _ -> false
      end
    end)
  end
end
