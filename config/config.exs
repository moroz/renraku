# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :renraku,
  ecto_repos: [Renraku.Repo]

# Configures the endpoint
config :renraku, RenrakuWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tZ0zysl5eYwzf7GOwlpf8nUgJsy6cE9qH6guze3ucgpppLqiXtTxkjjD25R/yql8",
  render_errors: [view: RenrakuWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Renraku.PubSub,
  live_view: [signing_salt: "8YRXmB7i"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine,
  slimleex: PhoenixSlime.LiveViewEngine

config :phoenix_slime, :use_slim_extension, true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
