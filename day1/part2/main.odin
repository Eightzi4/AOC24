package main

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

main :: proc() {
	similarity_score: int

	data, _ := os.read_entire_file("input.txt", context.allocator)

	first_array: [dynamic]int
	second_array: [dynamic]int

	for line in strings.split_lines(string(data)) {
		string_values, _ := strings.split(line, "   ");defer delete(string_values)

		append(&first_array, strconv.atoi(string_values[0]))
		append(&second_array, strconv.atoi(string_values[1]))
	}

	slice.sort(first_array[:])
	slice.sort(second_array[:])

	for i in 0 ..< len(first_array) {
		first_array[i] *= slice.count(second_array[:], first_array[i])
		similarity_score += first_array[i]
	}

	fmt.println(similarity_score)
}
