# fuck im done with gleam

input_content = [line.strip() for line in open("./input.txt").readlines()]

w = len(input_content[0])
h = len(input_content)

directions = [
    (-1, -1),
    (-1, 0),
    (-1, 1),
    (0, -1),
    (0, 1),
    (1, -1),
    (1, 0),
    (1, 1),
]
pattern = "XMAS"
count = 0

def check(starting_x: int, starting_y: int) -> int:
    count = 0
    for direction in directions:
        x = starting_x
        y = starting_y
        for i in range(4):
            if y >= h or x >= w or x < 0 or y < 0:
                break
            if not input_content[y][x] == pattern[i]:
                break
            x += direction[0]
            y += direction[1]
        else:
            count += 1
    return count

# This can be further optimized but who care
for y in range(h):
    for x in range(w):
        count += check(x, y)

print(count)