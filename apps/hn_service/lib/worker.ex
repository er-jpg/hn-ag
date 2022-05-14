defmodule HnService.Worker do
  @moduledoc """
  A worker process responsible for the workload of saving the Hacker News Api data into the Ets Service.

  The default timer for the application can be correctly set on the `application.ex` as an option, resulting in {HnService.Worker, minutes: 5}. If the value isn't set it defaults to `@default_time_range`.

  # TODO: Take a look at _handle_continue_ callback.
  """
  use GenServer

  require Logger

  @default_time_range 5

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(state) do
    schedule_work(nil)
    {:ok, state}
  end

  def handle_info(:fetch_data, state) do
    Keyword.get(state, :minutes, @default_time_range)
    |> schedule_work()

    result = HnService.fetch_story_data()
    send(self(), {:save_data, result})

    {:noreply, state}
  end

  def handle_info({:save_data, {:ok, stories}}, state) do
    Enum.each(stories, fn e -> EtsService.insert_data(e) end)

    Logger.info("Upserted #{Enum.count(stories)} rows into the Ets.")

    {:noreply, state}
  end

  def handle_info({:save_data, _}, state) do
    Logger.warn("Couldn't fetch data from external API! Retrying...")

    send(self(), :fetch_data)
    {:noreply, state}
  end

  def handle_call(:do_task_now, _from, state) do
    send(self(), :fetch_data)
    {:reply, :ok, state}
  end

  @doc """
  Function to run the task once ignoring the timer
  """
  @spec do_task_now! :: :ok
  def do_task_now! do
    GenServer.call(__MODULE__, :do_task_now)
  end

  defp schedule_work(nil), do: send(self(), :fetch_data)

  defp schedule_work(minutes),
    do: Process.send_after(self(), :fetch_data, :timer.minutes(minutes))
end
