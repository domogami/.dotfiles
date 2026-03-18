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
  "#61AFEFA6",
  "#98C379A6",
  "#E5C07BA6",
  "#C678DDA6",
  "#56B6C2A6",
  "#E06C75A6",
  "#D19A66A6",
  "#7F848EA6",
  "#ABB2BFA6",
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
