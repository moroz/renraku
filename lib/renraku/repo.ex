defmodule Renraku.Repo do
  use Ecto.Repo,
    otp_app: :renraku,
    adapter: Ecto.Adapters.Postgres
end
