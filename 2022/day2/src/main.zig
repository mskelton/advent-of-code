const std = @import("std");

const Result = enum { win, loss, draw };

fn get_result(us: u8, opp: u8) Result {
    var diff = us - 'A';
    std.debug.print("Hi: {d} {d}\n", .{ diff, opp });

    return switch (us) {
        'X' => Result.win,
        'Y' => Result.win,
        'Z' => Result.win,
        else => Result.draw,
    };
}

fn calculate() !i32 {
    var file = try std.fs.cwd().openFile("src/input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var total: i32 = 0;

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        // Skip lines that don't have the correct format
        if (line.len < 3) {
            continue;
        }

        var result = get_result(line[0], line[2]);
        total += switch (result) {
            .win => 6,
            .loss => 0,
            .draw => 3,
        };
        // // If the line is empty, we've reached the end of a group.
        // if (line.len == 0) {
        //     set_max(&top_three, current);
        //     current = 0;
        // } else {
        //     current += try std.fmt.parseInt(i32, line, 10);
        // }
    }

    return total;
}

pub fn main() !void {
    const result = try calculate();
    std.debug.print("Result: {d}\n", .{result});
}

test "calculates the correct answer" {
    try std.testing.expectEqual(@as(i32, 15), try calculate());
}
