<img src="https://vlang.io/img/veasel.png" width=420>

# V ClickHouse UDF
> ClickHouse can call any external executable program or script to process data.

This basic example illustrates a simple `sum` [V](https://vlang.io/) powered function for [Clickhouse UDF](https://clickhouse.com/docs/en/sql-reference/functions/#executable-user-defined-functions) usage

<br>

### V Function
To get started, create an baseline vlang application with the following features:

- [x] read input from stdin
- [x] parse tab separated columns
- [ ] do something with data
- [x] return some output

Here's an example `sum` function:
```
import os

fn main() {
        // Parse stdin to array
        data := os.get_lines()
        for line in data {
           // split tabSeparated columns
           columns := line.split('\t')
           // sum two integers
           sum := columns[0].int() + columns[1].int()
           // return a result
           println(sum)
        }
}
```

Compile and store into the ClickHouse UDF script directory:
```
v -o /var/lib/clickhouse/user-scripts/vlang-udf -prod .
```

The final static executable size is < ~92KB all inclusive!
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


### Usage
```
SELECT v_sum(10, 20)

Query id: f98a5f83-4e94-41d0-9d9f-78b37d3af152

┌─v_sum(10, 20)─────┐
│                30 │
└───────────────────┘

1 rows in set. Elapsed: 0.006 sec. 
```

<br>

That's all it takes! Go create your superfast v powered UDF function for fun and profit!
