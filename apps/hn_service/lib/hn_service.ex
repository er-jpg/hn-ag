defmodule HnService do
  @pool_amount 50

  alias EtsService.Schemas.Story
  alias HnService.HackerNewsApi

  def fetch_story_data(pool \\ @pool_amount) do
    with {:ok, story_list} <- HackerNewsApi.get_top_stories(),
         top_pool_stories <- Stream.take(story_list, pool),
         {:ok, detailed_list} <- aggregate_storyies_details(top_pool_stories) do
      map_detailed_list(detailed_list)
    end
  end

  defp aggregate_storyies_details(top_pool_stories) do
    top_pool_stories
    |> Task.async_stream(fn story_id ->
      HackerNewsApi.get_story_details(story_id)
    end)
    |> Stream.map(fn
      {:ok, {:ok, map}} -> map
      {:error, _reason} = error -> error
    end)
    |> handle_result()
  end

  defp handle_result(result) do
    case Enum.any?(result, &match?({:error, _reason}, &1)) do
      true -> {:error, :fetch_story_details}
      false -> {:ok, result}
    end
  end

  defp map_detailed_list(list) do
    list
    |> Stream.map(fn e ->
      %Story{
        by: e["by"],
        descendants: e["descendants"],
        id: e["id"],
        kids: e["kids"],
        score: e["score"],
        time: e["time"],
        title: e["title"],
        type: e["type"],
        url: e["url"]
      }
    end)
  end
end
