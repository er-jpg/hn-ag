import Config

config :http_service, HttpService.Endpoint,
  url: [host: "localhost", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :data_service, DataService.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: 5
