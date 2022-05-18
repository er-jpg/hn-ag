import Config

if config_env() == :prod do
  {:ok, _} = Application.ensure_all_started(:hackney)

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :http_service, HttpService.Endpoint,
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: secret_key_base

  config :http_service, HttpService.Endpoint, server: true

  config :data_service, DataService.Repo,
    url: System.get_env("DATABASE_URL"),
    pool_size: 5
end
