defmodule PresenceTestA.Game.Game do
  alias PresenceTestA.Game.Player

  @type status :: :setup | :lobby | :playing | :ended

  @type t :: %__MODULE__{
          status: status(),
          players: list(Player.t())
        }

  defstruct status: :lobby, players: []

  @spec set_players(t(), list(pos_integer())) :: t()
  def set_players(game, ids) do
    %{game | players: Enum.map(ids, fn id -> %Player{id: id} end)}
  end

  @spec set_player_turn(t(), pos_integer()) :: t()
  def set_player_turn(game, player_id) do
    %{
      game
      | players:
          Enum.map(game.players, fn player ->
            %{player | my_turn: player.id == player_id}
          end)
    }
  end

  @spec update_score(t(), pos_integer(), integer()) :: t()
  def update_score(game, player_id, value) do
    %{
      game
      | players:
          Enum.map(game.players, fn player ->
            if player.id == player_id do
              %{player | score: player.score + value}
            else
              player
            end
          end)
    }
  end

  @spec transition_game_status(t()) :: t()
  def transition_game_status(game) do
    %{game | status: next_status(game.status)}
  end

  defp next_status(:setup), do: :lobby
  defp next_status(:lobby), do: :playing
  defp next_status(:playing), do: :ended
  defp next_status(status), do: status
end
