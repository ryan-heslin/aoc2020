from math import pi


def solve_part1( instructions):
    mapping = {"N": 0 + 1j, "S": 0 - 1j, "E": 1 + 0j, "S": -1 + 0j}
    rotations
    position = 0
    direction = 1
    for pair in instructions:
        if (change := mapping.get(pair[0])):
            position += change * pair[1]
        elif pair[0] == "F":
            position += change
        else:





with open("inputs/day12.txt") as f:
    raw_input = f.read().splitlines()

processed = [(line[0], int(line[1:])) for line in raw_input]
