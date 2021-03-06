defmodule DataServiceTest do
  use ExUnit.Case, async: true

  alias DataService.Schemas.Story

  setup do
    if is_nil(Process.whereis(DataService)) do
      start_supervised!(DataService)
    end

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

    table_name = :stories

    %{story: story, table_name: table_name}
  end

  describe "cache_data/1" do
    test "inserts valid data into ETS", %{story: story} do
      new_story = %{story | ref: 2}

      assert DataService.cache_data(%{story | ref: 2}) == :ok

      assert Enum.any?(DataService.find_data(2), fn e ->
               match?(%{ref: 2}, e)
             end)
    end

    test "returns an error on invalid data" do
      assert DataService.cache_data(:invalid) == {:error, :invalid_data}
    end
  end

  describe "find_data/1" do
    test "returns list of stories in the database", %{story: %{ref: ref} = story} do
      assert DataService.cache_data(story) == :ok

      assert Enum.any?(DataService.find_data(ref), fn e ->
               match?(%{ref: ^ref}, e)
             end)
    end

    test "returns an empty list if there's no itens with the given key" do
      assert DataService.find_data(:invalid) == []
    end
  end

  describe "delete_data/1" do
    setup %{story: story} do
      DataService.cache_data(story)
    end

    test "deletes given element from ets", %{story: story} do
      assert DataService.delete_data(story.id) == :ok
      refute Enum.member?(DataService.find_data(story.id), story)
    end
  end

  describe "list_data/0" do
    test "returns full list of stories in the database", %{story: %{ref: ref} = story} do
      assert DataService.cache_data(story) == :ok

      assert Enum.any?(DataService.list_data(), fn e ->
               match?(%{ref: ^ref}, e)
             end)
    end

    test "returns an empty list if there's no itens in the ets" do
      assert :ok = DataService.clear_data()
      assert DataService.list_data() == []
    end
  end

  describe "clear_data/0" do
    test "fully cleans a table from the ets", %{story: story} do
      assert DataService.cache_data(story) == :ok
      assert :ok = DataService.clear_data()
      assert DataService.list_data() == []
    end
  end
end
