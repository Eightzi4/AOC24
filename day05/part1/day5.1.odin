package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	page_number_sum := 0
	data, _ := os.read_entire_file_from_filename("../../input/day5.txt")
	sections := strings.split(string(data), "\n\r")
	rule_lines := strings.split(sections[0], "\n")
	rules: [dynamic][2]int

	for rule_line in rule_lines {
		string_values := strings.split(rule_line, "|")

		append(&rules, [2]int{strconv.atoi(string_values[0]), strconv.atoi(string_values[1])})
	}

	updates: [dynamic][dynamic]int

	for update_line, i in strings.split(sections[1], "\n") {
		update_values := strings.split(update_line, ",")
		update: [dynamic]int

		for value in update_values {
			append(&update, strconv.atoi(value))
		}

		append(&updates, update)
	}

	blk: for update in updates {
		update_values_count := len(update)

		for i in 1 ..< update_values_count {
			for rule in rules {
				if rule.x == update[i] {
					for j in 0 ..< i {
						if rule.y == update[j] do continue blk
					}
				}
			}
		}

		page_number_sum += update[update_values_count / 2]
	}

	fmt.println(page_number_sum)
}
