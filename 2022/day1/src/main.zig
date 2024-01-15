const std = @import("std");

fn calculate() !i32 {
    var file = try std.fs.cwd().openFile("src/input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var max: i32 = 0;
    var current: i32 = 0;

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        // If the line is empty, we've reached the end of a group.
        if (line.len == 0) {
            max = @max(current, max);
            current = 0;
        } else {
            current += try std.fmt.parseInt(i32, line, 10);
        }
    }

    // We need to check the last group, since it won't have a trailing newline.
    max = @max(current, max);

    return max;
}

pub fn main() !void {
    const result = try calculate();
    std.debug.print("Result: {d}\n", .{result});
}

test "calculates the correct answer" {
    try std.testing.expectEqual(@as(i32, 24000), try calculate());
}
