use core::num;
use std::{fs::File, io::Read, num::ParseFloatError, str::FromStr};

#[derive(Debug, Clone, Copy)]
struct Point {
    x: f32,
    y: f32,
    z: f32,
}

impl FromStr for Point {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let Ok(numbers): Result<Vec<f32>, _> = s.split(",").map(|f| f.parse()).collect() else {
            return Err(());
        };

        if numbers.len() != 3 {
            return Err(());
        }

        Ok(Point {
            x: numbers[0],
            y: numbers[1],
            z: numbers[2],
        })
    }
}

impl Point {
    fn distance(&self, other: &Point) -> f32 {
        let dx = self.x - other.x;
        let dy = self.y - other.y;
        let dz = self.z - other.z;

        (dx.powi(2) + dy.powi(2) + dz.powi(2)).sqrt()
    }
}

fn parse_input() -> Vec<Point> {
    let mut file = File::open("./input.txt").expect("No such file");
    let mut buf = String::new();
    file.read_to_string(&mut buf).unwrap();

    let points = buf
        .split_whitespace()
        .map(|line| Point::from_str(line))
        .collect::<Result<Vec<Point>, _>>()
        .expect("Invalid input format");

    points
}

fn main() {
    let points = parse_input();
    println!("{:.?}", points);
}
