defmodule Calenzy.Repo do
  use Ecto.Repo,
    otp_app: :calenzy,
    adapter: Ecto.Adapters.Postgres
end
