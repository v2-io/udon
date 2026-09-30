# 62 — Near-miss spellings from other notations: what should `key: value`, `key=value`, `# note`, `- item`, `[a, b]` do in lite?

*Raised by the history survey (files 50-69), 2026-09-29, second continuation. Neutral: the question, the alternatives, and where it has come up. Sources are pointers for the second pass, not authority.*

## The question

People and LLMs arrive at UDON carrying YAML, INI, TOML, XML and Markdown habits. Several very natural spellings are, in UDON, perfectly good **prose**, so they parse without complaint and silently mean something other than what the writer intended:

```udon
|server
  host: example.com
  port=8080
  # this looks like a comment
  - alpha
  timeout 30
```

Under 0.10.01 every line under `|server` is text (no `|`, no `:label` at line start, `;` is the comment marker), so the element has one text child of five lines and **no attributes at all**. The writer meant three attributes, a comment and a list.

Lite is the small stable subset that agents and people will write by hand. Does lite do anything about near-misses (a warning, a lint tier, a reserved refusal), or is "it is prose" the whole answer?

## Why lite must decide

- "Markdown *is* correct UDON" (Joseph, 2025-12-23; 2025-12-24: "markdown *is* a subset of udon"). That principle is what makes `# heading`, `- item`, `**b**` and `| a | b |` prose, and it is why `#` can never be the comment marker. So some near-misses are prose **by design**, and cannot be turned into warnings without breaking the Markdown-subset property.
- The others (`key: value`, `key=value`) have no such claim on being prose, but they are indistinguishable from prose in a document that is, say, a paragraph containing a colon.
- The Dec 2025 usability harness (below) is the one body of evidence about what fresh writers do when they have not read the spec: several independent agents, asked to *invent* a notation meeting UDON's goals, converged on the same near-misses.

## Alternatives

### A — prose, silently (0.10.01 as written)

```text
document
└ element server
    ├ text "host: example.com\nport=8080\n# this looks like a comment\n- alpha\ntimeout 30\n"
```

Least machinery; consistent with "text is the default". Failure is discovered downstream, when `host` is missing.

### B — prose, but the parser may emit an advisory (non-error, non-tree-changing) for shapes that look like attribute lines

```text
element server
  ├ text "host: example.com\n…"
  anomaly: advisory at line 2 — "host:" resembles an attribute; attributes are spelled ":host …"
```

Requires deciding which shapes qualify (`word:` at line start? `word=` ?) and whether an advisory can exist in a format whose Errors/Warnings are otherwise about structure. Interacts with the "never a Warning for legitimate prose" cost: `Note: the port is fixed.` is a legitimate sentence.

### C — reserve the shapes that no Markdown-compatible reading needs (`word=`, `word:` at line start inside an element) as refused syntax

Stronger protection, but it means ordinary sentences starting `Note:` or `Warning:` need escaping. Probably contradicts least surprise for prose authors.

### D — spell the guidance, not the parser (tutorial / linter tier, not core)

Lite's core stays A; a companion "common mistakes" table and a lint profile carry B.

## Evidence from the usability harness (Dec 2025, `test/usability/results/AGENT_FEEDBACK.md`)

Agents given UDON's goals and asked to invent a notation independently wrote: `key: value` pairs, `name=foo` / `[key=value]` attributes, `#` or `//` line comments, `[a, b, c]` inline lists, `- item` block lists, and a `|` or `>` prose marker. Their own concerns included "If I write a bare word on a line, is it an element or a malformed attribute?", "How do you disambiguate `key: value` (data) from `key: Prose text here`?", and "How do you handle numeric types?". Sources are LLM outputs, not authority; what they show is the prior a fresh writer brings.

## Sub-questions

- Is there a small set of near-misses lite chooses to *name in its own text* (a "these are prose" table) even if the parser does nothing? Least-surprise may be served by the table alone.
- Does the answer differ at document top level (where a `key: value` line is nearly always prose) and inside an element (where it is more likely an attempted attribute)?
- `[a, b, c]` as a value: a text value `"[a, b, c]"`, or an array? See [83-lists-and-sequences] (other survey) and [12](12-missing-values-and-what-counts-as-valid.md) for what counts as a value.

## Where it came up

- Joseph 2025-12-23, on a usability-test prompt: "Markdown *is* correct UDON: `# API Documentation` … `| Tier | Requests/min |` … That is correct UDON from the beginning." (`~/.claude/history.jsonl` line 5527); 2025-12-24 line 5569: "markdown *is* a subset of udon — except frontmatter can now be anywhere."
- Joseph 2025-12-23, line 5521: "attribute values have type based on syntax — NOT value-sniffing."
- `test/usability/results/AGENT_FEEDBACK.md` (Dec 23-24 2025, Haiku 4.5 / Sonnet 4.5 / Opus 4.5 inventions and enablement critiques) and `test/usability/enablement-synthesis.md` ("Recurring Critiques": the surface area; "UDON-Simple subset might aid adoption").

## Interactions

- [03](03-semicolon-in-prose.md) (what `;` costs prose), [08](08-pipes-and-markdown-tables.md) (Markdown compatibility at the `|` end), [06](06-suffix-characters.md), [12](12-missing-values-and-what-counts-as-valid.md).
