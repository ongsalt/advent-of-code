f = open("./input.txt")

position = 50
count = 0

for line in f.readlines():
    direction = line[0]
    amount = int(line[1:].strip())

    count += amount // 100
    amount %= 100

    if direction == "L":
        amount *= -1

    s = position
    position += amount
    if position > 99 or position < 1 and s != 0:
        count += 1


    position %= 100

print(count)
