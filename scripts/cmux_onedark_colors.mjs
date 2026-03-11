#!/usr/bin/env node

import fs from "node:fs";
import os from "node:os";
import path from "node:path";

const sessionPath = path.join(
  os.homedir(),
  "Library",
  "Application Support",
  "cmux",
  "session-com.cmuxterm.app.json"
);

const oneDarkPalette = [
  "#61AFEF",
  "#98C379",
  "#E5C07B",
  "#C678DD",
  "#56B6C2",
  "#E06C75",
  "#D19A66",
  "#7F848E",
  "#ABB2BF",
];

function fail(message) {
  console.error(message);
  process.exit(1);
}

if (!fs.existsSync(sessionPath)) {
  fail(`cmux session file not found: ${sessionPath}`);
}

const raw = fs.readFileSync(sessionPath, "utf8");
const session = JSON.parse(raw);

if (!Array.isArray(session.windows)) {
  fail("Unexpected cmux session format: missing windows array");
}

let changed = 0;

for (const windowState of session.windows) {
  const workspaces = windowState?.tabManager?.workspaces;
  if (!Array.isArray(workspaces)) {
    continue;
  }

  for (const [index, workspace] of workspaces.entries()) {
    const nextColor = oneDarkPalette[index % oneDarkPalette.length];
    if (workspace.customColor !== nextColor) {
      workspace.customColor = nextColor;
      changed += 1;
    }
  }
}

const backupPath = `${sessionPath}.bak`;
fs.writeFileSync(backupPath, raw);
fs.writeFileSync(sessionPath, JSON.stringify(session));

console.log(`Updated ${changed} workspace colors in ${sessionPath}`);
console.log(`Backup written to ${backupPath}`);
console.log(`Palette: ${oneDarkPalette.join(", ")}`);
