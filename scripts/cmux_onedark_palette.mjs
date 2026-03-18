#!/usr/bin/env node

import { execFileSync } from "node:child_process";

const domain = "com.cmuxterm.app";
const key = "workspaceTabColor.customColors";

const oneDarkPalette = [
  "#98C379A6",
  "#61AFEFA6",
  "#E5C07BA6",
  "#C678DDA6",
  "#56B6C2A6",
  "#E06C75A6",
  "#D19A66A6",
  "#7F848EA6",
  "#ABB2BFA6",
];

execFileSync("defaults", ["write", domain, key, "-array", ...oneDarkPalette], {
  stdio: "inherit",
});

const saved = execFileSync("defaults", ["read", domain, key], {
  encoding: "utf8",
}).trim();

console.log(`Saved ${key} for ${domain}:`);
console.log(saved);
