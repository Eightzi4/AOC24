package main

import "core:fmt"
import "core:os"

main :: proc() {
	checksum := 0
	data, _ := os.read_entire_file_from_filename("../../input/day9.txt")
	files := make([]int, len(data) / 2 + 1)
	free_spaces := make([]int, len(data) / 2)
	total_free_space := 0

	for i in 0 ..< len(data) / 2 {
		files[i] = int(data[i * 2] - '0')
		total_free_space += files[i]
		free_spaces[i] = int(data[i * 2 + 1] - '0')
	}

	files[len(files) - 1] = int(data[len(data) - 1] - '0')
	total_free_space += files[len(files) - 1]

	unordered_values := make([]int, total_free_space)
	index := 0

	for i in 0 ..< len(files) {
		for j in index ..< index + files[i] do unordered_values[j] = i
		index += files[i]
	}

	ordered_values := make([]int, total_free_space)
	filling_space := false
	front_index, back_index := 0, total_free_space - 1
	files_index, spaces_index := 0, 0
	i := 0

	blk: for {
		if filling_space {
			for j in 0 ..< free_spaces[spaces_index] {
				ordered_values[i] = unordered_values[back_index - j]
				i += 1

				if i == total_free_space do break blk
			}

			back_index -= free_spaces[spaces_index]
			spaces_index += 1
		} else {
			for j in front_index ..< front_index + files[files_index] {
				ordered_values[i] = unordered_values[j]
				i += 1

				if i == total_free_space do break blk
			}

			front_index += files[files_index]
			files_index += 1
		}

		filling_space = !filling_space
	}

	for v, i in ordered_values do checksum += v * i

	fmt.println(checksum)
}
