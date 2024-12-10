from typing import Literal

type Op = Literal["+", "*"]

def decode(bit_sequence: int, lenght: int) -> list[Op]:
    out = []
    for i in range(lenght):
        bit = (bit_sequence >> i) & 1
        if bit == 1:
            out.append("*")
        else:
            out.append("+")
    return out

def apply(numbers: list[int], ops: list[Op]) -> int:
    out = numbers[0]
    for n, op in zip(numbers[1:], ops):
        if op == "+":
            out += n
        else:
            out *= n

    return out

# print(decode(0b0010, 4))


# (answer, numbers)[]
content: list[tuple[int, list[int]]] = []
for line in open("./input.txt"):
    answer, rest = line.split(":")
    numbers = [int(c) for c in rest.strip().split()]
    content.append((int(answer), numbers))

total = 0
for answer, numbers in content: 
    # print(f"{answer}: {numbers} ==================")
    lenght = len(numbers) - 1
    for i in range(2**lenght):
        ops = decode(i, lenght)
        result = apply(numbers, ops)
        # print(result, ops, result == answer)
        if result == answer:
            total += answer
            break
        
print(total)
# print(decode(0b0010, 4))
