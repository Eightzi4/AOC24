package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	result := 0

	data, _ := os.read_entire_file("input.txt", context.allocator)

	samples := [?]string{"do()", "don't()", "mul("}
	sample_indexes := [?]int{0, 0, 0}
	saved_index := 0
	enabled := true

	for c, i in data {
		for j in 0 ..< len(samples) {
			if sample_indexes[j] == len(samples[j]) {

				switch j {
				case 0:
					enabled = true
				case 1:
					enabled = false
				case 2:
					if !enabled {
						sample_indexes[j] = 0
						continue
					}
					if saved_index == 0 do saved_index = i

					switch c {
					case '0' ..= '9', ',':
						continue
					case ')':
						string_values, _ := strings.split(
							string(data[saved_index:i]),
							",",
						);defer delete(string_values)
						result += strconv.atoi(string_values[0]) * strconv.atoi(string_values[1])
						fallthrough
					case:
						saved_index = 0
					}
				}

				sample_indexes[j] = 0
			} else if c == samples[j][sample_indexes[j]] {
				sample_indexes[j] += 1
			} else {
				sample_indexes[j] = 0
			}
		}
	}

	fmt.println(result)
}
