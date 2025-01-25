package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	result := 0
	data, _ := os.read_entire_file("../../input/day3.txt", context.allocator)
	sample := "mul("
	sample_index := 0
	saved_index := 0

	for c, i in data {
		if sample_index == len(sample) {
			if saved_index == 0 do saved_index = i

			switch c {
			case '0' ..= '9', ',':
				continue
			case ')':
				string_values, _ := strings.split(string(data[saved_index:i]), ",")

				result += strconv.atoi(string_values[0]) * strconv.atoi(string_values[1])

				fallthrough
			case:
				saved_index = 0
				sample_index = 0
			}
		} else if c == sample[sample_index] {
			sample_index += 1
		} else {
			sample_index = 0
		}
	}

	fmt.println(result)
}
