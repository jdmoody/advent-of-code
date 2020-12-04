import { readFileSync } from "fs";
import { join } from "path";

const input = readFileSync(join(__dirname, "/input.txt"), "utf-8").split("\n");
const rows = input.map((row) => row.split(""));

const totalTrees = [
  { x: 1, y: 1 },
  { x: 3, y: 1 },
  { x: 5, y: 1 },
  { x: 7, y: 1 },
  { x: 1, y: 2 },
].reduce((prod, { x: xDiff, y: yDiff }) => {
  let x = 0;
  let y = 0;
  let treesHit = 0;

  while (y < rows.length) {
    if (rows[y][x] === "#") treesHit++;

    x += xDiff;
    x %= rows[y].length;
    y += yDiff;
  }
  if (xDiff === 3 && yDiff === 1) console.log(treesHit);

  return prod * treesHit;
}, 1);
console.log(totalTrees);
