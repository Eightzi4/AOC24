package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	total_calibration_result := 0
	data, _ := os.read_entire_file_from_filename("../../input/day7.txt")

	for line, i in strings.split_lines(string(data)) {
		sections := strings.split(line, ": ")
		target_value := strconv.atoi(sections[0])
		numbers: [dynamic]int

		for v in strings.split(sections[1], " ") do append(&numbers, strconv.atoi(v))

		total_calibration_result += try_operations(numbers[0], numbers[1:], target_value)
	}

	fmt.println(total_calibration_result)
}

operations := [3]proc(_, _: int) -> int {
	proc(a, b: int) -> int {return a + b},
	proc(a, b: int) -> int {return a * b},
	cat_ints,
}

try_operations :: proc(current_result: int, remaining_numbers: []int, target: int) -> int {
	if len(remaining_numbers) == 0 {
		return current_result
	}

	result := 0

	for operation in operations {
		next_result := try_operations(
			operation(current_result, remaining_numbers[0]),
			remaining_numbers[1:],
			target,
		)

		if next_result == target {
			result = next_result

			break
		}
	}

	return result
}

cat_ints :: proc(first, second: int) -> int {
	if second == 0 do return first * 10

	digits_in_second := second
	decimal_shift := 1

	for digits_in_second > 0 {
		decimal_shift *= 10
		digits_in_second /= 10
	}

	return first * decimal_shift + second
}
