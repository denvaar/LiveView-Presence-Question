defmodule PresenceTestA.Repo do
  use Ecto.Repo,
    otp_app: :presence_test_a,
    adapter: Ecto.Adapters.Postgres
end
