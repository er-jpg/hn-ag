defmodule HttpService.Router do
  use HttpService, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HttpService do
    pipe_through :api
  end
end
