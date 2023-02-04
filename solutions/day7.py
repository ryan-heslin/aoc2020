def parse(lines):
    result = {}
    for line in lines:
        parts = line.split(", ")
        parts[0] = parts[0].split(" ")
        this_bag = parts[0][:2]
