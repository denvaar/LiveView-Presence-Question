defmodule PresenceTestAWeb.PageLive do
  use PresenceTestAWeb, :live_view

  alias PresenceTestA.Game.GameServer

  @impl true
  def mount(%{"game_id" => game_id}, _session, socket) do
    player_id = Enum.random(1..100)

    if connected?(socket) do
      {GameServer, String.to_atom(game_id)}
      |> PresenceTestA.GameSupervisor.start_child()

      PresenceTestAWeb.Endpoint.subscribe("game:updates:#{game_id}")

      PresenceTestA.Presence.track_player(
        "game:presences:#{game_id}",
        player_id
      )
    end

    {:ok, assign(socket, game: nil, current_user_id: player_id)}
  end

  def mount(params, _session, socket) do
    {:ok, assign(socket, game: nil)}
  end

  @impl true
  def handle_info(%{event: "game_state_update", payload: game}, socket) do
    IO.inspect(game, label: "update received")
    {:noreply, assign(socket, game: game)}
  end
end
