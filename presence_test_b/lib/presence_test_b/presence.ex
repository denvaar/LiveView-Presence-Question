defmodule PresenceTestB.Presence do
  use Phoenix.Presence,
    otp_app: :presence_test_b,
    pubsub_server: PresenceTestB.PubSub

  defdelegate list(topic), to: Phoenix.Presence

  @spec track_player(String.t(), pos_integer()) :: :ok | {:error, term()}
  def track_player(topic, player_id) do
    track(self(), topic, player_id, %{})
  end
end
