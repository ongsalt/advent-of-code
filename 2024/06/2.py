from typing import Literal

# I can't think of a way to find this except brute force

type Direction = Literal[">", "<", "^", "v"]
NEXT_DIRECTION: dict[Direction, Direction] = {
    ">": "v",
    "v": "<",
    "<": "^",
    "^": ">"
}

# 4 bit flag
type WalkableTile = int
DIRECTION_BIT: dict[Direction, int] = {
    ">": 0b1000,
    "<": 0b0100,
    "v": 0b0001,
    "^": 0b0010
}
MOVEMENT: dict[Direction, tuple[int, int]] = {
    ">": (1, 0),
    "<": (-1, 0),
    "^": (0, -1),
    "v": (0, 1)
}

type Obstacle = Literal["#"]
type Map = list[list[Obstacle | Direction | WalkableTile]]

def find_start_position(map: list[str]) -> tuple[tuple[int, int], Direction]:
    for y, line in enumerate(map):
        for x, c in enumerate(line):
            if c in [">", "<", "^", "v"]:
                return (x, y), c
    raise ValueError("invalid input")

def process_line(line: str) -> list[Obstacle | Direction | WalkableTile]:
    out = []
    for c in line:
        if c == ".":
            out.append(0)
        else:
            out.append(c)
    return out

def show(map: Map):
    for row in map:
        for c in row:
            if type(c) == int: 
                if c > 0:
                    print("X", end="")
                else:
                    print(".", end="")
            else:
                print(c, end="")
        print()

def process(input_content: list[str], added_obstacle: None | tuple[int, int] = None) -> tuple[Map, bool]: # bool: has_loop
    map = [process_line(line) for line in input_content]
    w, h = len(map[0]), len(map)
    (x, y), direction = find_start_position(map)

    if added_obstacle:
        if added_obstacle == (x, y):
            return map, False
        map[added_obstacle[1]][added_obstacle[0]] = "#"

    walkable_tiles = 1
    map[y][x] = DIRECTION_BIT[direction]

    while True:
        dx, dy = MOVEMENT[direction]
        new_x = x + dx
        new_y = y + dy

        if new_x == w or new_x == -1 or new_y == h or new_y == -1:
            return map, False

        if map[new_y][new_x] == "#":
            direction = NEXT_DIRECTION[direction]
        else:
            x = new_x
            y = new_y

        if map[y][x] == 0:
            walkable_tiles += 1
        if map[y][x] & DIRECTION_BIT[direction]:
            return map, True
        map[y][x] |= DIRECTION_BIT[direction]

input_content = open("./input.txt").read().splitlines()
normal_path, _ = process(input_content)
position_count = 0

# Slow af
for y, row in enumerate(normal_path):
    for x, c in enumerate(row):
        print(f"Processing {x}, {y}: ", end="")
        if type(c) == int and c > 0:
            _, has_loop = process(input_content, (x, y))
            if has_loop:
                position_count += 1
                print(f"OK")
            else:
                print(f"Failed")
        else:
            print(f"Unusable")
        

print(position_count)