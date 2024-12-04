# im gonna make a parser

text = open("./input.txt").read()

i = 0
lenght = len(text)

result = 0
enabled = True


while i < lenght:
    if text[i:i+7] == "don't()":
        enabled = False
        i += 7
        continue

    if text[i:i+4] == "do()":
        enabled = True
        i += 4
        continue

    if text[i:i+4] == "mul(":
        # consume number, number
        i += 4
        if not enabled:
            continue
        start = i
        while text[i].isdigit():
            i += 1
        fisrt_number = int(text[start:i])
        if text[i] != ",":
            continue
        i += 1
        start = i
        while text[i].isdigit():
            i += 1
        second_number = int(text[start:i])
        if text[i] != ")":
            continue
        result += fisrt_number * second_number
        i += 1
        continue

    i += 1


print(result)