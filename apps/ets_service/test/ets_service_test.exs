defmodule EtsServiceTest do
  use ExUnit.Case, async: true

  alias EtsService.Schemas.Story

  setup do
    data_service = start_supervised!(EtsService)

    story = %Story{
      by: "John Dee",
      descendants: 10,
      id: 1,
      kids: 0,
      score: 12,
      time: DateTime.to_unix(DateTime.utc_now()),
      title: "Foo bar",
      url: "http://foo.bar/1/details"
    }

    %{data_service: data_service, story: story}
  end

  describe "insert_data/2" do
    test "inserts valid data into ETS", %{story: story} do
      assert Enum.empty?(EtsService.find_data(story.id))
      assert EtsService.insert_data(story) == :ok
      assert Enum.member?(EtsService.find_data(story.id), story)
    end
  end

  describe "find_data/1" do
    test "returns list of stories in the database", %{story: story} do
      assert EtsService.insert_data(story) == :ok
      assert Enum.member?(EtsService.find_data(story.id), story)
    end

    test "returns an empty list if there's no itens with the given key" do
      assert EtsService.find_data(:invalid) == []
    end
  end
end