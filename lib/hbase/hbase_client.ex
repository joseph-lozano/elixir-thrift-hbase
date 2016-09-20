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
  def start_link([host, port]) do
    args = {String.to_char_list(host), port}
    GenServer.start_link(__MODULE__, args, [])
  end

  def init({host, port}) do
    {:ok, client} = :thrift_client_util.new(host, port, :hbase_thrift, [])
    {:ok, client}
  end



  # callbacks
  def handle_call({:get, table, row}, _from, client) do
    {client, {:ok, response}} = :thrift_client.call(client, :getRow, [table, row, :dict.new()])
    [result] = parse_get_response(response)
    {:reply, result, client}
  end

  def handle_call({:get_with_cols, table, rows, cols}, _from, client) do
    {client, {:ok, response}} = :thrift_client.call(client, :getRowWithColumns, [table, rows, cols, :dict.new()])
    result = parse_get_response(response)
    {:reply, result, client}
  end

  def handle_call({:mget, table, rows}, _from, client) do
    {client, {:ok, response}} = :thrift_client.call(client, :getRows, [table, rows, :dict.new()])
    result = parse_get_response(response)
    {:reply, result, client}
  end

  def handle_call({:mget_with_cols, table, rows, cols}, _from, client) do
    {client, {:ok, response}} = :thrift_client.call(client, :getRowsWithColumns, [table, rows, cols, :dict.new()])
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
