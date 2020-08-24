# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :presence_test_a,
  ecto_repos: [PresenceTestA.Repo]

# Configures the endpoint
config :presence_test_a, PresenceTestAWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hAzOtqEwE0W7f4yaM1kZj+SQIX45pEOMHWzXMjSF6jtBAArk2KsdfvaE8fK7/l8N",
  render_errors: [view: PresenceTestAWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PresenceTestA.PubSub,
  live_view: [signing_salt: "MQa3L+3A"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
