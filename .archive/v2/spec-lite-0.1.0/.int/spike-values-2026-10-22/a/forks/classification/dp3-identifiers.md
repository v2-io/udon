# DP3: identifiers that spell numbers

*Classification fork, spike a, 2026-10-22.*

## The finding first

**No rule about spelling can tell a number from an identifier that looks like one. Only the slot can.** `1234567` is a count or a commit; `1.10` is a price or a version. What a design can do is (1) keep the spelling so nothing is lost, (2) keep the default readings from converting what is clearly not a number, and (3) leave the rest to the slot or to the writer's quotes.

## The guards, and what each catches

| Guard | Catches | Doesn't catch |
|---|---|---|
| G0 none (the old line: `0755` an integer) | nothing | everything |
| **G-JSON**: JSON's number grammar, so no leading zeros, no `+`, no `.5`, no `5.` | `01234` (zip), `007`, `0755` (a mode), `+15551234` | `1.10`, `1234567`, `1e10` |
| G-e: no exponents (S-JSON−e) | `1e10`, `12e4567` (would overflow to infinity in binary64) | `1.10`, `1234567` |
| **G-identity**: a value's identity is its spelling (Cc, [dp1](dp1-where-the-class-lives.md)) | the tree never loses anything; keys `[03]` and `[3]` stay distinct | a data reading still converts |
| G-copy: the host mapping guide copies a classified number into JSON as its original token | `1.10` reaches JSON as `1.10`, not `1.1` | a JSON reader that parses into binary64 |

## K2 under each design

`|part :zip 01234 :version 1.10 :commit 1234567 :id 1e10`

| | zip `01234` | version `1.10` | commit `1234567` | id `1e10` |
|---|---|---|---|---|
| C0 | text | text | text | text |
| Cc + S-JSON | text (no class) | text `#decimal` | text `#integer` | text `#decimal` |
| Cc + S-JSON−e | text | text `#decimal` | text `#integer` | text |
| B + S-JSON | text | decimal 1.10 | integer | decimal |
| old line | Integer "01234" → 1234 | Float → 1.1 | Integer | Float |

Under Cc, the *tree* is right in every column: the text is exactly what was written. A data reading of `version` gives 1.10 as an exact decimal, or 1.1 if the host maps decimals to binary64. That's the remaining hazard, and it is the same hazard YAML has: bare text is natural to write, so writers don't quote versions.

## What remains for the writer and the reader (honest)

- The writer who means "this is an identifier" writes `"1.10"`. That's JSON's and YAML's instinct, so A2 is served; but nothing forces it.
- A slot type (`version: string`, from a schema or a vocabulary) makes the data reading of `1.10` the text, with no help from the writer. This is where Joseph's domain-forward factor (A5) and slot types (C5) carry the load, and why the hazard doesn't need a lexical fix.
- A default-off lint could flag a decimal whose fraction ends in `0` (`1.10`, `2.0`), the shape versions take and measurements rarely need. *Taste; low confidence it earns its place.*

## Scores

DP3 is not a separate design. It is a property of the DP1 and DP2 choices, scored there under A3 and B3. G-JSON and G-identity cost nothing extra under Cc; G-e is the S-JSON−e judgment call.
