defmodule HttpService.StoryView do
  use HttpService, :view

  def render("stories.json", %{stories: stories, page: page, total_records: total_records}) do
    %{
      page: page,
      total_records: total_records,
      stories: render_many(stories, HttpService.StoryView, "story.json", as: :story)
    }
  end

  def render("story.json", %{story: story}) do
    %{
      by: story.by,
      descendants: story.descendants,
      id: story.id,
      kids: story.kids,
      score: story.score,
      time: story.time,
      title: story.title,
      type: story.type,
      url: story.url
    }
  end
end
