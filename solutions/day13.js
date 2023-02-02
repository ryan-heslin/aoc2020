const fs = require("fs");
function bezout() {
}

function solve_part2(congruences) {
    let modulus = congruences[0][1];
    //FOr each two congruences:
    // modulus * = congruences[0][1];
    // Get Bezout coefficients of moduli
    // new_remainder =  sum of each multiplied by corresponding remainder
    // If new_remainder < 0, increase by modulus to lowest positive integer
    // new_remainder *= Math.ceil(abs(new_remainder / modulus))
    // Return reduced modulus
}

function solve_part1(time, buses) {
    let waits = buses.map((x) => x - (time % x));
    let lowest = waits.indexOf(Math.min(...waits));
    return waits[lowest] * buses[lowest];
}


const raw_input = fs.readFileSync('inputs/day13.txt', 'utf-8').toString().replace(/\n+$/, "").split("\n");
const time = Number(raw_input[0]);
const buses = raw_input[1].replace(/(?:,x)+/g, "").split(",").map(Number);
const part1 = solve_part1(time, buses);
console.log(part1);

//All prime, so we can use Chinese Remainder Theorem
//Must ignore id 0, since it has modulus 0, and test numbers evenly divisible by it
// Get congruences as index-value pairs from list
// Reduce into single congruence
// Find lowest solution of congruence greater than 100000000000000
