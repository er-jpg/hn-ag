defmodule HttpService.StoryController do
  @moduledoc false
  use HttpService, :controller

  alias EtsService

  @page_size 10

  @spec list(any, map) :: :error | Plug.Conn.t()
  def list(conn, params) do
    with page <- Map.get(params, "page", 1),
         {page_num, _} <- Integer.parse(page),
         list <- EtsService.list_data() do
      paginated_records =
        list
        |> Stream.drop(@page_size * (page_num - 1))
        |> Enum.take(@page_size)

      total_records = Enum.count(list)

      conn
      |> put_status(:ok)
      |> render("stories.json",
        stories: paginated_records,
        page: page,
        total_records: total_records
      )
    end
  end
end
