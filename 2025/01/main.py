f = open("./input.txt")

position = 50
count = 0
count_2 = 0

for line in f.readlines():
    direction = line[0]
    amount = int(line[1:].strip())

    if direction == "L":
        amount *= -1

    new_position = position + amount
    position = new_position % 100

    if position == 0:
        count += 1

print(count)