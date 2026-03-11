const path = require("path");

module.exports = {
  name: "SketchybarCustomIconsV2",
  inputDir: path.resolve(__dirname, "glyphs"),
  outputDir: path.resolve(__dirname, "../../assets/fonts"),
  fontTypes: ["ttf"],
  assetTypes: [],
  codepoints: require(path.resolve(__dirname, "codepoints.json")),
  normalize: true,
  fontHeight: 1024,
  descent: 128
};
