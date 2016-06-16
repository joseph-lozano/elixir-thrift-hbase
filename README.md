# HBase

**TODO: Add description**

usage:
```Elixir
{:ok, pid} = HBase.Client.start_link("0.0.0.0", 9090) # host and port
{"row", results_map} = HBase.Client.get(pid, "tablename", "row")
[{"row1", results_map1}, {"row2", results_map2}] = HBase.Client.mget(pid, tablename, ["row1", "row2"])
```
