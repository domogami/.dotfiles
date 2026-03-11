#!/usr/bin/env node

import { execFileSync } from "node:child_process";

const domain = "com.cmuxterm.app";
const key = "workspaceTabColor.customColors";

const oneDarkPalette = [
  "#98C379",
  "#61AFEF",
  "#E5C07B",
  "#C678DD",
  "#56B6C2",
  "#E06C75",
  "#D19A66",
  "#7F848E",
  "#ABB2BF",
];

execFileSync("defaults", ["write", domain, key, "-array", ...oneDarkPalette], {
  stdio: "inherit",
});

const saved = execFileSync("defaults", ["read", domain, key], {
  encoding: "utf8",
}).trim();

console.log(`Saved ${key} for ${domain}:`);
console.log(saved);
