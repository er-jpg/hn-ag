defmodule EtsService do
  @moduledoc """
  Provides the functions to store, access and delete data in the ETS memory under the _stories_ table.

  It uses the GenServer behaviour as it's required for the data storage to be up at all times when
  the application is running.
  """
  use GenServer

  alias EtsService.Schemas.Story

  @table :stories

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_init_state) do
    stories_table_name = :ets.new(@table, [:set, :named_table, read_concurrency: true])

    {:ok, stories_table_name}
  end

  def handle_cast({:insert, {key, value}}, name) do
    :ets.insert(name, {key, value})
    {:noreply, name}
  end

  def handle_cast({:delete, key}, name) do
    :ets.delete(name, key)
    {:noreply, name}
  end

  def handle_call({:find, key}, _from, name) do
    result =
      case :ets.lookup(name, key) do
        [] -> []
        list when is_list(list) -> Enum.map(list, fn {_key, value} -> value end)
      end

    {:reply, result, name}
  end

  def insert_data(%Story{id: key} = story) do
    GenServer.cast(__MODULE__, {:insert, {key, story}})
  end

  def insert_data(_data), do: {:error, :invalid_data}

  def find_data(key) do
    GenServer.call(__MODULE__, {:find, key})
  end

  def delete_data(key) do
    GenServer.cast(__MODULE__, {:delete, key})
  end
end
