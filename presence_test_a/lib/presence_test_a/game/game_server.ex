defmodule PresenceTestA.Game.GameServer do
  use GenServer, restart: :temporary

  alias PresenceTestA.Game.Game

  # Client API

  def start_link(game_id) do
    GenServer.start_link(__MODULE__, game_id, name: game_id)
  end

  # Server Callbacks

  @impl true
  def init(game_id) do
    state = %{
      game_id: game_id,
      game_state: %Game{}
    }

    {:ok, state, {:continue, :subscribe_presence}}
  end

  @impl true
  def handle_continue(:subscribe_presence, state) do
    state.game_id
    |> presence_topic()
    |> PresenceTestAWeb.Endpoint.subscribe()

    {:noreply, state}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: _payload}, state) do
    presences =
      state.game_id
      |> presence_topic()
      |> PresenceTestA.Presence.list()

    player_ids =
      presences
      |> Map.keys()
      |> Enum.map(&String.to_integer(&1))

    game_state =
      Game.set_players(
        state.game_state,
        player_ids
      )

    if presences == %{} do
      {:stop, :normal, game_state}
    else
      PresenceTestAWeb.Endpoint.broadcast!(
        game_updates_topic(state.game_id),
        "game_state_update",
        game_state
      )

      {:noreply, state}
    end
  end

  defp game_updates_topic(game_id), do: "game:updates:#{game_id}"

  defp presence_topic(game_id), do: "game:presences:#{game_id}"
end
