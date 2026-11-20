# The fence-knot table — measured

**What this is:** a first-pass measurement report, sibling to
[`commonmark-non-conflict-table.md`](commonmark-non-conflict-table.md). The seed
([`thoughts-on-scope.md`](thoughts-on-scope.md) §3) called this the
highest-value small probe, because the repo already fights the knot hard enough
to need `.fmt-mdignore` protection. This enumerates the nestings and reports
what survives. It rules nothing.

**Spine:** *which nestings of UDON verbatim and markdown fences survive, and
which escape hatches exist* — the matrix is §2, the mechanics behind it §3, and
the background explainer is in the appendix.

**Run:** 2026-07-28 · reference parser at `core/` HEAD (0.9.0-alpha.2) · case
matrix `probes/fence_cases.py` (22 cases, ids stable and cited below) · raw
event traces `probes/out/fence-events.txt`. Register keys are defined in the
non-conflict table's Appendix A and used identically here.

---

## Bottom line

1. **UDON's ` ``` ` fence is exactly three backticks and has no length
   variation.** The first three backticks open; a fourth becomes the first byte
   of the info string. So markdown's universal nesting escape hatch — *open with
   more backticks than the content contains* — does not exist here.
2. **It does not fail loudly.** Attempting it produces plausible-looking but
   scrambled structure (the outer fence closes on the inner opener, the outer
   closer opens a fresh fence) and one late `UnclosedFreeform` Warning at EOF,
   far from the cause. Case `f31` is this repo's actual `.fmt-mdignore` pain,
   reproduced exactly.
3. **The escape hatch that does work is `!:label:` block verbatim.** Being
   geometric (dedent-closed) rather than delimited, no interior content can
   close it. Measured to three grammars deep with mixed backtick counts
   (`f20`, `f22`).
4. **Two smaller hatches:** `~~~` is inert to UDON (`f07`), and a ` ``` `
   indented past an established content base is literal (`f06`) — the latter
   only inside an element, since document root has no content base.
5. **No divergence found in this probe.** Every fence behavior measured matches
   CORE §10.3 as written. The pain is a design consequence, not a bug — which
   makes the open question a *policy* one, not a mechanics one.

**Limits, up front:** these are 22 hand-built cases chosen by my judgment of
what nests in practice, not a corpus — so the matrix shows what *can* happen,
not how often it does. The three suggestions in §4 are **INFERRED** from the
measurements and are proposals only.

---

## 1. Why the two families differ

One line of background, because it predicts every row below: CORE §13.1's
**extent kind** is the whole story. `!:label:` is **geometric** (closes on
dedent — nothing inside can close it). The ` ``` ` fence and `!{:label: …}` are
**delimited** (close on a printed closer — so interior content can close them).
Markdown's fences are delimited too, but CommonMark requires the closer to be
**at least as long as the opener**, which is exactly the affordance UDON lacks.
Full form table in the appendix.

---

## 2. The nesting matrix — what survives

"Survives" = the inner content reaches a consumer intact and with its
delimiters balanced.

| # | Nesting | Result | Register |
|---|---|---|---|
| `f10` | `!:markdown:` ⊃ markdown ` ``` ` fence | Survives whole. Every line arrives as `RawContent`, both fence delimiters included. | LAW §10.1 |
| `f11` | `!:markdown:` ⊃ ` ```udon ` fence ⊃ UDON | Survives whole. | LAW §10.1 |
| `f12` | UDON ` ``` ` fence ⊃ markdown ` ``` ` fence | **Fence leakage.** The inner opener survives as body; the inner *closer* is consumed as the **outer's** closer. Bytes are all accounted for, but the body a consumer receives has an unbalanced inner fence, and everything after is prose. | LAW §10.3 — destructive for the use case |
| `f13` | `!{:md: …}` ⊃ single backticks | Survives — brace-counted. | LAW §10.2 |
| `f14` | `!{:md: …}` ⊃ triple backticks | Survives — ` ```js x ``` ` arrives intact as `RawContent`. | LAW §10.2 |
| `f20` | **the ugly middle**: `!:markdown:` ⊃ md ` ``` ` ⊃ UDON ⊃ `!:elixir:` | Survives whole, three grammars deep, relative indentation preserved. | LAW §10.1 |
| `f21` | UDON ` ``` ` ⊃ md ` ``` ` ⊃ UDON ⊃ `!:elixir:` | Scrambled. Outer closes on the inner's closer; the trailing delimiter opens a second fence; `UnclosedFreeform` at EOF. | LAW §10.3 |
| `f22` | `!:markdown:` ⊃ md ` ```` ` (4) ⊃ UDON ` ``` ` (3) | Survives whole — the block verbatim is indifferent to mixed interior fence lengths. | LAW §10.1 |
| `f30` | markdown doc ⊃ ` ```udon ` fence *(the B2 case, read by UDON)* | Fence recognized; UDON source arrives as inert body text; surrounding markdown stays prose. Works. | LAW §10.3 |
| `f31` | markdown doc ⊃ ` ````udon ` (4) ⊃ UDON ` ``` ` (3) | The repo's actual pain, reproduced. Info string becomes `` `udon ``; the inner ` ``` ` closes the outer; the outer's ` ```` ` closer opens a new fence; `UnclosedFreeform` at EOF. | LAW §10.3 |
| `f32` | markdown doc ⊃ ` ```udon ` ⊃ UDON ⊃ `!:elixir:` | Works — no ` ``` `-alone line inside, so nothing leaks. | LAW §10.3 |
| `f41` | unclosed `!:sh:` at EOF | Closes silently, content kept. Geometric constructs have no unclosed state. | LAW §13.3 |

