defmodule PresenceTestA.Presence do
  use Phoenix.Presence,
    otp_app: :presence_test_a,
    pubsub_server: PresenceTestA.PubSub

  defdelegate list(topic), to: Phoenix.Presence

  @spec track_player(String.t(), pos_integer()) :: :ok | {:error, term()}
  def track_player(topic, player_id) do
    track(self(), topic, player_id, %{})
  end
end
