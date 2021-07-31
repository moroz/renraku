import Config

import_config("dev.exs")

# Configure your database
config :renraku, Renraku.Repo,
  username: "postgres",
  password: "postgres",
  database: "renraku_dev",
  hostname: "pg",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :renraku, RenrakuWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []
