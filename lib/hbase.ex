defmodule HBase do
  use Supervisor
  @moduledoc """
  Provides a wrapper for accessing HBase via the thrift protocol

  Currently only supports get and mget
  """

  def start(_type, _args), do: start_link

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    host = Application.fetch_env!(:hbase, :host)
    port = Application.fetch_env!(:hbase, :port)
    children = [
      worker(HBase.Client, [host, port])
    ]
    supervise(children, strategy: :one_for_one)
  end

  def get(table, row) do
    HBase.Client.get(table, row)
  end

  def mget(table, row) do
    HBase.Client.mget(table, row)
  end
end
