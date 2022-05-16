defmodule HttpService.StoryChannel do
  @moduledoc """
  The channel for streaming information about the story data in the application.
  """
  use HttpService, :channel

  alias DataService

  @doc """
  Main function to handle a join from the external websocket request.

  In order to join this channel you need to connect with the UserSocket via `ws://localhost:4000/websocket` and then send the following request:

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
  @spec join(bitstring(), map(), Phoenix.Socket.t()) :: {:ok, Phoenix.Socket.t()}
  def join("story", _payload, socket) do
    :ok = DataService.subscribe()

    {:ok,
     socket
     |> assign(:stories, [])
     |> put_new_stories()}
  end

  @impl true
  def handle_info({_from, {event, value}}, socket) do
    broadcast(socket, to_string(event), Map.from_struct(value))

    {:noreply, socket}
  end

  defp put_new_stories(socket) do
    stories =
      DataService.list_data()
      |> Enum.take(1)

    :ok = DataService.subscribe()

    assign(socket, :stories, stories)
  end
end
