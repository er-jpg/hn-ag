defmodule HttpService.UserSocket do
  use Phoenix.Socket

  channel "story", HttpService.StoryChannel

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  @spec id(any) :: nil
  def id(_socket), do: nil
end
