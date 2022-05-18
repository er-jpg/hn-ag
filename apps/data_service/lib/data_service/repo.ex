defmodule DataService.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :data_service,
    adapter: Ecto.Adapters.Postgres
end
