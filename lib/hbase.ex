defmodule HBase do
  use Supervisor
  @moduledoc """
  Provides a wrapper for accessing HBase via the thrift protocol

  Currently only supports get and mget
  """

  def start(_type, _args), do: start_link()

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    host = Application.fetch_env!(:hbase, :host)
    port = Application.fetch_env!(:hbase, :port)

    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:worker_module, HBase.Client},
      {:size, Application.fetch_env!(:hbase, :pool_size)},
      {:max_overflow, Application.fetch_env!(:hbase, :max_overflow)}
    ]
    children = [
      :poolboy.child_spec(pool_name(), poolboy_config, [host, port])
    ]
    supervise(children, strategy: :one_for_one)
  end

  @doc """
  Get all columns from a single row.
  Accpets the pid returned from `start_link`, the table name and row name.
  Returns a tuple containing the row name as the first element and a map containing the columns and volumes as the second element.
  Usage:
  ```
  HBase.Client.get(pid, "table", "a:1")
  > {"a:1", %{"col1" => "val1", "col2" => "val2}}
  ```
  """
  def get(table, row, cols \\ :all) do
    case cols do
      :all -> :poolboy.transaction(pool_name(), fn(pid) -> GenServer.call(pid, {:get, table, row}, 60000) end)
      _    -> :poolboy.transaction(pool_name(), fn(pid) -> GenServer.call(pid, {:get_with_cols, table, row, cols}, 60000) end)
    end
  end

  @doc """
  Get all columns from a multiple rows.
  Accpets the pid returned from `start_link`, the table name and a list of row names.
  Returns a list containing tuples containing the row name as the first element and a map containing the columns and volumes as the second element.
  Usage:
  ```
  HBase.Client.mget(pid, "table", ["a:1", "a:2")
  > [{"a:1", %{"col1" => "val1", "col2" => "val2}}, {"a:2", %{"col1" => "val1", "col2" => "val2}}]
  ```
  """
  def mget(table, rows, cols) when is_list(rows) do
    case cols do
      :all ->  :poolboy.transaction(pool_name(), fn(pid) -> GenServer.call(pid, {:mget, table, rows}, 60000) end)
      _    ->  :poolboy.transaction(pool_name(), fn(pid) -> GenServer.call(pid, {:mget_with_cols, table, rows, cols}, 60000) end)
    end
  end

  defp pool_name do
    :hbase_worker_pool
  end
end
