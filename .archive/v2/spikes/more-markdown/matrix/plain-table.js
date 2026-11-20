#!/usr/bin/env node
// Writes ../feature-table.md: the whole feature matrix as one plain Markdown table, plus the section-14
// features from ../haiku-unprimed/prompts.json and the comrak / pandoc implementation columns from
// data-impl.js (if present). Run: node plain-table.js
const fs = require("fs"), vm = require("vm"), path = require("path");
const here = __dirname;
const ctx = {}; ctx.window = ctx; vm.createContext(ctx);
const run = f => vm.runInContext(fs.readFileSync(path.join(here, f), "utf8"), ctx, { filename: f });
["data-meta.js", "data-blocks.js", "data-ext-a.js", "data-ext-b.js"].forEach(run);
ctx.MATRIX.baseEnd = ctx.MATRIX.rows.length;
run("data-fine.js");
ctx.MATRIX.fineEnd = ctx.MATRIX.rows.length;
["data-obsidian-plugins.js", "merge.js", "data-desc-a.js", "data-desc-b.js"].forEach(run);
const M = ctx.MATRIX;

// Section 14: features beyond the lineages, researched only through the probes and the impl columns.
const prompts = JSON.parse(fs.readFileSync(path.join(here, "..", "haiku-unprimed", "prompts.json"), "utf8"));
const s14 = prompts.filter(p => p.id.startsWith("14."));
const latex = s14.filter(p => parseInt(p.id.split(".")[1], 10) <= 20);
latex.forEach(p => M.rows.push({ g: "Beyond the lineages: LaTeX templates", f: p.feature, c: {}, s14: p.prompt }));
s14.filter(p => parseInt(p.id.split(".")[1], 10) > 20)
  .forEach(p => M.rows.push({ g: "Beyond the lineages: Obsidian plugins", f: p.feature, c: {}, s14: p.prompt }));
M.groups.push("Beyond the lineages: LaTeX templates", "Beyond the lineages: Obsidian plugins");

// Implementation columns. data-impl.js is expected to define MATRIX.impl[featureName] = {comrak: cell, pandoc: cell}.
if (fs.existsSync(path.join(here, "data-impl.js"))) run("data-impl.js");
const impl = M.impl || {};

const S = M.statuses;
const glyph = { C: "●", E: "◐", D: "◇", H: "↪", R: "✕", U: "–", Q: "?", I: "" };

function cell(v) {
  if (!v) return "";
  const [st, syn] = v;
  if (st === "I") return String(syn).replace(/\|/g, "\\|");
  const g = glyph[st] || st;
  if (!syn) return g;
  return g + " " + codeSpan(syn);
}
// A plain Markdown code span: newlines shown as ⏎, pipes escaped for the table, and a backtick fence
// longer than any run of backticks inside.
function codeSpan(s) {
  const body = String(s).replace(/\\n/g, "\n").replace(/\n/g, " ⏎ ").replace(/\|/g, "\\|");
  const longest = Math.max(0, ...(body.match(/`+/g) || []).map(r => r.length));
  const fence = "`".repeat(longest + 1);
  const pad = body.startsWith("`") || body.endsWith("`") || longest ? " " : "";
  return fence + pad + body + pad + fence;
}

const cols = M.columns.map(c => [c.key, c.name]);
const implCols = [["comrak", "comrak 0.54 (flag)"], ["pandoc", "pandoc 3.11 (extension)"]];
const head = ["Feature", "What it is"].concat(cols.map(c => c[1]), implCols.map(c => c[1]));
const out = [];
out.push("# Markdown features: dialects and implementations", "");
out.push("One row per feature. The dialect columns come from the research notes and the feature matrix in `matrix/` (cell notes and sources are in its data files). The last two columns say what comrak 0.54 and pandoc 3.11 can do, and with which flag or extension, checked against the installed binaries where a test input could settle it.", "");
out.push("Key: ● core · ◐ extension or option (named) · ◇ de facto (rendered, unspecified) · ↪ workaround, usually raw HTML · ✕ removed · – unsupported · ? not established · blank: not researched for that column.", "");
out.push("The last two groups (features from LaTeX templates and from Obsidian plugins) were researched only through the model probes and the two implementation columns, so their dialect cells are blank.", "");
out.push("| " + head.join(" | ") + " |", "|" + head.map(() => "---").join("|") + "|");
M.groups.forEach(g => {
  const rows = M.rows.filter(r => r.g === g);
  if (!rows.length) return;
  out.push("| **" + g + "** |" + " |".repeat(head.length - 1));
  rows.forEach(r => {
    const d = (M.desc[r.f] || {}).d || r.s14 || "";
    const i = impl[r.f] || {};
    out.push("| " + [r.f.replace(/\|/g, "\\|"), d.replace(/\|/g, "\\|")]
      .concat(cols.map(([k]) => cell(r.c[k])), implCols.map(([k]) => cell(i[k]))).join(" | ") + " |");
  });
});
fs.writeFileSync(path.join(here, "..", "feature-table.md"), out.join("\n") + "\n");
const missing = M.rows.filter(r => !impl[r.f]).length;
console.log("wrote feature-table.md:", M.rows.length, "rows;", missing, "rows without implementation cells");
