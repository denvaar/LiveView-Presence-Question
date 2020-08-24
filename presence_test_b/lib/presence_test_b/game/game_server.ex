defmodule PresenceTestB.Game.GameServer do
  use GenServer, restart: :temporary

  alias PresenceTestB.Game.Game

  # Client API

  def start_link(game_id) do
    GenServer.start_link(__MODULE__, game_id, name: game_id)
  end

  def set_players(game_id, player_ids) do
    GenServer.call(game_id, {:set_players, player_ids})
  end

  # Server Callbacks

  @impl true
  def init(game_id) do
    state = %{
      game_id: game_id,
      game_state: %Game{}
    }

    {:ok, state}
  end

  @impl true
  def handle_call({:set_players, player_ids}, _from, state) do
    new_game_state = Game.set_players(state.game_state, player_ids)
    new_state = %{state | game_state: new_game_state}
    {:reply, new_game_state, new_state}
  end
end
