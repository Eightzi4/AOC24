package main

import "core:fmt"
import "core:os"

FileFragment :: struct {
	id, size: int,
}

main :: proc() {
	checksum := 0
	data, _ := os.read_entire_file_from_filename("../../input/day9.txt")
	file_fragments: [dynamic]FileFragment
	file_leftovers, space_leftovers := 0, 0
	left_index, right_index := 0, len(data) - 1
	left_id, right_id := 0, len(data) / 2
	left_is_file := true

	for {
		if left_is_file && left_id < right_id {
			file_size := int(data[left_index]) - '0'

			append(&file_fragments, FileFragment{left_id, file_size})

			left_index += 1
			left_id += 1
			left_is_file = false
		} else {
			file_size := file_leftovers != 0 ? file_leftovers : int(data[right_index]) - '0'
			space_size := space_leftovers != 0 ? space_leftovers : int(data[left_index]) - '0'

			file_leftovers, space_leftovers = 0, 0

			if space_size >= file_size {
				append(&file_fragments, FileFragment{right_id, file_size})
				
				if space_size > file_size do space_leftovers = space_size - file_size
				
				right_index -= 2
				right_id -= 1
				left_is_file = space_size == file_size
			} else {
				file_leftovers = file_size - space_size

				append(&file_fragments, FileFragment{right_id, space_size})
				
				left_is_file = true
			}

			if space_leftovers == 0 do left_index += 1
		}

		if left_id >= right_id && file_leftovers == 0 do break
	}

	pos := 0
	
	for fragment in file_fragments {
		checksum += fragment.id * (pos * fragment.size + (fragment.size - 1) * fragment.size / 2)
		pos += fragment.size
	}

	fmt.println(checksum)
}
