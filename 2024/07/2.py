from typing import Literal

type Op = Literal["+", "*", "||"]

def decode(bit_sequence: int, lenght: int) -> list[Op]:
    out = []
    b = bit_sequence
    for _ in range(lenght):
        bit = b % 3
        b //= 3
        if bit == 0:
            out.append("+")
        elif bit == 1:
            out.append("*")
        else: 
            out.append("||")
    return out

def apply(numbers: list[int], ops: list[Op]) -> int:
    out = numbers[0]
    for n, op in zip(numbers[1:], ops):
        if op == "+":
            out += n
        elif op == "*":
            out *= n
        else:
            # Very no brain
            out = int(f"{out}{n}")

    return out

# (answer, numbers)[]
content: list[tuple[int, list[int]]] = []
for line in open("./input.txt"):
    answer, rest = line.split(":")
    numbers = [int(c) for c in rest.strip().split()]
    content.append((int(answer), numbers))

total = 0
for answer, numbers in content: 
    print(f"{answer}: {numbers} ==================")
    lenght = len(numbers) - 1
    for i in range(3**lenght):
        ops = decode(i, lenght)
        result = apply(numbers, ops)
        # print(result, ops, result == answer)
        if result == answer:
            total += answer
            break
        
print(total)
# print(3**4)
# print(decode(51, 4))