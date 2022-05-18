defmodule HnService do
  @moduledoc """
  Main pooling of data from the Hacker News API, fetching the top stories list and then getting their respective details. The variable `@pool_amount` was defined by the use case of the application but can be changed.
  """
  @pool_amount 50

  alias DataService.Schemas.Story
  alias HnService.HackerNewsApi

  @doc """
  Returns a list of the top stories from a given moment in the Hacker News API.

  It works using the following steps:

    1. Gets the list of top_stories from the external service
    2. Takes the top `pool` of stories in order parse
    3. From the id in the list, it gets the details of a given story
    4. Maps each result into the `%DataService.Schemas.Story{}` struct
  """
  @spec fetch_story_data(integer()) :: {:error, any()} | {:ok, [DataService.Schemas.Story.t()]}
  def fetch_story_data(pool \\ @pool_amount) do
    with {:ok, story_list} <- hacker_news_api().get_top_stories(),
         top_pool_stories <- Enum.take(story_list, pool),
         {:ok, detailed_list} <- aggregate_stories_details(top_pool_stories) do
      map_detailed_list(detailed_list)
    end
  end

  defp aggregate_stories_details(top_pool_stories) do
    top_pool_stories
    |> Task.async_stream(fn story_id ->
      hacker_news_api().get_story_details(story_id)
    end)
    |> Stream.map(fn
      {:ok, {:ok, map}} -> map
      {:ok, {:error, _reason} = error} -> error
    end)
    |> handle_result()
  end

  defp handle_result(result) do
    case Enum.any?(result, fn e -> match?({:error, _reason}, e) end) do
      true -> {:error, :fetch_story_details}
      false -> {:ok, result}
    end
  end

  defp map_detailed_list(list) do
    changesets =
      list
      |> Enum.map(fn e ->
        e
        |> Map.put("ref", Map.get(e, "id"))
        |> Map.put("time", NaiveDateTime.from_gregorian_seconds(Map.get(e, "id")))
        |> Story.changeset()
      end)

    maps = Enum.map(changesets, &Story.apply(&1))

    {:ok, changesets, maps}
  end

  defp hacker_news_api() do
    Application.get_env(:hn_service, :hn_api, HackerNewsApi)
  end
end
