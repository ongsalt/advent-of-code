list1 = []
list2 = []

with open('input.txt', 'r') as f:
    for line in f:
        a, b = line.split()
        # we can in fact sort the list here but im too lazy to do that
        list1.append(int(a))
        list2.append(int(b))

list1.sort()
list2.sort()

diff = 0
for a, b in zip(list1, list2):
    diff += abs(a - b)

print(diff)