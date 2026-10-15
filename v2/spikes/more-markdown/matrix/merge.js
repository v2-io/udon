// Merges the three row sources into one table, in the browser, so each researcher's file stays as written.
//   base    data-blocks.js, data-ext-a.js, data-ext-b.js (first pass)
//   fine    data-fine.js: replaces base rows with the same feature name, adds finer rows
//   plugins data-obsidian-plugins.js: fills a separate "Obsidian + plugins" column
// index.html records where each source ends (MATRIX.baseEnd, MATRIX.fineEnd).
(function () {
  const M = window.MATRIX;
  const base = M.rows.slice(0, M.baseEnd);
  const fine = M.rows.slice(M.baseEnd, M.fineEnd);
  const plug = M.rows.slice(M.fineEnd);

  // Base rows the fine pass replaced under new names (its report named these).
  const SUPERSEDED = {
    "Smart punctuation": ["Smart quotes", "Smart dashes and ellipsis (-- --- ...)", "Symbol replacements ((c) (tm) +- -> =>)"],
    "Embed / transclusion": ["Include another file"]
  };
  // Plugin rows that name a fine/base feature in different words (coordinator's mapping).
  const ALIAS = {
    "Smart punctuation": ["Smart quotes", "Smart dashes and ellipsis (-- --- ...)"],
    "Table cell merge (colspan / rowspan)": ["Column and row spans"],
    "Multiple header rows / headerless table": ["Table: more than one header row", "Table without a header row"],
    "Multi-line / block content in a table cell": ["Line break inside a table cell", "Block content in a table cell (lists, paragraphs)"],
    "Checkboxes in table cells": ["Task checkbox inside a table cell"],
    "Table written as a fenced data block": ["Table built from a data block (JSON, CSV)"],
    "Decimal-point column alignment": ["Decimal-point alignment in a column"],
    "Example list (@)": ["Example list ((@) numbered across the document)"],
    "Custom task statuses": ["Task states other than done and not done"],
    "Spoiler / redaction": ["Spoiler"],
    "Small caps / run-in / drop cap": ["Small caps"],
    "Arrow and symbol substitution": ["Symbol replacements ((c) (tm) +- -> =>)"],
    "Inline icons": ["Icon shortcodes"],
    "Sparkline": ["Inline sparkline or chart"],
    "Sidenotes / margin notes": ["Margin note / sidenote"],
    "@-mention": ["Mention (@name)"],
    "Line import (@import)": ["Include another file"],
    "Ranged / attributed embed": ["Include another file"],
    "Defined terms / glossary": ["Defined terms (glossary)"],
    "Code block header options": ["Code block options (line numbers, highlighted lines, filename)"],
    "Diagram fence (beyond mermaid)": ["Diagram fence"],
    "Highlight color": ["Highlight"]
  };

  const rows = base.slice();
  const idx = f => rows.findIndex(r => r.f === f);
  const supersededBy = {};
  Object.entries(SUPERSEDED).forEach(([old, news]) => news.forEach(n => { supersededBy[n] = old; }));

  // Insert r near the previously placed row of the same pass, else at the end of its group.
  function place(r, last) {
    if (last >= 0 && last < rows.length && rows[last].g === r.g) { rows.splice(last + 1, 0, r); return last + 1; }
    let end = -1;
    rows.forEach((x, k) => { if (x.g === r.g) end = k; });
    if (end >= 0) { rows.splice(end + 1, 0, r); return end + 1; }
    rows.push(r); return rows.length - 1;
  }

  let last = -1;
  fine.forEach(r => {
    const i = idx(r.f);
    if (i >= 0) { rows[i] = r; last = i; return; }
    const old = supersededBy[r.f];
    const j = old ? idx(old) : -1;
    if (j >= 0) { rows[j] = r; last = j; return; }
    last = place(r, last);
  });

  // The "Obsidian + plugins" column starts as a copy of core Obsidian.
  const ci = M.columns.findIndex(c => c.key === "obs");
  M.columns.splice(ci + 1, 0, { key: "obsp", name: "Obsidian + plugins", sub: "core + community plugins" });
  rows.forEach(r => { if (r.c.obs) r.c.obsp = r.c.obs.slice(); });

  const hits = new Map();
  const fresh = [];
  plug.forEach(p => {
    const names = ALIAS[p.f] || (p.m ? [p.m] : (idx(p.f) >= 0 ? [p.f] : []));
    const targets = names.flatMap(n => (idx(n) >= 0 ? [n] : (SUPERSEDED[n] || []))).map(idx).filter(k => k >= 0);
    if (!targets.length) { fresh.push(p); return; }
    targets.forEach(k => {
      const row = rows[k];
      if (!hits.has(row)) hits.set(row, []);
      hits.get(row).push(p);
    });
  });

  hits.forEach((ps, row) => {
    const syn = ps.map(p => p.c.obs[1]).filter(Boolean).join("  ");
    const note = ps.map(p => p.c.obs[2]).filter(Boolean).join(" · ");
    const core = row.c.obs;
    if (core && (core[0] === "C" || core[0] === "D")) {
      row.c.obsp = [core[0], [core[1], syn].filter(Boolean).join("  "), [core[2], "Plugins: " + note].filter(Boolean).join(" ")];
    } else {
      row.c.obsp = ["E", syn, note];
    }
    row.psrc = ps.flatMap(p => p.src || []);
  });

  let lastP = -1;
  fresh.forEach(p => {
    const r = { g: p.g, f: p.f, psrc: p.src || [], c: {
      obs: ["U", "", "Provided by community plugins; whether core Obsidian has an equivalent was not checked"],
      obsp: p.c.obs } };
    lastP = place(r, lastP);
  });

  // Cell fixes after review (2026-10-14). Pandoc cells named a table type instead of showing syntax;
  // these examples were checked with pandoc 3.11 by the coordinator.
  const FIX = [
    ["Table without a header row", "pd", "----- -----\n  12   34\n----- -----", "A simple table with no header line. Simple, multiline and grid tables may omit the header; pipe tables may not"],
    ["Line break inside a table cell", "pd", "+------------+---+\n| line one\\  | b |\n| line two   |   |\n+------------+---+", "Grid table: a trailing backslash is a hard break inside the cell. Multiline and grid tables let a cell's text span source lines. In pipe tables <br> is raw HTML, kept only for HTML output"],
    ["Block content in a table cell (lists, paragraphs)", "pd", "+-------+---+\n| - a   | 1 |\n| - b   |   |\n+-------+---+", "Grid table: any block content inside a cell, here a list"],
    ["Column and row spans", "pd", "+-----+-----+\n| spans both|\n+=====+=====+\n| a   | b   |\n+-----+-----+", "Grid table: leaving out a | between cells makes one cell span both columns; row spans work the same way vertically"],
    ["CriticMarkup", "cm", "", "In none of these ten dialects; native in MultiMarkdown 6. The syntax is in the row's example"]
  ];
  FIX.forEach(([f, key, syn, note]) => {
    const row = rows.find(r => r.f === f);
    if (row && row.c[key]) { row.c[key][1] = syn; row.c[key][2] = note; }
  });

  // An Unsupported cell that still shows syntax is showing a fallback (usually raw HTML): call it a workaround.
  rows.forEach(r => Object.values(r.c).forEach(v => { if (v && v[0] === "U" && v[1]) v[0] = "H"; }));

  // Joseph (2026-10-14): leave out what only renders a fenced code block. An info string falls back to a plain
  // code block everywhere, so these are renderers, not syntax.
  const DROP = ["Interlinear gloss", "Admonition fence", "Charts and progress bars (fenced)", "Query blocks",
    "Buttons", "Diagram fence", "Table built from a data block (JSON, CSV)"];
  for (let k = rows.length - 1; k >= 0; k--) if (DROP.includes(rows[k].f)) rows.splice(k, 1);
  // Mixed rows: keep the row, blank only the fence-renderer cells.
  const UNFENCE = [
    ["Table of contents marker", "obsp", "A table-of-contents fence (Automatic Table of Contents plugin) was removed as a code-block renderer"],
    ["Inline sparkline or chart", "gh", "Only block charts, through a mermaid code block"],
    ["Inline sparkline or chart", "obs", "Only block charts, through a mermaid code block"],
    ["Inline sparkline or chart", "gl", "Only block charts, through mermaid or PlantUML code blocks"],
    ["Inline sparkline or chart", "myst", "Only block charts, through the mermaid directive"]
  ];
  UNFENCE.forEach(([f, key, note]) => {
    const row = rows.find(r => r.f === f);
    if (row && row.c[key]) row.c[key] = ["U", "", note];
  });

  // "Tables & lists" grew past 30 rows; split it by subject.
  const gi = M.groups.indexOf("Tables & lists");
  if (gi >= 0) {
    M.groups.splice(gi, 1, "Tables", "Lists & tasks");
    rows.forEach(r => {
      if (r.g === "Tables & lists") r.g = /table|cell|column|span|decimal|header/i.test(r.f) ? "Tables" : "Lists & tasks";
    });
  }

  M.rows = rows;
  M.mergeLog = { base: base.length, fine: fine.length, plugins: plug.length, pluginMerged: plug.length - fresh.length, pluginNew: fresh.length, total: rows.length };
})();
