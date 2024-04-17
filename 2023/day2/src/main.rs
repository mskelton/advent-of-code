use regex::Regex;
use std::fs;

fn main() {
    match fs::read_to_string("src/input.txt") {
        Ok(contents) => {
            let sum = contents
                .lines()
                .filter_map(|line| is_possible(line))
                .sum::<i32>();

            println!("The sum is {}!", sum);
        }
        Err(err) => eprintln!("Error reading file {}", err),
    };
}

fn is_possible(line: &str) -> Option<i32> {
    // Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    let re = Regex::new(r"Game (\d+): (.+)").unwrap();
    let caps = re.captures(line)?;

    // Safety check for bad formatting
    if caps.len() != 3 {
        return None;
    }

    let str = caps.get(2).map_or("", |c| c.as_str());
    let ok = str.split(";").into_iter().all(|set| {
        let ok = set
            .split(',')
            .into_iter()
            .map(|choice| {
                let tuple = choice
                    .split(' ')
                    .into_iter()
                    .map(|chunk| chunk.trim())
                    .filter(|chunk| !chunk.is_empty())
                    .collect::<Vec<&str>>();

                return (tuple[0].parse::<i32>().unwrap_or(0), tuple[1]);
            })
            .all(|pair| match pair.1 {
                "blue" => pair.0 <= 14,
                "red" => pair.0 <= 12,
                "green" => pair.0 <= 13,
                _ => false,
            });

        ok
    });

    if ok {
        // Gross, but it works
        let game_id = caps
            .get(1)
            .map(|c| c.as_str())
            .and_then(|s| s.parse::<i32>().ok())
            .unwrap_or(0);

        Some(game_id)
    } else {
        None
    }
}
