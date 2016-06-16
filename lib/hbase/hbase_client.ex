defmodule HBase.Client do
  use GenServer

  # Initialization
  def start_link(host, port) do
    args = {String.to_char_list(host), port}
    GenServer.start_link(__MODULE__, args, [])
  end

  def init({host, port}) do
    {:ok, client} = :thrift_client_util.new(host, port, :hbase_thrift, [])
    {:ok, client}
  end

  # Get
  def get(pid, table, row) do
    GenServer.call(pid, {:get, table, row})
  end


  # mget
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
