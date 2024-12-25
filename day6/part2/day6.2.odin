package main

import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"
import "core:time"
import "core:unicode/utf8"

Vec2 :: [2]int

DIRECTIONS :: [4]Vec2{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

Direction :: enum {
	Left,
	Right,
	Up,
	Down,
}

rotate_right :: proc(dir: ^Direction) {
	switch dir^ {
	case .Left:
		dir^ = .Up
	case .Right:
		dir^ = .Down
	case .Up:
		dir^ = .Right
	case .Down:
		dir^ = .Left
	}
}

take_step :: proc(position: Vec2, direction: Direction) -> Vec2 {
	switch direction {
	case .Left:
		return position + DIRECTIONS[0]
	case .Right:
		return position + DIRECTIONS[1]
	case .Up:
		return position + DIRECTIONS[2]
	case .Down:
		return position + DIRECTIONS[3]
	}

    return position
}

main :: proc() {
	inf_loops_count := 0

	data, _ := os.read_entire_file_from_filename("../../input/day6.txt")

	lines := strings.split_lines(string(data))

	chars: [dynamic][dynamic]rune
	for line in lines {
		line_chars: [dynamic]rune
		for c in line do append(&line_chars, c)
		append(&chars, line_chars)
	}

	width := len(chars[0])
	height := len(chars)

	facing_diretion := Direction.Up

	start_position := Vec2{}
	blk: for line, y in lines {
		for c, x in line do if c == '^' {
			start_position = Vec2{x, y}
			chars[start_position.y][start_position.x] = 'X'
			break blk
		}
	}

	position := start_position

	for position.x > 0 && position.x < width - 1 && position.y > 0 && position.y < height - 1 {
        new_position := take_step(position, facing_diretion)

		if chars[new_position.y][new_position.x] == '#' {
			rotate_right(&facing_diretion)
			continue
		}

		position = new_position

		if chars[new_position.y][new_position.x] == 'X' do continue

		chars[position.y][position.x] = '#'

		if is_inf_loop(width, height, start_position, chars) do inf_loops_count += 1

		chars[position.y][position.x] = 'X'
	}

	fmt.println(inf_loops_count)
}

is_inf_loop :: proc(
	width, height: int,
	start_position: Vec2,
	chars: [dynamic][dynamic]rune,
) -> bool {
	position := start_position
	facing_diretion := Direction.Up

	past_turns: [dynamic]struct {
		_: Vec2,
		_: Direction,
	};defer delete(past_turns)

	for position.x > 0 && position.x < width - 1 && position.y > 0 && position.y < height - 1 {
		new_position := take_step(position, facing_diretion)

		if chars[new_position.y][new_position.x] == '#' {
			for past_turn in past_turns do if past_turn == {position, facing_diretion} {
				return true
			}

			append(&past_turns, struct {
				_: Vec2,
				_: Direction,
			}{position, facing_diretion})
			rotate_right(&facing_diretion)
			continue
		}

		position = new_position
	}

	return false
}
