defmodule HttpService.Plug.HealthCheck do
  @moduledoc """
  Plug for the `/health` endpoint. It was implemented as a Plug and not log the requests.
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/health"} = conn, _opts) do
    conn
    |> send_resp(200, "")
    |> halt()
  end

  def call(conn, _opts), do: conn
end
