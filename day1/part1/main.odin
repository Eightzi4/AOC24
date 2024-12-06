package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:slice"

main :: proc() {
    data, _ := os.read_entire_file("input.txt", context.allocator)

    first_array: [dynamic]int
    second_array: [dynamic]int

    for line in strings.split_lines(string(data)) {
        string_values, _ := strings.split(line, "   ")

        append(&first_array, strconv.atoi(string_values[0]))
        append(&second_array, strconv.atoi(string_values[1]))
    }

    slice.sort(first_array[:])
    slice.sort(second_array[:])

    total_distance: int

    for i in 0..<len(first_array) {
        total_distance += abs(first_array[i] - second_array[i])
    }

    fmt.println(total_distance)
}