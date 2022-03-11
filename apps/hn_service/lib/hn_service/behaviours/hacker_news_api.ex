defmodule HnService.HackerNewsApiBehaviour do
  @moduledoc false

  @callback get_top_stories() :: {:ok, list()} | {:error, any()}
  @callback get_story_details(integer()) :: {:ok, map()} | {:error, any()}
end
