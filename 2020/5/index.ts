import { readFileSync } from "fs";
import { join } from "path";

const inputs = readFileSync(join(__dirname, "/input.txt"), "utf-8");
