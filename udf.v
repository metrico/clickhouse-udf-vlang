import os

fn main() {
        data := os.get_lines()
        for line in data {
           columns := line.split('\t')
           sum := columns[0].int() + columns[1].int()
           println(sum)
        }
}
