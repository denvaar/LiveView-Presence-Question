defmodule PresenceTestBWeb.PageLive do
  use PresenceTestBWeb, :live_view

  alias PresenceTestB.Game.{GameServer, Game}

  @impl true
  def mount(%{"game_id" => game_id}, _session, socket) do
    player_id = Enum.random(1..100)

    if connected?(socket) do
      GameServer.start_link(String.to_atom(game_id))

      PresenceTestBWeb.Endpoint.subscribe("game:#{game_id}")

      PresenceTestB.Presence.track_player(
        "game:#{game_id}",
        player_id
      )

      {:ok, assign(socket, game: %Game{}, game_id: game_id, current_user_id: player_id)}
    else
      {:ok, assign(socket, game: nil, game_id: game_id, current_user_id: player_id)}
    end
  end

  def mount(params, _session, socket) do
    {:ok, assign(socket, game: nil)}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    IO.inspect(self(), label: "DIFF")

    presences = PresenceTestB.Presence.list("game:#{socket.assigns.game_id}")

    player_ids =
      presences
      |> Map.keys()
      |> Enum.map(&String.to_integer(&1))

    game_state =
      GameServer.set_players(
        String.to_atom(socket.assigns.game_id),
        player_ids
      )

    {:noreply, assign(socket, game: game_state)}
  end
end
