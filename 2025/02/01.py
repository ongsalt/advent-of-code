f = open("./input.txt")
text = f.read()

def create_range(r: str):
  start, end = r.split("-")
  return (int(start), int(end))

def digit(n: int):
  return len(str(n))

def count_repeated(start: int, end: int):
  s = digit(start)
  e = digit(end)

  if s != e:
    return count_repeated(start, 10 ** s - 1) + count_repeated(10 ** s, end)

  # 2 -> 11
  # 4 -> 101
  # 6 -> 1001
  d = 10 ** (s // 2) + 1

  return end // d - start // d


ranges = [create_range(r) for r in text.split(",")]
print(ranges)

# count = 0
s = 0
for start, end in ranges:
  # count += count_repeated(start, end)
  for i in range(start, end):
    c = digit(i)
    if c % 2 != 0:
      continue
    d = 10 ** (c // 2) + 1
    if i % d == 0 and d > 1:
      s += i
      # print(i)

print(s)