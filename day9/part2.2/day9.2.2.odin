package main

import "core:fmt"
import "core:os"

// This turned out to be more than 10x slower than 2.1
main :: proc() {
	checksum := 0

	data, _ := os.read_entire_file_from_filename("../../input/day9.txt")

	disk: [dynamic]int

	id := 0
	is_file := true

	for i in 0 ..< len(data) {
		size := int(data[i]) - '0'

		if is_file {
			for _ in 0 ..< size do append(&disk, id)

			id += 1
		} else do for _ in 0 ..< size do append(&disk, -1)

		is_file = !is_file
	}

	right_index := len(disk) - 1
	size := 0
	is_file = true

	for right_index > 0 {
		file_size := 0

		if disk[right_index] == -1 do right_index -= 1
		else {
			for disk[right_index - file_size] == disk[right_index] {
				file_size += 1

				if right_index - file_size < 0 do break
			}

			left_index := 0

			for left_index < right_index {
				space_size := 0

				for disk[left_index] != -1 do left_index += 1

				if left_index > right_index do break

				for disk[left_index + space_size] == disk[left_index] {
					space_size += 1

					if left_index + space_size > len(disk) - 1 do break
				}

				if space_size >= file_size {
					for i in left_index ..< left_index + file_size do disk[i] = disk[right_index]
					for i in right_index - file_size + 1 ..< right_index + 1 do disk[i] = -1

					break
				}

				left_index += space_size
			}
		}

		right_index -= file_size
	}

	for id, i in disk do if id != -1 do checksum += id * i

	fmt.println(checksum)
}
