from typing import Literal

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

map = [process_line(line) for line in open("./input.txt").read().splitlines()]
w, h = len(map[0]), len(map)
(x, y), direction = find_start_position(map)
walkable_tiles = 1
map[y][x] = DIRECTION_BIT[direction]

while True:
    dx, dy = MOVEMENT[direction]
    new_x = x + dx
    new_y = y + dy

    if new_x == w or new_x == -1 or new_y == h or new_y == -1:
        break

    if map[new_y][new_x] == "#":
        direction = NEXT_DIRECTION[direction]
    else:
        x = new_x
        y = new_y

    if map[y][x] == 0:
        walkable_tiles += 1
    if map[y][x] & DIRECTION_BIT[direction]:
        break
    map[y][x] |= DIRECTION_BIT[direction]
    

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

print(walkable_tiles)
