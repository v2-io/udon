# DP2: what a bare run may be classified as

*Classification fork, spike a, 2026-10-22. Labels: **checked** (tested or read in a primary this session), **memory** (from my knowledge, not re-checked), **judgment**.*

## Why the question changes shape under Cc

Under kind-first designs (A, B, the old line), every bare spelling had to land in some kind, and every edge of every kind was a place the tree could surprise. That pressure grew the set and its edges: `30seconds` → `30s` + `econds`, `0s` a string while `00s` a duration, `$9.99` a float (the old line's own record, `.int/old-numeric-typing.md` §5).

Under Cc ([dp1](dp1-where-the-class-lives.md)) the run is a text whatever it spells, so the costs are lopsided:

- **Leaving a spelling out of the set costs little.** It stays a text; a slot type, a schema or a notation reads it.
- **Putting a spelling in wrongly costs more.** A data reading silently turns an identifier into a number.

So under Cc the set should be **the smallest one that serves a consumer with no schema** (C1). Everything else can be read by a slot.

## Four tests for membership (judgment)

- **T1 host-portable:** every plausible host has an obvious, near-lossless equivalent (the coordinator's hypothesis in the ideation notes).
- **T2 shape only:** membership is a small regular language, with nothing to check beyond shape (no ranges, no calendars, no zones).
- **T3 context-free meaning:** the spelling means the same thing in every slot.
- **T4 schema-less demand:** a consumer with no schema needs it to get ordinary data right.

| Class | T1 | T2 | T3 | T4 | |
|---|---|---|---|---|---|
| `nil`, `true`, `false` | ✓ | ✓ | ✓ | ✓ | in |
| integer, JSON spelling (`-12`, `0`, `8080`) | ✓ (2^53 caveat in JS) | ✓ | ✓ | ✓ | in |
| decimal, JSON spelling (`0.75`, `-3.5`) | ✓ (binary64, or exact) | ✓ | ✓ | ✓ | in |
| exponent (`1e10`, `6.02e23`) | ✓ | ✓ | ✓ | weak | judgment call, below |
| `+` sign, leading zeros (`+1`, `0755`) | ✓ | ✓ | ✗ `0755`: decimal or octal? | ✗ | out |
| underscores (`1_000_000`) | ✓ | ✓ | ✓ | ✗ JSON never produces them | out; a slot reads them |
| hex, octal, binary prefixes (`0xff`) | ✓ | ✓ | ✓ | ✗ | out; a slot or a notation reads them (K8) |
| quantity (`920px`, `5m`) | ✗ no host type | ✓ | ✗ `5m` is minutes or meters | ✗ | out; the slot owns the unit |
| rational, complex (`1/3r`, `3+4i`) | ✗ no JS equivalent | ✓ | ✓ | ✗ | out |
| temporal (`2026-10-22`, `10:12`, `60s`) | ✗ hosts disagree on zones, precision, calendars | ✗ ranges | mostly | ✗ | out of bare classification; see the `<…>` and slot forks |

The four tests pick out exactly **JSON's literal set: nil (for `null`), true, false, and JSON's number grammar** (RFC 8259 §6: `-? (0 | [1-9][0-9]*) (\.[0-9]+)? ([eE][+-]?[0-9]+)?`; memory, and the grammar `f1_check.py` uses). I'll call it **S-JSON**. It is the set C1 is defined against ("Structured data, as JSON and YAML are used").

## The candidate sets

| Set | Members | Strongest point | Weakest point |
|---|---|---|---|
| S-min | `nil`, `true`, `false` | no identifier can be misread | K1 fails: every number needs a slot or `<…>` |
| **S-JSON** | S-min + JSON numbers | lite → JSON copies every classified number token byte for byte (each is a valid JSON number token) | versions and ids that spell decimals (`1.10`, `1e10`) |
| S-JSON−e | S-JSON without exponents | `1e10` and SHA-like `12e4567` stay text | JSON → lite must write `1e10` some other way (`<1e10>`, or `10000000000`) |
| S-JSON+ | S-JSON + underscores between digits + `0x`/`0o`/`0b` | `1_000_000` and `0xff` read as numbers without a slot | more edge spellings to pin (`1__0`, `1_`, `0x`: the old line accepted all three as integers, §1 of the record); fails T4 |
| S-quantity | S-JSON + number followed by `[A-Za-z%]+` | `920px`, `30s` get a class | the class becomes "a number followed by letters": `10am`, `3rd`, `1st`, and `0xff` (as `0` + unit `xff`) all classify (**checked**, the battery in `f1_check.py`); no host type; meaning is the slot's anyway |
| S-old | the old line's set (bases, underscores, rationals, complex, temporal, durations) | domain-forward everywhere | the edge count; every edge a B3 liability; temporal is why it was partitioned. **Dies here**: under Cc nothing is gained by having the parser classify what a slot can read, and every class added is surface to pin, explain and keep identical across parsers |

## Scores (hypotheses; Cc assumed)

| Factor (weight) | S-min | **S-JSON** | S-JSON−e | S-JSON+ | S-quantity |
|---|---|---|---|---|---|
| A2 generative guessability (10) | 4 | 9 | 8 | 9 | 8 |
| A3 cold comprehension (10) | 7 | 8 | 8 | 8 | 6 |
| A5 domain-forward (9) | 4 | 8 | 8 | 9 | 9 |
| A6 spec clarity (9) | 9 | 8 | 8 | 6 | 5 |
| A7 syntactic simplicity (8) | 9 | 8 | 8 | 6 | 6 |
| B3 stability (10) | 9 | 9 | 9 | 7 | 6 |
| C1 structured data (10) | 3 | 10 | 8 | 10 | 9 |
| identifier safety (DP3; scored under A3 and B3, listed for sight) | high | medium | medium-high | medium | low |

**Confidence:** high that S-old and S-quantity cost more than they give *as parser classifications* (units are better read by a slot; see the slots fork). Medium on exponents: they serve JSON round-trips and science data, and misread id-like spellings; I lean to keep them (**judgment**), because the lite → JSON copy is byte-for-byte, so the loss only happens in a data reading that converts to binary64, which the host mapping guide can warn about.

## Naming the classes

Candidates: `integer` and `decimal`; one `number` with the host looking at the spelling; Joseph's sketch had `::numeric` with subkinds (`numeric.uint`, 2026-10-20). Lean (**judgment**): `integer` and `decimal`, because hosts need to keep integers integral (JSON's single number type is a known pain for exactly that), and "decimal" rather than "float" because the tree keeps the exact spelling and "float" names a storage type (H in the ideation table), which the coordinator's notes keep out of the document.

## The fixture edges S-JSON has to pin (all small)

`-0` integer; `0.0`, `-0.0` decimal; `1.` and `.5` text; `+1` text; `-` text; `01` text; `1e5`, `1E-5` decimal; `1e999` decimal (the mapping guide says what a host does when it overflows: keep the spelling); `NaN`, `Infinity`, `inf` text; `True`, `NIL`, `null` text (`null` with its warning).
