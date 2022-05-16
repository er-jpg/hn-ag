defmodule DataService.Repo do
  IO.inspect("çlakldçlaskdçalskd")

  use Ecto.Repo,
    otp_app: :data_service,
    adapter: Ecto.Adapters.Postgres
end
