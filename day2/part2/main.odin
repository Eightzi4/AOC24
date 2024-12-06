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
		levels_with_pd := make([]int, len(levels) - 1) // pd = Problem Dampener

		for i in 0 ..< len(string_levels) do levels[i] = strconv.atoi(string_levels[i])


		inner_blk: for i in 0 ..< len(levels) {

			levels_index := 0

			for j in 0 ..< len(levels) do if j != i {
				levels_with_pd[levels_index] = levels[j]
				levels_index += 1
			}

			is_increasing := true
			is_decreasing := true

			for i in 0 ..< len(levels_with_pd) - 1 {
				if levels_with_pd[i] > levels_with_pd[i + 1] do is_increasing = false
				if levels_with_pd[i] < levels_with_pd[i + 1] do is_decreasing = false
				if abs(levels_with_pd[i] - levels_with_pd[i + 1]) > 3 || levels_with_pd[i] - levels_with_pd[i + 1] == 0 do continue inner_blk
			}

			if is_increasing || is_decreasing {
				safe_reports += 1
				continue blk
			}
		}
	}

	fmt.println(safe_reports)
}
