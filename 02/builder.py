# target = input("Which file (1 or 2): ")
target = "2"

input_content = open("./input.txt", "r").readlines()
output = open(f"./{target}.generated.ts", "w")

output.write('import { Add } from "./1"\n')
output.write('import { Pipes } from "./' + target + '"\n\n')

def chunks(list, n):
    for i in range(0, len(list), n):
        yield list[i:i + n]

total_chunks = 0
for lines in chunks(input_content, 30):
    lines = "".join(lines).strip()
    output.write(f"type InputChunk{total_chunks} = `{lines}`\n")
    output.write(f"type ResultChunk{total_chunks} = Pipes<InputChunk{total_chunks}>\n\n")
    total_chunks += 1

output.write("type Result = ")

for i in range(total_chunks):
    output.write(f"Add<ResultChunk{i}, ")

output.write("0") # trailing comma is not allowed
output.write(">" * (total_chunks))

output.close()