### The escape hatches, and the one that isn't

| Hatch | Works? | Evidence |
|---|---|---|
| `!:label:` block verbatim | **Yes**, no interior content closes it; nests to depth | `f10`, `f11`, `f20`, `f22` |
| `~~~` on the markdown side | **Yes**, inert to UDON. Converse: also *not* verbatim to UDON, so contents read as ordinary prose | `f07` |
| Indentation past a content base | **Yes**, but only inside an element — document root has no content base (non-conflict table §3.1) | `f06` |
| Inline `!{:label: …}` | **Yes**, brace-counted; single-flow content only | `f13`, `f14` |
| **Fence-length variation** | **No — does not exist.** Listed explicitly because it is the reflex a markdown-trained author or agent reaches for first | `f02`, `f04`, `f31` |

---

## 3. Fence mechanics — the detail behind §2

| # | Case | Input shape | What happens | Register |
|---|---|---|---|---|
| `f01` | baseline | ` ``` ` / body / ` ``` ` | Opens and closes; body byte-exact; delimiters consumed as structure, not text. | LAW §10.3 |
| `f02` | open with 4 | ` ```` ` / body / ` ``` ` | No 4-backtick fence exists. First three open; the **fourth becomes the first byte of the info string**. The later 3-backtick line closes it. | LAW §10.3 (*"everything after the opening backticks begins the body"*) |
| `f03` | 4-backtick line *inside* a 3-fence | ` ``` ` / body / ` ```` ` | Does **not** close — a closer *"must be followed by its line end."* Line stays body; fence runs to EOF → `UnclosedFreeform`. | LAW §10.3 |
| `f04` | markdown's escape hatch, verbatim | ` ```` ` / outer / ` ``` ` / inner / ` ``` ` / outer2 / ` ```` ` | Opens at char 3, body `` ` ``+`outer`; first inner ` ``` ` closes it; `inner` becomes prose; second inner ` ``` ` opens a new fence; `outer2` and the closing ` ```` ` become its body; EOF → `UnclosedFreeform`. | LAW §10.3 |
| `f05` | indented closer | closer at column 4 | Closes. Any indentation closes; whitespace right of the closer trimmed. | LAW §10.3 |
| `f06` | fence deeper than a content base | `\|sec` / prose at col 2 / ` ``` ` at col 4 | Not a fence — literal text, indentation preserved. | LAW §10.3 (*"never deeper than an established content base"*) |
| `f07` | `~~~` fence | `~~~` / body / `~~~` | Inert — four plain Text lines. | LAW (no UDON rule claims `~`) |
| `f08` | info string | ` ```udon ` | Info label emitted as the body's first Text (`"udon\n"`); the core does not distinguish it from body. | LAW §10.3 (*"an info label for free"*) |
| `f09` | backticks after prose | `some prose ``` ` | Literal — the line already committed to prose. | LAW §2.2, §10.3 |
| `f40` | unclosed at EOF | ` ``` ` / body ⟨EOF⟩ | Content kept, `UnclosedFreeform` Warning, document result `incomplete-input`. | LAW §13.3 |

**The asymmetry worth holding:** you cannot *open* a longer fence (`f02`), but a
longer line *inside* a fence will not close it (`f03`). So the only sequence
that reliably survives inside a UDON fence is one with no ` ``` `-alone line.

---

## 4. Suggestions — INFERRED, not measured

Reasoning from the above, offered as proposals:

- **`.fmt-mdignore` may be treating a symptom.** The protection exists because
  the repo writes nested examples with ` ```` `/` ``` ` — the one construction
  that cannot work. Rewriting those over `!:markdown:` would remove the need
  mechanically. Cheap to test on one file, and I have not tested it.
- **The absent length variation could use one explicit spec sentence.** CORE
  §10.3 defines the fence positively, and a careful reader *can* derive that
  longer fences do not exist — but `f02`/`f31` suggest the derivation is what
  readers skip. This is `spec/TODO-SPEC-CORE.md` territory, not a carve-out
  (CARVEOUTS has no fence item).
- **`UnclosedFreeform` is the only signal a scrambled nest produces**, and it
  arrives at EOF, far from the cause. If diagnostics work happens
  (`core/TODO-PARSER.md`), "fence closed by a line that was probably an inner
  opener" has a clean signature: a fence whose body contains a ` ```lang ` line,
  closed by a bare ` ``` `.

---

## Appendix — the verbatim family

CORE §10 gives verbatim one family in three geometries:

| Form | Syntax | Extent | Consequence for nesting |
|---|---|---|---|
| block | `!:label:` | **geometric** (dedent) | Contains any content, any backtick count, any depth. Only a dedent closes it. |
| fence | ` ``` ` | **delimited** (printed closer) | Any interior line whose sole content is ` ``` ` closes it. This is the leak. |
| inline | `!{:label: …}` | **delimited**, brace-counted | Backticks free; only brace balance matters. |
