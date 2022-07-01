defmodule Ascend.Repo do
  use Ecto.Repo,
    otp_app: :ascend,
    adapter: Ecto.Adapters.SQLite3
end
