# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :http_service,
  generators: [context_app: false]

config :data_service, ecto_repos: [DataService.Repo]

config :data_service, DataService.Repo,
  database: "data_service_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"

# Configures the endpoint
config :http_service, HttpService.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: HttpService.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: HttpService.PubSub,
  live_view: [signing_salt: "DofWPwfq"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/http_service/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :http_service,
  generators: [context_app: false]

# Configures the endpoint
config :http_service, HttpService.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: HttpService.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: HttpService.PubSub,
  live_view: [signing_salt: "oLPP2XRL"]

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#
# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use Hackney adapter for Tesla
config :tesla, adapter: Tesla.Adapter.Hackney

# Configures default caller for Hacker News External API
config :hn_service, hn_api: HnService.HackerNewsApi

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
