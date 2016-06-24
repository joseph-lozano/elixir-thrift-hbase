# Elixir-Thrift-HBase

A simple and easy to use wrapper for communicating to HBase via thrift.

#### Prerequisites

Thrift must be installed. `brew install thrift` or the follow the instructions [here](http://thrift.apache.org/docs/install/)

##### Config:
Set the host and port in your config file.
```Elixir
config :hbase,
  host: "localhost",
  port: 9090
  ```
  Include the package in your deps function
  ```Elixir
    defp deps do
    [
      {:hbase, github: "joseph-lozano/elixir-thrift-hbase"}
    ]
  end
  ```
  ### Usage
  ```Elixir
  # Get returns a tuple
  HBase.get("table_name", "row_name")
  # > {"row_name", %{"col_name": value}}
  # MGet returns a list of tuples
  HBase.mget("table_name", ["row_1", "row_2"])
  # > [{"row_1", %{"col_name": value}}, {"row_2", %{"col_name": value}}]

  # Columns can be passed in optionally
  HBase.get("table_name", "row_name", ["col1", col"2])
  ```
