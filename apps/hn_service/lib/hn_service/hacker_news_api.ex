defmodule HnService.HackerNewsApi do
  @moduledoc """
  Http Client for the external Hacker News API, documentation can be found at the link (https://github.com/HackerNews/API). The API doesn't require any authorization, it also doesn't have any request limits.

  This module uses mainly the Tesla dependency because of the Middlewares to handle JSON and the Retry.
  """

  use Tesla
  plug(Tesla.Middleware.BaseUrl, "https://hacker-news.firebaseio.com/v0")
  plug(Tesla.Middleware.JSON)

  plug(Tesla.Middleware.Retry,
    delay: 500,
    max_retries: 5,
    max_delay: 4_000,
    should_retry: fn
      {:ok, %{status: status}} when status in [400, 500] -> true
      {:ok, _} -> false
      {:error, _} -> true
    end
  )

  @behaviour HnService.HackerNewsApiBehaviour

  @doc """
  Function to get from the external api the list of top_stories. The external endpoint returns a array containing the ids from the stories.
  """
  @spec get_top_stories :: {:error, any()} | {:ok, list()}
  def get_top_stories do
    "/topstories.json"
    |> get()
    |> handle_response()
  end

  @doc """
  Function to get the details of a given story (in reality it gets the details of any type from the API, but to keep under the same context and use inside the app it was defined as is). The external endpoints returns a map with data from the story.

  The id on the external API param is an integer.
  """
  @spec get_story_details(integer()) :: {:error, any} | {:ok, map()}
  def get_story_details(id) do
    ("/item/" <> to_string(id) <> ".json")
    |> get()
    |> handle_response()
  end

  defp handle_response({:ok, %Tesla.Env{status: 200, body: body}}), do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{status: status}}),
    do: {:error, :"request_error_#{status}"}

  defp handle_response({:error, _reason} = error), do: error
end
