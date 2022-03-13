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

  def handle_cast(:clear, name) do
    :ets.delete_all_objects(@table)

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

  def handle_call(:list, _from, name) do
    result =
      case :ets.tab2list(name) do
        [] -> []
        list when is_list(list) -> Enum.map(list, fn {_key, value} -> value end)
      end

    {:reply, result, name}
  end

  @doc """
  Inserts data into the stories table in the ETS.

  Returns `:ok` or `{:error, :invalid_data}` when the parameter isn't a `%Story{}`.

  ## Examples

      iex> EtsService.insert_data(%EtsService.Schemas.Story{id: 1, title: "Foo bar"})
      :ok

  """
  @spec insert_data(any) :: :ok | {:error, :invalid_data}
  def insert_data(%Story{id: key} = story) do
    case find_data(key) do
      [] ->
        GenServer.cast(__MODULE__, {:insert, {key, story}})
        notify_subscribers({:inserted_value, story})
        :ok

      _ ->
        :ok
    end
  end

  def insert_data(_data), do: {:error, :invalid_data}

  @doc """
  Searches data from the stories table in the ETS using the `key`.

  Returns `[%EtsService.Schemas.Story{}]`.

  ## Examples

      iex> EtsService.find_data(1))
      [%EtsService.Schemas.Story{id: 1, title: "Foo bar", ...}]

  """
  @spec find_data(any) :: list()
  def find_data(key) do
    GenServer.call(__MODULE__, {:find, key})
  end

  @doc """
  Deletes data from the stories table in the ETS using the `key`.

  Returns `:ok`.

  ## Examples

      iex> EtsService.delete_data(1))
      :ok

  """
  @spec delete_data(any) :: :ok
  def delete_data(key) do
    GenServer.cast(__MODULE__, {:delete, key})
  end

  @doc """
  Lists all data from the stories table in the ETS.

  Returns `[%EtsService.Schemas.Story{}]`.

  ## Examples

      iex> EtsService.list())
      [%EtsService.Schemas.Story{id: 1, title: "Foo bar", ...}]

  """
  @spec list_data :: list()
  def list_data do
    GenServer.call(__MODULE__, :list)
  end

  @doc """
  Fully clears data from the stories table in the ETS.

  Returns `:ok`.

  ## Examples

      iex> EtsService.clear())
      :ok

  """
  @spec clear_data :: :ok
  def clear_data do
    GenServer.cast(__MODULE__, :clear)
  end

  @doc """
  Uses Phoenix PubSub to subscribe and send events from the module.
  """
  def subscribe do
    Phoenix.PubSub.subscribe(HttpService.PubSub, to_string(@table))
  end

  defp notify_subscribers({key, value}) do
    Phoenix.PubSub.broadcast(HttpService.PubSub, to_string(@table), {__MODULE__, {key, value}})
  end
end
