# max(A0..An-11) -> x1, pos
# max(Apos..An-10) -> x2, pos

# max must return first immediately when found 9

banks = open("./input.txt").readlines()
banks = [list(map(int, b.strip())) for b in banks]

n = 12

def max(bank: list[int], start: int, end: int):
    max = -1
    max_pos = -1
    for i in range(start, end):
        v = bank[i]
        if v > max:
            max = v
            max_pos = i
        if v == 9:
            break
    assert(max_pos != -1)
    return max, max_pos + 1


voltages = []

for bank in banks:
    cursor = 0
    total = 0
    for i in range(n):
        value, cursor = max(bank, cursor, len(bank) - (n - i - 1))
        total = total * 10 + value
    voltages.append(total)


print(voltages)
print(sum(voltages))