# I want a language with pattern matching

input_content = [line.strip() for line in open("./input.txt").readlines()]

w = len(input_content[0])
h = len(input_content)
count = 0

def check(x: int, y: int) -> bool:
    window = [line[x:x+3] for line in input_content[y:y+3]]
    if window[1][1] != 'A':
        return False

    if window[0][0] == window[0][2] and window[2][0] == window[2][2]:
        return window[0][0] == "S" and window[2][2] == "M" or window[0][0] == "M" and window[2][2] == "S"
    if window[0][0] == window[2][0] and window[0][2] == window[2][2]:
        return window[0][0] == "S" and window[2][2] == "M" or window[0][0] == "M" and window[2][2] == "S"

    return False

# moving windows
for y in range(h - 2):
    for x in range(w - 2):
        if check(x, y):
            count += 1

print(count)