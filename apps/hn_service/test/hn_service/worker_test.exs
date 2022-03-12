defmodule HnService.WorkerTest do
  use ExUnit.Case

  import Mox

  alias EtsService.Schemas.Story

  setup [:set_mox_global, :verify_on_exit!]

  setup do
    id = 3

    story_api = %{
      "by" => "John Dee",
      "descendants" => 10,
      "id" => id,
      "kids" => 0,
      "score" => 12,
      "time" => DateTime.to_unix(DateTime.utc_now()),
      "title" => "Foo bar",
      "type" => "story",
      "url" => "http://foo.bar/#{id}/details"
    }

    story = %Story{
      by: "John Dee",
      descendants: 10,
      id: id,
      kids: 0,
      score: 12,
      time: DateTime.to_unix(DateTime.utc_now()),
      title: "Foo bar",
      type: "story",
      url: "http://foo.bar/#{id}/details"
    }

    HnService.HackerNewsApiBehaviourMock
    |> stub(:get_top_stories, fn ->
      {:ok, [3]}
    end)
    |> stub(:get_story_details, fn _id ->
      {:ok, story_api}
    end)

    if is_nil(Process.whereis(EtsService)) do
      start_supervised!(EtsService)
    end

    if is_nil(Process.whereis(HnService.Worker)) do
      start_supervised!(HnService.Worker)
    end

    %{story_api: story_api, story: story, id: id}
  end

  describe "do_task_now!/0" do
    test "gets and adds data correctly to ETS from Hacker News API", %{
      story_api: story_api,
      story: story,
      id: id
    } do
      HnService.Worker.do_task_now!()

      task = Task.async(fn -> HnService.Worker.do_task_now!() end)
      ref = Process.monitor(task.pid)

      assert_receive {:DOWN, ^ref, :process, _, :normal}, 500
      assert Enum.member?(EtsService.find_data(id), story)
    end

    test "retries in case of error after the fetch_data", %{story_api: story_api, story: story} do
      # TODO: Implement test for error
    end
  end
end
