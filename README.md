<img src="https://vlang.io/img/veasel.png" width=420>

# V ClickHouse UDF
This basic example illustrates a simple `sum` [V](https://vlang.io/) powered [Clickhouse User Defined Function](https://clickhouse.com/docs/en/sql-reference/functions/#executable-user-defined-functions)

<br>

### V Function
Create an simple vlang application:
- read input from stdin
- split row values by tabs
- return some output

Example `sum` function:
```
import os

fn main() {
        // Parse stdin to array
        data := os.get_lines()
        for line in data {
           // tabSeparated
           tags := line.split('\t')
           // sum integers & return
           sum := tags[0].int() + tags[1].int()
           println(sum)
        }
}
```

Compile and store into the UDF script directory:
```
v -o /var/lib/clickhouse/user-scripts/vlang-udf -prod .
```

The final executable size is < ~92KB all inclusive!
```
-rwxr-xr-x   1 root root  92K Mar 13 12:49 vlang-udf*
```

### ClickHouse UDF
Create a [UDF Function XML](https://clickhouse.com/docs/en/sql-reference/functions/#executable-user-defined-functions) to invoke your vlang binary

Define the _input and output_ [format](https://clickhouse.com/docs/en/interfaces/formats) our function requires _(UInt64, string, etc)_

```
<functions>
    <function>
        <type>executable</type>
        <name>v_sum</name>
        <return_type>UInt64</return_type>
        <argument>
            <type>UInt64</type>
        </argument>
        <argument>
            <type>UInt64</type>
        </argument>
        <format>TabSeparated</format>
        <command>vlang-udf</command>
        <lifetime>0</lifetime>
    </function>
</functions>
```

> MUST use directory `/var/lib/clickhouse/user-scripts` to store both user-scripts and executable udf


### Use UDF
```
SELECT v_sum(10, 20)

Query id: f98a5f83-4e94-41d0-9d9f-78b37d3af152

┌─v_sum(10, 20)─────┐
│                30 │
└───────────────────┘

1 rows in set. Elapsed: 0.006 sec. 
```
