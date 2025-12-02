f = open("./input.txt")
text = f.read()

def create_range(r: str):
    start, end = r.split("-")
    return (int(start), int(end))


def digit(n: int):
    return len(str(n))


dividers = {
    1: [],
    2: [11],
    3: [111],
    4: [101],
    5: [11111],
    6: [10101, 1001],
    7: [1111111],
    8: [1010101, 10001],
    9: [1001001],
    10: [101010101, 100001]
}

# dividers = {
#     1: [],
#     2: [11],
#     3: [],
#     4: [101],
#     5: [],
#     6: [1001],
#     7: [],
#     8: [10001],
#     9: [],
#     10: [100001]
# }


ranges = [create_range(r) for r in text.split(",")]
# print(ranges)

# count = 0

l = []
for start, end in ranges:
    for i in range(start, end + 1):
        c = digit(i)
        for d in dividers[c]:
            if i % d == 0:
                l.append(i)
                # print(i)
                break

print(l)
print(sum(l))
