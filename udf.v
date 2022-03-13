import os

fn main() {
        data := os.get_lines()
        for line in data {
           tags := line.split('\t')
           sum := tags[0].int() + tags[1].int()
           println(sum)
        }
}