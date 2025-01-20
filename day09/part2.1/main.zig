const std = @import("std");

const File = struct {
    id: i64,
    size: i64,
};

// I just wanted to compare Odin solution with Zig solution
pub fn main() !void {
    var timer = try std.time.Timer.start();
    defer std.debug.print("Code execution took: {d}ms\n", .{timer.read() / 1_000_000});

    var checksum: i64 = 0;

    var gpa = std.heap.GeneralPurposeAllocator(.{ .safety = false }){};
    const allocator = gpa.allocator();

    const data = try std.fs.cwd().readFileAlloc(allocator, "input.txt", std.math.maxInt(usize));

    var files = std.ArrayList(File).init(allocator);

    var id: i64 = 0;
    var is_file = true;

    for (data) |char| {
        const file_size = @as(i64, char - '0');

        if (is_file) {
            try files.append(File{ .id = id, .size = file_size });
            id += 1;
        } else try files.append(File{ .id = -1, .size = file_size });

        is_file = !is_file;
    }

    var i = files.items.len;
    while (i > 0) {
        i -= 1;

        if (files.items[i].id != -1) {
            for (0..i) |j| {
                if (files.items[j].id == -1) {
                    const space_left = files.items[j].size - files.items[i].size;

                    if (space_left >= 0) {
                        files.items[j] = files.items[i];
                        files.items[i].id = -1;

                        if (space_left > 0) try files.insert(j + 1, File{ .id = -1, .size = space_left });

                        break;
                    }
                }
            }
        }
    }

    var pos: i64 = 0;
    for (files.items) |file| {
        if (file.id != -1) checksum += file.id * (pos * file.size + @divFloor((file.size - 1) * file.size, 2));

        pos += file.size;
    }

    std.debug.print("{d}\n", .{checksum});
}
