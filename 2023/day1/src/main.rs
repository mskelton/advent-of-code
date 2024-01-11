use std::{collections::HashMap, fs};

fn main() {
    let nums_words = HashMap::from([
        ("one", 1),
        ("two", 2),
        ("three", 3),
        ("four", 4),
        ("five", 5),
        ("six", 6),
        ("seven", 7),
        ("eight", 8),
        ("nine", 9),
    ]);

    match fs::read_to_string("src/input.txt") {
        Ok(contents) => {
            let nums = contents
                .lines()
                .map(|line| sum_line(&nums_words, line))
                .sum::<i32>();

            println!("The sum is {}!", nums);
        }
        Err(err) => eprintln!("Error reading file {}", err),
    };
}

fn sum_line(nums_words: &HashMap<&str, i32>, line: &str) -> i32 {
    let mut nums = Vec::<i32>::new();
    let mut left_pointer = 0;
    let mut right_pointer = 1;

    while left_pointer < line.len() {
        let substr = &line[left_pointer..right_pointer];

        // Push digits directly to the nums vector
        if let Ok(int_char) = substr.parse::<i32>() {
            left_pointer = right_pointer;
            nums.push(int_char);
        }

        // If the substring exists, push that word based on the word value
        if let Some(num) = nums_words.get(substr) {
            nums.push(*num);
        }

        // If there is still more chars, keep incrementing the
        // right pointer. Otherwise reset both pointers to the
        // start.
        if right_pointer < line.len() {
            right_pointer += 1;
        } else {
            left_pointer += 1;
            right_pointer = left_pointer + 1;
        }
    }

    // If no numbers were found for the line, the total is zero
    if nums.is_empty() {
        return 0;
    }

    return nums[0] * 10 + nums[nums.len() - 1];
}
