import { readFileSync } from "fs";
import { join } from "path";

const rules = readFileSync(join(__dirname, "/input.txt"), "utf-8")
  .split("\n")
  // Slice off rule sentence periods
  .map((rule) => rule.slice(0, -1));

const containedByTree: { [contentBag: string]: string[] } = {};
rules.forEach((rule) => {
  const [container, contents] = rule.split(" contain ");

  const [containerAdverb, containerColor] = container.split(" ");
  const containerKey = `${containerAdverb}-${containerColor}`;

  const contentBags = contents.split(", ");
  contentBags.forEach((contentBag) => {
    const [count, adverb, color] = contentBag.split(" ");

    const contentBagKey = `${adverb}-${color}`;
    if (!containedByTree[contentBagKey]) {
      containedByTree[contentBagKey] = [];
    }
    containedByTree[contentBagKey].push(containerKey);
  });
});

const getContainingBags = (type: string): Set<string> => {
  const immediatelyContained = containedByTree[type];

  if (!immediatelyContained) return new Set(immediatelyContained);

  return immediatelyContained.reduce((set, b) => {
    const s = getContainingBags(b);
    s.forEach((bag) => set.add(bag));
    return set;
  }, new Set(immediatelyContained));
};

const containShinyGoldBags = getContainingBags("shiny-gold");
console.log(containShinyGoldBags.size);

interface Bag {
  count: number;
  type: string;
}

const containedInTree: { [container: string]: Bag[] } = {};
rules.forEach((rule) => {
  const [container, contents] = rule.split(" contain ");

  const [containerAdverb, containerColor] = container.split(" ");
  const containerKey = `${containerAdverb}-${containerColor}`;

  const contentBags = contents.split(", ").map((contentBag) => {
    const [count, adverb, color] = contentBag.split(" ");

    return {
      count: count === "no" ? 0 : Number(count),
      type: `${adverb}-${color}`,
    } as Bag;
  });

  containedInTree[containerKey] = contentBags;
});

const countBagsWithin = (type: string): number => {
  const bagsImmediatelyWithin = containedInTree[type];
  if (!bagsImmediatelyWithin) return 0;

  return bagsImmediatelyWithin.reduce((count: number, bag: Bag) => {
    const immediateCount = bag.count;
    const nestedCount = immediateCount * countBagsWithin(bag.type);
    return count + immediateCount + nestedCount;
  }, 0);
};

const bagsWithinShinyGold = countBagsWithin("shiny-gold");
console.log(bagsWithinShinyGold);
