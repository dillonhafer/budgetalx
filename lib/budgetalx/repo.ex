defmodule Budgetalx.Repo do
  use Ecto.Repo,
    otp_app: :budgetalx,
    adapter: Ecto.Adapters.Postgres
end
