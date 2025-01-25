package main

import "core:fmt"
import "core:os"
import "core:strings"

Vec2 :: struct {
	x, y: int,
}

DIRECTIONS :: [8]Vec2{{0, 1}, {1, 0}, {1, 1}, {0, -1}, {-1, 0}, {-1, -1}, {1, -1}, {-1, 1}}
SEARCHED_WORD :: "XMAS"

main :: proc() {
	words_found := 0
	data, _ := os.read_entire_file("../../input/day4.txt", context.allocator)
	lines := strings.split_lines(string(data))
	height := len(lines)
	width := len(lines[0])
	searched_word_clone := strings.clone(SEARCHED_WORD)

	for x in 0 ..< width {
		for y in 0 ..< height {
			blk: for direction in DIRECTIONS {
				current_pos := Vec2{x, y}

				for i in 0 ..< len(SEARCHED_WORD) {
					if current_pos.x < 0 || current_pos.x >= width || current_pos.y < 0 || current_pos.y >= height do continue blk
					if lines[current_pos.y][current_pos.x] != searched_word_clone[i] do continue blk

					current_pos.x += direction.x
					current_pos.y += direction.y
				}

				words_found += 1
			}
		}
	}

	fmt.println(words_found)
}
