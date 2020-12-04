import { readFileSync } from "fs";
import { join } from "path";

interface PasswordPolicy {
  requiredLetter: string;
  min: number;
  max: number;
}

interface Password {
  policy: PasswordPolicy;
  value: string;
}

const parsePassword = (passwordStr: string): Password => {
  const [policy, value] = passwordStr.split(": ");

  const [minMax, requiredLetter] = policy.split(" ");
  const [min, max] = minMax.split("-").map(Number);

  return {
    policy: { requiredLetter, min, max },
    value,
  };
};

const input = readFileSync(join(__dirname, "/input.txt"), "utf-8").split("\n");
const passwords = input.map(parsePassword);

const isValidSledPassword = ({ value, policy }: Password): boolean => {
  const letterCount = value.split(policy.requiredLetter).length - 1;

  return letterCount >= policy.min && letterCount <= policy.max;
};

const countValidSledPasswords = (prevCount: number, password: Password) =>
  prevCount + (isValidSledPassword(password) ? 1 : 0);

const sledCount = passwords.reduce(countValidSledPasswords, 0);
console.log(`There are ${sledCount} valid sled passwords`);

const isValidTobogganPassword = ({
  value,
  policy: { min, max, requiredLetter },
}: Password): boolean =>
  (value[min - 1] === requiredLetter && value[max - 1] !== requiredLetter) ||
  (value[min - 1] !== requiredLetter && value[max - 1] === requiredLetter);

const countValidTobogganPasswords = (prevCount: number, password: Password) =>
  prevCount + (isValidTobogganPassword(password) ? 1 : 0);

const tobogganCount = passwords.reduce(countValidTobogganPasswords, 0);
console.log(`There are ${tobogganCount} valid toboggan passwords`);
