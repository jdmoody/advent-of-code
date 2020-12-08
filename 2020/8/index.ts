import { readFileSync } from "fs";
import { join } from "path";

const origInstructions = readFileSync(
  join(__dirname, "/input.txt"),
  "utf-8"
).split("\n");

type TerminationTuple = [
  // True if the instructions terminate
  boolean,
  // The value of the accumulator at termination or end of first loop
  number
];

const doesTerminate = (instructionToModify?: number): TerminationTuple => {
  let idx = 0;
  let accumulator = 0;

  const instructionsRun = new Set();
  const instructions = [...origInstructions];

  while (idx < instructions.length) {
    if (instructionsRun.has(idx)) {
      return [false, accumulator];
    }
    instructionsRun.add(idx);

    let [operation, argStr] = instructions[idx].split(" ");
    const arg = Number(argStr);

    if (!!instructionToModify && instructionToModify === idx) {
      switch (operation) {
        case "acc":
          instructionToModify++;
          break;
        case "jmp":
          operation = "nop";
          break;
        case "nop":
          operation = "jmp";
          break;
      }
    }

    switch (operation) {
      case "acc":
        accumulator += arg;
        idx += 1;
        break;

      case "jmp":
        idx += arg;
        break;

      default:
        idx += 1;
        break;
    }
  }

  return [true, accumulator];
};

const [_, loopedAccumulator] = doesTerminate();
console.log(loopedAccumulator);

const fixProgram = () => {
  let instructionToModify = 0;
  while (true) {
    const [terminates, accumulator] = doesTerminate(instructionToModify);

    if (terminates) return accumulator;

    instructionToModify++;
  }
};

const fixedAccumulator = fixProgram();

console.log(fixedAccumulator);
