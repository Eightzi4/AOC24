package main

import "core:fmt"
import "core:math/rand"
import "core:reflect"
import "core:encoding/cbor"
import "base:runtime"

main :: proc() {
	test_struct := TestStruct{}
	randomize_struct_values(&test_struct)
	//fmt.println(test_struct)

}

TestStruct :: struct {
	a: int,
	b: bit_field u32 {
		x: u8  | 5,
		y: u16 | 13,
		z: b32 | 14,
	},
	c: []rune,
	d: string,
	e: enum {
		A,
		B,
		C,
		D,
	},
}

randomize_struct_values :: proc(s: ^$T) {
    //cbor._assign_bool()
    fmt.println(runtime.__type_info_of(T).variant)
	for field in reflect.struct_fields_zipped(T) {
		field_value := (^field.type.id)(uintptr(s) + field.offset)
        
	}
}
