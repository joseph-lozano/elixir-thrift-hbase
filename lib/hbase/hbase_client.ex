defmodule HBase.Client do
  use GenServer

  def start_link(host, port) do
    args = {String.to_char_list(host), port}
    GenServer.start_link(__MODULE__, args, [])
  end

  def init({host, port}) do
    {:ok, client} = :thrift_client_util.new(host, port, :hbase_thrift, [])
    {:ok, client}
  end

  def get(pid, table, row) do
    GenServer.call(pid, {:get, table, row})
  end

  def handle_call({:get, table, row}, _from, client) do
    {client, response} = :thrift_client.call(client, :getRow, [table, row, :dict.new()])
    {:ok, [{:TRowResult, ^row, dict, :undefined}]} = response
    result =
      dict
      |> :dict.to_list
      |> Enum.map(fn(el) ->
        case el do
          {column, {:TCell, <<value::64>>, _timestamp}} ->
            {column, value} 
          {column, {:TCell, value, _timestamp}} ->
            {column, value}
        end
      end)
      |> Map.new
    {:reply, result, client}
  end
end
