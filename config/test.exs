import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :http_service, HttpService.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "SvOwlSZdgtr8AjpL6f3pQ4YvXmJFlNkDYjXE9wglREfZCBYDnMrd3c7s/OiUAhdM",
  server: false

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :http_service, HttpService.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "XuUohv15zwdtLX0SMpNuLlZqWUx+VWaP80PvSZdX/PnRp8naPfcZuH5P67sLhw89",
  server: false

# Configures test caller for Hacker News External API
config :hn_service, hn_api: HnService.HackerNewsApiBehaviourMock
