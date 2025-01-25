package main

import "core:fmt"
import "core:os"

File :: struct {
	id, size: int,
}

main :: proc() {
	checksum := 0
	data, _ := os.read_entire_file_from_filename("../../input/day9.txt")
	files: [dynamic]File
	id := 0
	is_file := true

	for char in data {
		file_size := int(char) - '0'

		if is_file {
			append(&files, File{id, file_size})
			
			id += 1
		} else do append(&files, File{-1, file_size})

		is_file = !is_file
	}

	#reverse for &file, i in files do if file.id != -1 {
		for &space, j in files {
			if j > i do break

			if space.id == -1 {
				space_left := space.size - file.size

				if space_left >= 0 {
					space = file
					file.id = -1

					if space_left > 0 do inject_at_elem(&files, j + 1, File{-1, space_left})

					break
				}
			}
		}
	}

	pos := 0

	for file in files {
		if file.id != -1 do checksum += file.id * (pos * file.size + (file.size - 1) * file.size / 2)

		pos += file.size
	}

	fmt.println(checksum)
}
