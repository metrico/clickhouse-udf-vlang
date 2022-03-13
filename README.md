<img src="https://user-images.githubusercontent.com/1423657/147935343-598c7dfd-1412-4bad-9ac6-636994810443.png" width=220 >

# ClickHouse V UDF

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


### ClickHouse UDF
Create a UDF Function to invoke your vlang application
- use directory `/var/lib/clickhouse/user-scripts` to store user-scripts
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


### Use UDF
```
SELECT v_sum(10, 20)

Query id: f98a5f83-4e94-41d0-9d9f-78b37d3af152

┌─node_sum(10, 20)-─┐
│                30 │
└───────────────────┘

1 rows in set. Elapsed: 0.006 sec. 
```