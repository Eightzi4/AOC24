package main

import "core:fmt"
import "core:os"
import "core:strings"

Vec2 :: [2]int

DIRECTIONS :: [4]Vec2{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

topographic_map: [dynamic][dynamic]int
width := 0
height := 0
seen_positions: [dynamic]Vec2

main :: proc() {
	sum := 0

	data, _ := os.read_entire_file_from_filename("../../input/day10.txt")

	for line in strings.split_lines(string(data)) {
		chars: [dynamic]int
		for c in line do append(&chars, int(c) - '0')
		append(&topographic_map, chars)
	}

	width = len(topographic_map[0])
	height = len(topographic_map)

	for line, y in topographic_map {
		for c, x in line {
			if c == 0 {
				sum += find_9s({x, y})
				clear(&seen_positions)
			}
		}
	}

	fmt.println(sum)
}

find_9s :: proc(start_pos: Vec2) -> int {
    current_value := topographic_map[start_pos.y][start_pos.x]

	if current_value == 9 {
		for pos in seen_positions do if pos == start_pos do return 0

		append(&seen_positions, start_pos)
		return 1
	}

	result := 0

	for direction in DIRECTIONS {
		new_pos := start_pos + direction

		if new_pos.x < 0 || new_pos.x >= width || new_pos.y < 0 || new_pos.y >= height do continue

		if topographic_map[new_pos.y][new_pos.x] == current_value + 1 do result += find_9s(new_pos)
	}

	return result
}
