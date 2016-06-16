defmodule HBase.Client do
  @moduledoc """
  Provides a wrapper for accessing HBase via the thrift protocol

  Currently only supports get and mget
  """
  use GenServer

  # Initialization
  @doc """
  Initializes the GenServer. Accepts a host and port as arguments
  Returns `{:ok, pid}`
  Usage:
  ```
  {:ok, pid} = HBase.client.start_link("0.0.0.0", 9090)
  ```
  """
  def start_link(host, port) do
    args = {String.to_char_list(host), port}
    GenServer.start_link(__MODULE__, args, [])
  end

  def init({host, port}) do
    {:ok, client} = :thrift_client_util.new(host, port, :hbase_thrift, [])
    {:ok, client}
  end

  # Get
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
  def get(pid, table, row) do
    GenServer.call(pid, {:get, table, row})
  end


  # mget
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
  def mget(pid, table, rows) when is_list(rows) do
    GenServer.call(pid, {:mget, table, rows})
  end

  # callbacks
  def handle_call({:get, table, row}, _from, client) do
    {client, {:ok, response}} = :thrift_client.call(client, :getRow, [table, row, :dict.new()])
    [result] = parse_get_response(response)
    {:reply, result, client}
  end

  def handle_call({:mget, table, rows}, _from, client) do
    {client, {:ok, response}} = :thrift_client.call(client, :getRows, [table, rows, :dict.new()])
    result = parse_get_response(response)
    {:reply, result, client}
  end

  # Private
  defp parse_get_response(response) do
    response
    |> Enum.map( fn({:TRowResult, row, dict, :undefined}) ->
      dict
      |> :dict.to_list
      |> Enum.map(fn
        {column, {:TCell, <<value::64>>, _timestamp}} ->
          {column, value}
        {column, {:TCell, value, _timestamp}} ->
          {column, value}
      end)
      |> Map.new
      |> Tuple.duplicate(1)
      |> Tuple.insert_at(0, row)
    end)
  end
end
