from typing import Literal

# I ASSUMED THAT BASED ON GIVEN RULE, WE CAN BUILD A FULLY ORDERED LIST

# ordering is a just a(n ordered) list of int 

def parse_rules(text: str) -> list[list[int]]: 
    orderings: list[list[int]] = [[]]
    addresses: dict[int, int] = {} # dict of page and index of ordering list they belong to 

    for i, line in enumerate(text.splitlines()):
        a, b = map(int, line.split("|"))

        if i == 1:
            orderings[0].append(a)
            orderings[0].append(b)
            addresses[a] = 0
            addresses[b] = 0
            continue

    # UNFINISHED

    return orderings

def parse_int_list(text: str) -> list[int]:
    return [int(num) for num in text.split(",")]

