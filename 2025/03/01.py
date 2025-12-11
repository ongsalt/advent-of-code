banks = open("./input.txt").readlines()
banks = [list(map(int, b.strip())) for b in banks]

voltages = []

for bank in banks:
    l = len(bank)
    max_value = -1
    max_pos = -1

    for i, v in enumerate(bank):
        if v > max_value and i != l - 1:
            max_pos = i
            max_value = v

    max_value_2 = -1

    for i in range(max_pos + 1, l):
        v = bank[i]
        if v > max_value_2:
            max_value_2 = v

    voltages.append(10 * max_value + max_value_2)


print(voltages)
print(sum(voltages))
