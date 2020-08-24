defmodule PresenceTestB.Game.Player do
  @type t :: %__MODULE__{
          id: pos_integer(),
          my_turn: boolean(),
          score: non_neg_integer()
        }

  @enforce_keys [:id]
  defstruct [:id, my_turn: false, score: 0]
end
