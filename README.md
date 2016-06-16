# HBase

**TODO: Add description**

usage:
```Elixir
{:ok, pid} = HBase.Client.start_link("0.0.0.0", 9090) # host and port
HBase.Client.get(pid, tablename, row)
```
