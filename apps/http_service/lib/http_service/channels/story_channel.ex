defmodule HttpService.StoryChannel do
  use HttpService, :channel

  alias EtsService

  @doc """
  Main function to handle a join from the external websocket request.

  In order to join this channel you need to connect with the UserSocket via ws://localhost:4000/websocket and then send the following request:

  ```json
  {
    "topic": "story",
    "event": "phx_join",
    "payload": {},
    "ref": "story"
  }
  ```
  """
  @impl true
  @spec join(<<_::40>>, map(), Phoenix.Socket.t()) :: {:ok, Phoenix.Socket.t()}
  def join("story", _payload, socket) do
    stories =
      EtsService.list_data()
      |> Enum.take(1)

    {:ok, assign(socket, stories: stories)}
  end
end
