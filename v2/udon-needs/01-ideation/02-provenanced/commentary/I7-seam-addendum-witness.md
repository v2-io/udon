---
source: I7 seam-addendum — witness lines for 7c search portals + reach-signals across 7a/7b
gathered: 2026-07-21
status: commentary — witness lines (existence/shape is the evidence); 7c portals witnessed, deliberately not chased exhaustively per the section brief
paths:
  - /Users/josephwecker-v2/src/memorata/ (portal, exists)
  - /Users/josephwecker-v2/.grok/memory/udon-4fdadfea/ (portal, exists)
  - /Users/josephwecker-v2/.claude/projects/-Users-josephwecker-v2-src-udon*/ (portal, exists — several project JSONL dirs)
  - /Users/josephwecker-v2/src/udon/v2/.archived/second-pass/spikes/session-vault/raw/{claude,grok}/INVENTORY.md (moved from the map's stated path)
  - /Users/josephwecker-v2/vaults/gemini/archive/analysis-v1/analysis/ (portal, exists — 13 files hit "AI Agent")
  - /Users/josephwecker-v2/vaults/Operations/claude-code-tools.md (exists — captured shipping-harness tool schemas)
source_commit: udon repo 3d8e5b9c52b2a581c4ab9021984423073a694693 (portals external/non-git — mtime/gather-date locate)
categories: [search-portals, witness, strategy, agent-tool-ideology, merge-note]
why_included: >
  7c rows are STRATEGIES (query surfaces), not single-file mines — the section
  brief says witness/characterize, do not chase portals exhaustively. This
  file records which portals resolve, which moved, which are dry, and the one
  that is itself a first-class artifact (claude-code-tools.md). Also carries
  the day-one reach-signal witness lines that don't warrant their own copy.
---

# 7c — Search portals & outside-`~/src` trails (witnessed, not exhausted)

The section brief is explicit: these are *strategies*, resolved with
witness/characterize, not chased to exhaustion. Existence and shape verified;
deep mining is left to a phase-2 targeted query when a specific need makes a
portal load-bearing.

| Portal | Status (2026-07-21) | Witness |
|---|---|---|
| `~/src/memorata/` + memorata3-search | **Exists.** | The query surface for pre-2015 objectives, "use UDON for", enablement talk, multi-agent brainstorms. Not queried this pass — it is a search *tool*, mined on demand; CONVERGENCES already notes "a few unrun memorata3 phrasings." |
| `~/.grok/memory/udon-4fdadfea/` | **Exists.** | This cycle's own gather-decision/reservoir-weighting provenance (grok's memory). Meta-provenance, not fresh demand. |
| `~/.claude/projects/…-udon*/` JSONL | **Exists** (several: `-src-udon`, `-src-udon-v2-udon-needs-1-gathering…`, `…-agentic-tooling-sources`). | MB-scale session transcripts. Prefer the session-vault INVENTORY extracts first (below) before re-exporting raw JSONL — the map's stated preference, upheld. |
| `session-vault/raw/{claude,grok}/INVENTORY.md` | **Moved.** Not at `~/src/udon/v2/session-vault/` — found at `~/src/udon/v2/.archived/second-pass/spikes/session-vault/raw/{claude,grok}/INVENTORY.md`. | The archived second-pass catalog; consult before re-exporting JSONL. Path-drift noted for the merge. |
| `~/vaults/gemini/archive/analysis-v1/analysis/**` | **Exists** — 13 files hit "AI Agent" (e.g. `ELIXIR_BEST_PRACTICES_Analysis.md`, several *Release It!* chapters). | Book analyses with "Practicability for AI Agents" sections. grok's pass found no UDON string hits; these are agent-*practicability* material, not UDON-usage — relevant to the harness consumer, tangential to UDON. Witnessed, not mined. |
| `~/vaults/Operations/claude-code-tools.md` + MCP notes | **Exists — and is itself a first-class artifact.** | This is a **verbatim capture of a shipping agent harness's own tool schemas** (the Agent/Bash/Read/Edit/Grep tool prose from Claude Code, with the "when to use / when NOT to use the Agent tool" guidance, one-shot stateless-subagent contract, stdout/stderr summary discipline). That is live Tier-2 (in-vivo shipped practice) tool-definition-anatomy evidence — a real harness telling agents how to treat its tools. **Overlaps Part III vaults section — merge-time check (flagged in the row itself).** Worth a proper characterization if it isn't already covered by a Part III agent's harness-invivo work; not duplicated here to avoid double-mining. |
| `~/vaults/Operations/Obsidian-Workflow/`, `AGENT_FIX_RECOMMENDATIONS.md` | **Dry at stated paths** — neither found under `~/vaults/Operations/`. | Possible rename/move, or Part III territory. Ledgered blocked; a Part III agent with the vaults tree in hand is better placed to relocate them. |
| Standing harvest (Joseph's end-user + ideation dump) | **No path yet** — not landed. | Flagged PRIMARY-when-it-lands by both the map and CONVERGENCES' standing-open-items. Watch item, not extractable now. |

# Reach-signal witness lines (7a/7b — shape/existence is the evidence)

These are one-line demand witnesses too small for their own copy but too
signal-bearing to drop (the "editor support was day-one ambition" pattern from
the Brief):

- **Editor integration was day-one.** 2011 `objectives.asciidoc` scores
  "Editor integration" **9** (Support tier); `_ref/udon/misc/udon.vim` (91 lines,
  2011) and `doc/TODO.asciidoc`'s "syntax highlighter" build-item are the
  artifacts. The vimscript itself is noise; the *ambition* is the witness. (Now
  carried by ux/ tree-sitter/vim/tmLanguage + the autocolors engine.)
- **Interchange/converters were day-one.** `bin/xml2udon` (182 lines) +
  `doc/TODO.asciidoc`'s `udon2xml/xml2udon`, `udon2json/json2udon` items +
  `_ref/udon-ruby` converter suite → today's TOOLING-WISHLIST `to-json` /
  UTILS conversion. A 14-year-standing unmet-in-full demand.
- **"Standard API" + "In-document API usage" scored 8** in the 2011 Utility
  tier — the library-consumer demand (§7a / §5c's hand-rolled parsers awaiting
  libudon) is not new; it was named at concern-level 8 before any consumer
  existed.
- **The name came after the intent.** `.attic/scratch.asciidoc`'s naming search
  (SANS/DISMAL/DEAN/SONO…) witnesses that the design goals predated "UDON" as
  a name — the demand drove the artifact, not the reverse (the demand-first
  inversion this whole compilation is built on, visible at the origin).
- **Streaming was named "online processing"/"online mode"** in 2011
  (`objectives.asciidoc` Utility 6; udon-c `DECIDED.md` `## PARSING`) — see the
  archaeology characterization; recorded here as the single highest-value
  cross-era witness.

# Note to the merge / phase-2

The seam-transport that pulled MERGED §7/§8/§11 back in was correct: §7
(library/API) reads supply-side but is demand evidence about consumers and is
first-class for the harness programme; §8 (archaeology) yields genuine
cross-ERA re-derivation evidence distinct from the within-author coherence
caveat; §11 (portals) are query surfaces best left as strategies. The one
portal that is itself an artifact — `claude-code-tools.md` — should be
reconciled against Part III's harness-invivo coverage rather than
double-characterized.
