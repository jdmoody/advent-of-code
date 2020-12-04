import { readFileSync } from "fs";
import { join } from "path";

const inputs = readFileSync(join(__dirname, "/input.txt"), "utf-8")
  .split("\n")
  .map((n) => Number(n));

const og_sum = 2020;

const sumPair = (sum: number, idx?: number): [number, number] | undefined => {
  const pairs: Record<number, boolean> = {};
  for (let i = 0; i < inputs.length; i++) {
    const input = inputs[i];

    pairs[sum - input] = true;
    if (pairs[input] && i !== idx) return [input, sum - input];
  }
};
const productForSumPair = (sum: number, idx?: number) => {
  const pair = sumPair(sum, idx);
  if (pair) return pair[0] * pair[1];
  return false;
};

console.log(productForSumPair(og_sum));

const triplets: Record<number, number> = {};
for (let i = 0; i < inputs.length; i++) {
  const input = inputs[i];

  triplets[og_sum - input] = i;
}

for (let [subSum, idx] of Object.entries(triplets)) {
  const subProduct = productForSumPair(Number(subSum), idx);
  if (!!subProduct) {
    console.log((og_sum - Number(subSum)) * subProduct);
    break;
  }
}
