import { readFileSync } from "fs";
import { join } from "path";

const passports = readFileSync(join(__dirname, "/input.txt"), "utf-8").split(
  "\n\n"
);

const eyeColors = new Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]);
const isValid = (passport: string, strict?: boolean): boolean => {
  const requiredFields = new Set([
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid",
  ]);

  const passportFields = passport.split(/\s/);
  for (let idx = 0; idx < passportFields.length; idx++) {
    const field = passportFields[idx];

    const [fieldKey, fieldVal] = field.split(":");
    if (requiredFields.has(fieldKey)) requiredFields.delete(fieldKey);

    if (!strict) continue;

    switch (fieldKey) {
      case "byr": {
        if (fieldVal.length !== 4) return false;
        if (Number(fieldVal) < 1920 || Number(fieldVal) > 2002) return false;
        break;
      }
      case "iyr": {
        if (fieldVal.length !== 4) return false;
        if (Number(fieldVal) < 2010 || Number(fieldVal) > 2020) return false;
        break;
      }
      case "eyr": {
        if (fieldVal.length !== 4) return false;
        if (Number(fieldVal) < 2020 || Number(fieldVal) > 2030) return false;
        break;
      }
      case "hgt": {
        const n = Number(fieldVal.slice(0, -2));
        const units = fieldVal.slice(-2);
        if (units !== "cm" && units !== "in") return false;
        if (units === "cm" && (n < 150 || n > 193)) return false;
        if (units === "in" && (n < 59 || n > 76)) return false;
        break;
      }
      case "hcl": {
        if (fieldVal.length !== 7) return false;
        if (fieldVal[0] !== "#") return false;
        if (!fieldVal.slice(1).match(/[0-9a-f]{6}/)) return false;
        break;
      }
      case "ecl": {
        if (!eyeColors.has(fieldVal)) return false;
        break;
      }
      case "pid": {
        if (fieldVal.length !== 9) return false;
        if (!fieldVal.match(/[0-9]{9}/)) return false;
        break;
      }
    }
  }

  return requiredFields.size === 0;
};
const fieldsExistCount = passports.reduce(
  (count: number, passport: string) => count + (isValid(passport) ? 1 : 0),
  0
);
console.log(fieldsExistCount);

const validCount = passports.reduce(
  (count: number, passport: string) =>
    count + (isValid(passport, true) ? 1 : 0),
  0
);

console.log(validCount);
