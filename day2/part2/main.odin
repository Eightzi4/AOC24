package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	safe_reports: int

	data, _ := os.read_entire_file("input.txt", context.allocator)

	blk: for line in strings.split_lines(string(data)) {
		string_levels := strings.split(line, " ");defer delete(string_levels)

		levels := make([]int, len(string_levels));defer delete(levels)

		levels_with_pd := make([]int, len(levels) - 1);defer delete(levels_with_pd) // pd = Problem Dampener

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
				switch levels_with_pd[i] - levels_with_pd[i + 1] {
				case -3 ..= -1:
					is_increasing = false
				case 1 ..= 3:
					is_decreasing = false
				case:
					continue inner_blk
				}
			}

			if is_increasing || is_decreasing {
				safe_reports += 1
				continue blk
			}
		}
	}

	fmt.println(safe_reports)
}
