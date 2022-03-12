defmodule HnService.Worker do
  @moduledoc """
  A worker process responsible for the workload of saving the Hacker News Api data into the Ets Service.

  The default timer for the application can be correctly set on the `application.ex` as an option, resulting in {HnService.Worker, minutes: 5}. If the value isn't set it defaults to `@default_time_range`.
  """
  use GenServer

  @default_time_range 5

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(state) do
    schedule_work(nil)
    {:ok, state}
  end

  def handle_info(:work, state) do
    Keyword.get(state, :minutes, @default_time_range)
    |> schedule_work()

    do_work()

    {:noreply, state}
  end

  def handle_call(:do_task_now, _from, state) do
    do_work()
    {:reply, :ok, state}
  end

  @doc """
  Function to run the task once ignoring the timer
  """
  @spec do_task_now! :: :ok
  def do_task_now! do
    GenServer.call(__MODULE__, :do_task_now)
  end

  defp schedule_work(nil), do: send(self(), :work)
  defp schedule_work(minutes), do: Process.send_after(self(), :work, :timer.minutes(minutes))

  defp do_work() do
    case HnService.fetch_story_data() do
      {:ok, stories} -> Enum.each(stories, fn s -> EtsService.insert_data(s) end)
      _ -> send(self(), :work)
    end
  end
end
