def parse(lines):
    result = {}

    for line in lines:
        rule, specs = line.split(": ")
        specs = specs.split(" | ")
        specs = [
            [
                token.strip('"') if '"' in token else int(token)
                for token in alternative.split(" ")
            ]
            for alternative in specs
        ]
        result[int(rule)] = specs
    return result


def resolve(string, rules):
    end = len(string)
    if False and len(rules[8]) > 1 and string == "babbbbaabbbbbabbbbbbaabaaabaaa":
        breakpoint()

    print(string)

    # Problem: decide how many times to invoke recursive option of recursive rules
    def inner(rule, index):
        specs = rules[rule]
        for alternative in specs:
            i = index
            for token in alternative:
                if i > end - 1:
                    # breakpoint()
                    return i
                if type(token) is str:
                    print(i)
                    print(token == string[i])
                    i = -1 if token != string[i] else i + 1
                else:
                    # Recursive
                    i = inner(token, i)
                if i == -1:
                    break
            else:
                return i
        return -1

    return inner(0, 0) == len(string)


with open("inputs/day19.txt") as f:
    raw_input = f.read()

rules, strings = [x.splitlines() for x in raw_input.split("\n\n")]
rules = parse(rules)

part1 = sum(list(resolve(string, rules) for string in strings))
print(part1)

# Only need to try all repeat lengths for rule 8, since 11 always matches exactly
new_rules = """8: 42 | 42 8
11: 42 31 | 42 11 31"""
new_rules_parsed = parse(new_rules.splitlines())
rules.update(new_rules_parsed)

part2 = sum(list(resolve(string, rules) for string in strings))
print(part2)
