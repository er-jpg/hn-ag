defmodule HnServiceTest do
  use ExUnit.Case

  import Mox

  alias EtsService.Schemas.Story

  setup [:verify_on_exit!]

  describe "fetch_story_data/1" do
    setup do
      story = %{
        "by" => "John Dee",
        "descendants" => 10,
        "id" => 1,
        "kids" => 0,
        "score" => 12,
        "time" => DateTime.to_unix(DateTime.utc_now()),
        "title" => "Foo bar",
        "type" => "story",
        "url" => "http://foo.bar/1/details"
      }

      %{story: story}
    end

    test "gets a list of stories with the required data", %{story: story} do
      HnService.HackerNewsApiBehaviourMock
      |> expect(:get_top_stories, fn -> {:ok, [1]} end)
      |> expect(:get_story_details, 2, fn _id -> {:ok, story} end)

      assert {:ok, result} = HnService.fetch_story_data()
      assert Enum.any?(result, fn e -> match?(%Story{id: 1}, e) end)
    end

    test "returns an error when the get_top_stories fails and doesn't call the details" do
      HnService.HackerNewsApiBehaviourMock
      |> expect(:get_top_stories, fn -> {:error, :request_error_400} end)

      assert {:error, :request_error_400} = HnService.fetch_story_data()
    end

    test "returns an error when the get_story_details fails" do
      HnService.HackerNewsApiBehaviourMock
      |> expect(:get_top_stories, fn -> {:ok, [1]} end)
      |> expect(:get_story_details, 1, fn _id -> {:error, :request_error_400} end)

      assert {:error, :fetch_story_details} = HnService.fetch_story_data()
    end
  end
end
