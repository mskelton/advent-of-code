const std = @import("std");

fn set_max(input: *[3]i32, value: i32) void {
    // As we step through the array, if a value is greater than the current
    // value, we'll update the array and save the value that was there as we
    // continue stepping through the array.
    var current = value;

    for (input, 0..) |v, i| {
        if (current > v) {
            const temp = input[i];
            input[i] = current;
            current = temp;
        }
    }
}

fn sum(input: [3]i32) i32 {
    var res: i32 = 0;
    for (input) |i| {
        res += i;
    }
    return res;
}

fn calculate() !i32 {
    var file = try std.fs.cwd().openFile("src/input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var top_three = [3]i32{ 0, 0, 0 };
    var current: i32 = 0;

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        // If the line is empty, we've reached the end of a group.
        if (line.len == 0) {
            set_max(&top_three, current);
            current = 0;
        } else {
            current += try std.fmt.parseInt(i32, line, 10);
        }
    }

    // We need to check the last group, since it won't have a trailing newline.
    set_max(&top_three, current);

    return sum(top_three);
}

pub fn main() !void {
    const result = try calculate();
    std.debug.print("Result: {d}\n", .{result});
}

test "calculates the correct answer" {
    try std.testing.expectEqual(@as(i32, 24000), try calculate());
}
