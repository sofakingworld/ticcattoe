defmodule TicCatToe.Match do
  defstruct room_name: nil, field_size: :small, field: nil, users: nil, winner: nil, turn: :xs
end