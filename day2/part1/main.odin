package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	data, _ := os.read_entire_file("input.txt", context.allocator)

	safe_reports: int

	blk: for line in strings.split_lines(string(data)) {
		string_levels := strings.split(line, " ")

		levels := make([]int, len(string_levels))

		for i in 0 ..< len(string_levels) do levels[i] = strconv.atoi(string_levels[i])

		is_increasing := true
		is_decreasing := true

		for i in 0 ..< len(levels) - 1 {
			if levels[i] > levels[i + 1] do is_increasing = false
			if levels[i] < levels[i + 1] do is_decreasing = false
			if abs(levels[i] - levels[i + 1]) > 3 || levels[i] - levels[i + 1] == 0 do continue blk
		}

		if is_increasing || is_decreasing {
			safe_reports += 1
		}
	}

	fmt.println(safe_reports)
}
