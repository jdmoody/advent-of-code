import { readFileSync } from "fs";
import { join } from "path";

const inputs = readFileSync(join(__dirname, "/input.txt"), "utf-8").split(
  "\n\n"
);

const sum = inputs.reduce((s, group) => {
  const set = new Set();

  group.split("\n").forEach((member) => {
    member.split("").forEach((question) => {
      set.add(question);
    });
  });

  return s + set.size;
}, 0);

console.log(sum);

const correctSum = inputs.reduce((s, group) => {
  const map = new Map();
  let groupCount = 0;

  const groupMembers = group.split("\n");
  groupMembers.forEach((member) => {
    member.split("").forEach((question) => {
      if (!map.has(question)) map.set(question, 0);
      map.set(question, map.get(question) + 1);

      if (map.get(question) === groupMembers.length) {
        groupCount++;
      }
    });
  });

  return s + groupCount;
}, 0);
console.log(correctSum);
