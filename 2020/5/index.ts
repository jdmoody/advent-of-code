import { readFileSync } from "fs";
import { join } from "path";

const inputs = readFileSync(join(__dirname, "/input.txt"), "utf-8").split("\n");

const getRow = (
  partitions: string[],
  { min, max }: { min: number; max: number } = { min: 0, max: 127 }
): number => {
  const mid = (max + min) / 2;

  const p = partitions.shift();

  if (p === "F") {
    max = Math.floor(mid);
  } else {
    min = Math.ceil(mid);
  }

  if (min === max) return max;

  return getRow(partitions, { min, max });
};

const getColumn = (
  partitions: string[],
  { min, max }: { min: number; max: number } = { min: 0, max: 7 }
): number => {
  const mid = (max + min) / 2;

  const p = partitions.shift();

  if (p === "L") {
    max = Math.floor(mid);
  } else {
    min = Math.ceil(mid);
  }

  if (min === max) return max;

  return getColumn(partitions, { min, max });
};

const seatIds = inputs.map((input: string) => {
  const rowPartitions = input.slice(0, 7).split("");
  // console.log(rowPartitions);
  const row = getRow(rowPartitions);

  const columnPartitions = input.slice(7, 10).split("");
  // console.log(columnPartitions);
  const column = getColumn(columnPartitions);

  return row * 8 + column;
});

console.log(Math.max(...seatIds));

const sortedSeatIds = seatIds.sort((a, b) => b - a);

sortedSeatIds.forEach((i, idx) => {
  if (sortedSeatIds[idx - 1] !== i + 1) console.log("HERE");
  console.log(i);
});
