# defmodule HnService.WorkerTest do
#   use ExUnit.Case

#   import Mox

#   alias EtsService.Schemas.Story

#   setup [:set_mox_global, :verify_on_exit!]

#   setup_all do
#     if is_nil(Process.whereis(EtsService)) do
#       start_supervised!(EtsService)
#     end

#     if is_nil(Process.whereis(HnService.Worker)) do
#       start_supervised!(HnService.Worker)
#     end

#     id = 3

#     story = %Story{
#       by: "Worker test",
#       descendants: 100,
#       id: id,
#       kids: 20,
#       score: 120,
#       time: DateTime.to_unix(DateTime.utc_now()),
#       title: "Worker test story",
#       url: "http://foo.bar/#{id}/details"
#     }

#     %{story: story, id: id}
#   end

#   describe "do_task_now!/0" do
#     test "gets and adds data correctly to ETS from Hacker News API", %{story: story, id: id} do
#       parent = self()
#       ref = make_ref()

#       HnService.HackerNewsApiBehaviourMock
#       |> expect(:get_top_stories, 2, fn ->
#         send(parent, {ref, :work})

#         {:ok, [3]}
#       end)
#       |> expect(:get_story_details, 0, fn _id ->
#         send(parent, {ref, :work})

#         {:ok, [story]}
#       end)

#       spawn(fn -> HnService.Worker.do_task_now!() end)

#       assert_receive {^ref, :work}
#       assert Enum.member?(EtsService.find_data(story.id), story)
#     end
#   end
# end
