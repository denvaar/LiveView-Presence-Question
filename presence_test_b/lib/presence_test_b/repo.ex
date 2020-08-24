defmodule PresenceTestB.Repo do
  use Ecto.Repo,
    otp_app: :presence_test_b,
    adapter: Ecto.Adapters.Postgres
end
