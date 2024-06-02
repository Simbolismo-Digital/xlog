defmodule Xlog.Repo do
  use Ecto.Repo,
    otp_app: :xlog,
    adapter: Ecto.Adapters.Postgres
end
