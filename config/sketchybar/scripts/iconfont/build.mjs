import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { SVGPathData } from "./node_modules/svg-pathdata/dist/index.js";

const here = path.resolve(path.dirname(fileURLToPath(import.meta.url)));
const sketchybarDir = path.resolve(here, "../..");
const glyphDir = path.join(here, "glyphs");
const outputDir = path.join(sketchybarDir, "assets", "fonts");
const knightSource = path.join(sketchybarDir, "assets", "knightIconFilled.test.svg");
const knightGlyphName = "hk-knight";
const knightEyesGlyphName = "hk-knight-eyes";
const firstCodepoint = 0xe000;

function cleanDir(dir) {
  fs.rmSync(dir, { recursive: true, force: true });
  fs.mkdirSync(dir, { recursive: true });
}

function polar(cx, cy, radius, degrees) {
  const radians = (degrees * Math.PI) / 180;
  return {
    x: cx + radius * Math.cos(radians),
    y: cy + radius * Math.sin(radians),
  };
}

function f(value) {
  return Number(value.toFixed(3));
}

function generateRingGlyph(second) {
  const center = 512;
  const outerRadius = 448;
  const innerRadius = 328;

  const startAngle = -90;
  let sweep = (second + 1) * 6;
  if (sweep >= 360) {
    sweep = 359.5;
  }
  const endAngle = startAngle + sweep;
  const largeArc = sweep > 180 ? 1 : 0;

  const outerStart = polar(center, center, outerRadius, startAngle);
  const outerEnd = polar(center, center, outerRadius, endAngle);
  const innerStart = polar(center, center, innerRadius, startAngle);
  const innerEnd = polar(center, center, innerRadius, endAngle);

  const arcPath = [
    `M ${f(outerStart.x)} ${f(outerStart.y)}`,
    `A ${outerRadius} ${outerRadius} 0 ${largeArc} 1 ${f(outerEnd.x)} ${f(outerEnd.y)}`,
    `L ${f(innerEnd.x)} ${f(innerEnd.y)}`,
    `A ${innerRadius} ${innerRadius} 0 ${largeArc} 0 ${f(innerStart.x)} ${f(innerStart.y)}`,
    "Z",
  ].join(" ");

  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">
  <path fill="#000000" d="${arcPath}"/>
</svg>`;
}

function generateKnightGlyph(includeEyes) {
  const source = fs.readFileSync(knightSource, "utf8");
  const pathMatch = source.match(/<path[^>]*d="([^"]+)"[^>]*>/is);
  if (!pathMatch) {
    throw new Error(`Could not parse knight path from ${knightSource}`);
  }

  const raw = pathMatch[1].replace(/\s+/g, " ").trim();
  const subpaths = raw.match(/M[^M]+/g);
  if (!subpaths || subpaths.length === 0) {
    throw new Error(`Could not split knight subpaths from ${knightSource}`);
  }

  // Normalize smooth curves once so all contours are explicit cubic paths.
  const outerPath = new SVGPathData(subpaths[0].trim()).toAbs().normalizeST().encode();
  let d = outerPath;

  if (includeEyes) {
    // Font outlines use non-zero winding; reverse inner eye contours to make true cutouts.
    const eyeContours = [];
    for (let i = 1; i < subpaths.length; i += 1) {
      const reversedEye = new SVGPathData(subpaths[i].trim())
        .toAbs()
        .normalizeST()
        .reverse()
        .encode();
      eyeContours.push(reversedEye);
    }

    if (eyeContours.length > 0) {
      d = `${outerPath} ${eyeContours.join(" ")}`;
    }
  }

  const minX = 168;
  const minY = 30;
  const width = 505;
  const height = 535;
  const scale = 1024 / height;
  const xOffset = (1024 - width * scale) / 2;

  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024">
  <path fill="#000000" fill-rule="evenodd" d="${d}" transform="translate(${f(xOffset)} 0) scale(${scale} ${scale}) translate(${-minX} ${-minY})"/>
</svg>`;
}

cleanDir(glyphDir);
fs.mkdirSync(outputDir, { recursive: true });

if (!fs.existsSync(knightSource)) {
  throw new Error(`Missing knight source SVG: ${knightSource}`);
}

const codepoints = {};
codepoints[knightGlyphName] = firstCodepoint;
codepoints[knightEyesGlyphName] = firstCodepoint + 1;

const knightTarget = path.join(glyphDir, `${knightGlyphName}.svg`);
const knightEyesTarget = path.join(glyphDir, `${knightEyesGlyphName}.svg`);
fs.writeFileSync(knightTarget, generateKnightGlyph(false), "utf8");
fs.writeFileSync(knightEyesTarget, generateKnightGlyph(true), "utf8");

for (let second = 0; second < 60; second += 1) {
  const name = `sec-${String(second).padStart(2, "0")}`;
  const file = path.join(glyphDir, `${name}.svg`);
  const svg = generateRingGlyph(second);
  fs.writeFileSync(file, svg, "utf8");
  codepoints[name] = firstCodepoint + 2 + second;
}

const codepointsPath = path.join(here, "codepoints.json");
fs.writeFileSync(codepointsPath, `${JSON.stringify(codepoints, null, 2)}\n`, "utf8");
