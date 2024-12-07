text = open("./input.txt").read()

inners = [chunk.split(")") for chunk in text.split("mul(")]
pairs = [i[0].split(",") for i in inners if len(i[0].split(",")) == 2] 

result = 0
for a, b in pairs:
    try:
        result += int(a) * int(b)
    except:
        pass

print(result)