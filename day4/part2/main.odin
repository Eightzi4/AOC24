package main

import "core:fmt"
import "core:os"
import "core:strings"

Position :: struct {
	x, y: int,
}

DIRECTIONS :: [2]Position{{1, 1}, {1, -1}}
SEARCHED_WORD :: "MAS"
RANGE :: len(SEARCHED_WORD) / 2

main :: proc() {
	words_found := 0

	data, _ := os.read_entire_file("input.txt", context.allocator)

	lines := strings.split_lines(string(data));defer delete(lines)
	height := len(lines)
	width := len(lines[0])
	searched_word_clone := strings.clone(SEARCHED_WORD)

	for x in 0 ..< width {
		blk: for y in 0 ..< height {
			if lines[y][x] != SEARCHED_WORD[len(SEARCHED_WORD) / 2] do continue
			if x < RANGE || x >= width - RANGE || y < RANGE || y >= height - RANGE do continue

			for direction in DIRECTIONS {
				if !check_direction(lines, x, y, direction, searched_word_clone) &&
				   !check_direction(lines, x, y, {-direction.x, -direction.y}, searched_word_clone) {
					continue blk
				}
			}
			words_found += 1
		}
	}

	fmt.println(words_found)
}

check_direction :: proc(lines: []string, x, y: int, direction: Position, word: string) -> bool {
	current_pos := Position{x - RANGE * direction.x, y - RANGE * direction.y}

	for i in 0 ..< len(SEARCHED_WORD) {
		if lines[current_pos.y][current_pos.x] != word[i] do return false
		
		current_pos.x += direction.x
		current_pos.y += direction.y
	}

	return true
}
