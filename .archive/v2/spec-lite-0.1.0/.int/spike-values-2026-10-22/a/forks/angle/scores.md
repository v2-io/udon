# Scores for the `<…>` branches

*Fork `angle` of spike a. Every number is my hypothesis (0–10), nothing measured; Joseph asked for exactly that. Only factors that tell the branches apart are scored; the others (B1, B2 pass for all, given the refinement reading below; B5, B7, C3, C8–C10, D) are equal or untouched. The weights are CTQ-FACTORS'. `scores.py` here recomputes the totals.*

## Vetoes

- **B1 bounded streaming:** all pass. `<` commits at its first character; the interior's role commits at its first character (a number, a string, nil) or at the end of a label (a notation), which I count as token-bounded, like every label in lite.
- **B2 reserve-don't-ignore:** ANG-3 passes on any reading. ANG-1, ANG-2, ANG-4o and ANG-4c pass only if carrying an unread body as raw counts as not giving it a meaning, the way fences already carry any named body ([[rule:fence-default-handler]]). If raw ever means "string", they fail.

## Table

| Factor (weight) | ANG-1 raw | ANG-2 std/raw | ANG-3 closed | ANG-4o fence/open | **ANG-4c fence/closed** | ANG-5 embed |
|---|---|---|---|---|---|---|
| A1 agent-subjective (9) | 5 | 5 | 6 | 7 | **8** | 4 |
| A2 generative guessability (10) | 5 | 6 | 6 | 6 | **7** | 5 |
| A3 cold comprehension (10) | 5 | 6 | 7 | 6 | **7** | 6 |
| A4 agentic readability (10) | 7 | 7 | 8 | 7 | **8** | 5 |
| A5 domain-forward (9) | 6 | 6 | 5 | 7 | **7** | 4 |
| A6 spec clarity (9) | 8 | 5 | 7 | 7 | **7** | 5 |
| A7 syntactic simplicity (8) | 9 | 5 | 7 | 6 | **6** | 7 |
| A8 parsimony (8) | 7 | 7 | 7 | 6 | **6** | 9 |
| A9 conciseness (6) | 7 | 7 | 7 | 6 | **6** | 4 |
| A10 self-description (5) | 5 | 4 | 3 | 8 | **8** | 7 |
| A11 human readability (5) | 6 | 6 | 6 | 7 | **7** | 4 |
| B3 stability (10) | 8 | 6 | 9 | 7 | **9** | 6 |
| B4 errors that teach (8) | 4 | 4 | 8 | 5 | **9** | 5 |
| B6 headroom (7) | 9 | 6 | 8 | 5 | **7** | 10 |
| C1 structured data (10), bare is text / bare classified | 2 / 8 | 8 / 8 | 8 / 8 | 8 / 8 | **8 / 8** | 2 / 8 |
| C2 XML/HTML (10) | 5 | 5 | 7 | 5 | **7** | 8 |
| C4 types, notations, units (8) | 5 | 5 | 3 | 9 | **9** | 7 |
| C5 schemas and slot types (8) | 5 | 5 | 5 | 7 | **7** | 5 |
| C6 extensibility (8) | 6 | 5 | 3 | 9 | **9** | 7 |
| C7 predictable tree and API (8) | 6 | 5 | 8 | 7 | **8** | 5 |
| **Weighted total, bare is text** | 987 | 946 | 1083 | 1117 | **1250** | 946 |
| **Weighted total, bare classified** | 1047 | 946 | 1083 | 1117 | **1250** | 1006 |

The maximum over these factors is 1660. Because the factors overlap on purpose, the totals double-count; read them as an ordering with a wide margin of error, not a measurement.

## Basis, for the scores that decide the order

- **B4, A2 (ANG-4c 9/7 vs ANG-4o 5/6):** in a closed unlabeled form, the common things agents put in angle brackets each become an error with a suggestion, not a quiet value. *Instinct* about my own priors (HTML, placeholders, autolinks, operators); confidence medium.
- **B3 (ANG-2 at 6):** a whole-interior match against the number grammar puts every edge spelling on a number-or-raw boundary that each parser must draw identically. The old line's parsers disagreed with their own specs exactly at such edges (`.int/old-numeric-typing.md` §3). I weigh that as evidence of how hard the edges are, not as a reason. Confidence medium.
- **C4, C6, A10 (ANG-4 at 9/9/8):** only the labeled branches can name a notation, give it parameters (`[DD-MM-YY]`) or a kind (`.iso8601`), and share a handler concept with fences. Confidence high that they are higher; the exact numbers are soft.
- **A6, A7 (ANG-1 highest):** one sentence beats one table. ANG-4c's table is offset by reusing the fence's handler idea; I score them level on A6 and ANG-1 higher on A7. Confidence medium.
- **B6 (ANG-5 10, ANG-1 9, ANG-4c 7):** ANG-4c spends `: `-headed labels inside `<…>` and the unlabeled standard set; it leaves every unlabeled non-standard interior an error, which a later UDON can widen.
- **A1 (taste):** one idea at two sizes (fence for blocks, `<name: …>` for values) is what I find most beautiful here. A judge with another sense of beauty could reasonably flip ANG-1 and ANG-4c on this line alone.

## Confidence overall

ANG-4c over ANG-4o: medium-high. The difference is the closed unlabeled cell, and it rests on B4 and A2, which I'm fairly sure of. ANG-4 over ANG-1/2: high under bare-is-text, medium under bare-classified. ANG-3 vs ANG-4c turns on Joseph's answer to "is a refinement a change?", not on scores.
