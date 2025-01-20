package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:unicode/utf8"

Vec2 :: [2]int

main :: proc() {
	antinode_locs: [dynamic]Vec2

	data, _ := os.read_entire_file_from_filename("../../input/day8.txt")

	lines := strings.split_lines(string(data))

	width := len(lines[0])
	height := len(lines)

	char_positions := make(map[rune][dynamic]Vec2)

	for line, y in lines {
		for c, x in line {
			if c != '.' {
				if c not_in char_positions do char_positions[c] = make([dynamic]Vec2)

				append(&char_positions[c], Vec2{x, y})
			}
		}
	}

	for char in char_positions {
		positions_count := len(char_positions[char])
		for i in 0 ..< positions_count {
			for j in 0 ..< positions_count do if j != i {
				blk: for multiplier in 0 ..< max(int) {
					new_antinode_loc := char_positions[char][i] + (char_positions[char][i] - char_positions[char][j]) * multiplier

					if new_antinode_loc.x < 0 || new_antinode_loc.x >= width || new_antinode_loc.y < 0 || new_antinode_loc.y >= height do break

					for antinode_loc in antinode_locs do if antinode_loc == new_antinode_loc do continue blk

					append(&antinode_locs, new_antinode_loc)
				}

			}
		}
	}

	fmt.println(len(antinode_locs))
}
