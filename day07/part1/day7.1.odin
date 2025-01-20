package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	total_calibration_result := 0

	data, _ := os.read_entire_file_from_filename("../../input/day7.txt")

	for line, i in strings.split_lines(string(data)) {
		sections := strings.split(line, ": ")

		target_value := strconv.atoi(sections[0])

		numbers: [dynamic]int;defer delete(numbers)
		for v in strings.split(sections[1], " ") do append(&numbers, strconv.atoi(v))

		operator_count := len(numbers)

		for i in 1 ..< int(math.pow2_f16(operator_count)) {
			result := numbers[0]

			for j in 0 ..< len(numbers) - 1 {
				if (i & int(math.pow2_f16(j))) != 0 do result *= numbers[j + 1]
				else do result += numbers[j + 1]
			}

			if result == target_value {
				total_calibration_result += result
				break
			}
		}
	}

	fmt.println(total_calibration_result)
}
