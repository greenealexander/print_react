defmodule PrintReact.Repo do
  use Ecto.Repo,
    otp_app: :print_react,
    adapter: Ecto.Adapters.Postgres
end
