list_a = []
b_freq = {}

with open('input.txt', 'r') as f:
    for line in f:
        a, b = line.split()
        list_a.append(int(a))
        b_freq[int(b)] = b_freq.get(int(b), 0) + 1

similarity = 0
for a in list_a:
    if a in b_freq:
        similarity += a * b_freq[a]

print(similarity)