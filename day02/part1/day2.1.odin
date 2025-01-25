package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	safe_reports: int
	data, _ := os.read_entire_file("../../input/day2.txt", context.allocator)

	blk: for line in strings.split_lines(string(data)) {
		string_levels := strings.split(line, " ")
		levels := make([]int, len(string_levels))

		for i in 0 ..< len(string_levels) do levels[i] = strconv.atoi(string_levels[i])

		is_increasing := true
		is_decreasing := true

		for i in 0 ..< len(levels) - 1 {
			switch levels[i] - levels[i + 1] {
			case -3 ..= -1:
				is_increasing = false
			case 1 ..= 3:
				is_decreasing = false
			case:
				continue blk
			}
		}

		if is_increasing || is_decreasing {
			safe_reports += 1
		}
	}

	fmt.println(safe_reports)
}
