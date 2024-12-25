package main

import "core:fmt"
import "core:os"
import "core:strings"

Vec2 :: struct {
	x, y: int,
}

DIRECTIONS :: [2]Vec2{{1, 1}, {1, -1}}
SEARCHED_WORD :: "MAS"
RANGE :: len(SEARCHED_WORD) / 2

main :: proc() {
	words_found := 0

	data, _ := os.read_entire_file("../../input/day4.txt", context.allocator)

	lines := strings.split_lines(string(data));defer delete(lines)
	height := len(lines)
	width := len(lines[0])
	searched_word_clone := strings.clone(SEARCHED_WORD)

	for x in 0 ..< width {
		blk: for y in 0 ..< height {
			if lines[y][x] != SEARCHED_WORD[len(SEARCHED_WORD) / 2] do continue
			if x < RANGE || x >= width - RANGE || y < RANGE || y >= height - RANGE do continue

			direction_blk: for direction in DIRECTIONS {
				repeat_blk: for r in 0 ..< 2 {
					direction := r == 0 ? direction : {-direction.x, -direction.y}
					current_pos := Vec2{x - RANGE * direction.x, y - RANGE * direction.y}

					for i in 0 ..< len(SEARCHED_WORD) {
						if lines[current_pos.y][current_pos.x] != searched_word_clone[i] {
							if r == 1 do continue blk
							else do continue repeat_blk
						}

						current_pos.x += direction.x
						current_pos.y += direction.y
					}

					continue direction_blk
				}
			}

			words_found += 1
		}
	}

	fmt.println(words_found)
}
