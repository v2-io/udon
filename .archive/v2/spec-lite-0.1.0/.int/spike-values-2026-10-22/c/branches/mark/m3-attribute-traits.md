# M3 — the slot's kind written on the attribute name

*Sub-branch of the mark family (decision point D3, "where is a type named?"). Alive in two spellings, `:when.date` and `:when<date>`. It combines with M1 or M2.*

## Why the slot side is worth a branch

From `../../00-frame.md`: a value's kind can come from the **slot** (known before the value), a **start mark** (known at its first character) or its **spelling** (known only at its end). Writing the kind on the attribute name is the only way to keep the value itself bare, in its domain's own spelling (`2026-01-10`, `5m`, `ssh`), *and* have the kind known before the value arrives. That is A5 (domain-forward, 9) and B5/B1 (kind-first, no holdback) at once. M1 and M2 put the kind on the value; M3 puts it on the name.

**An honest limit, found while pushing it:** on a single occurrence, `:when.date 2026-01-10` carries exactly the information `:when <date:2026-01-10>` does. It is a per-value annotation moved to the left. The slot spelling earns its keep only where **one declaration governs several values**:

- values on the lines under an attribute (the `rule:attribute-bodies` gap):
  ```udon
  |holidays
    :dates.date
      2026-01-01
      2026-07-04
      2026-12-25
  ```
- a list: `:tags.int [1 2 3]` (if a trait on a list-valued attribute applies to its items; to be decided);
- and, beyond lite, a schema that says `port` is `u16 | standard-port` once for every document of a kind. That is the real slot type, and M3 is its in-document spelling for when there's no schema.

So M3 is the right home for "what the slot is" where lite needs one in the document; it is not a better per-value mark.

## The rule (dot spelling), as it would be carded

1. An attribute name MAY be followed directly (no space) by one or more `.trait`s, as an element name may ([[def:trait]]). On an attribute they say **what kind of value the slot holds**. They change nothing about how the value is parsed: a bare run is still a «text», a mark still asserts what it asserts.
2. The tree holds them on the attribute occurrence beside its value (a new field; [[rule:nested-attributes]] is unaffected, since traits are not attributes).
3. Lite attaches no meaning to them. A reader above the tree uses them to pick a notation (M2's above-the-tree law applies unchanged).
4. Parameters are further traits, read by the notation: `:born.date.YY-MM-DD 27-03-05` (all valid labels under the labels lean, *checked*: letters, then `-` inner). Joseph's `:when:dt(YY-MM-DD)<27-03-05>` becomes `:when.dt.YY-MM-DD 27-03-05`. No new syntax.

`.` in an attribute name is an **error** under the labels lean (`.int/labels-ascii-and-positions-2026-10-20.md`: "error in an attribute name"; *checked*), so M3 is a widening, B2-safe, and lite 0.1.0 can keep it as an error that teaches until it's wanted.

## The other spelling: `:when<date>`

Same rule, spelled the way generic type parameters are (`List<int>`, `Vec<u8>`): `:port<u16> 8080`, `:dates<date>` above a body.

- **For it (instinct, A2/A3):** an agent trained on Rust, Java, C++ or TypeScript reads `:port<u16>` as "port, of type u16" with no teaching. The dot spelling's prior points the wrong way (below).
- **Against it:** `<` would mean "kind" in two places (on a value, a literal; on a name, a slot type), at most one space apart. A8 counts that as a second role for one character. And `:when <date> 2026-01-10` (stray space) differs from `:when<date> 2026-01-10` by one space. The near-miss is caught, though: under M1 or M2, `<date>` as a value is an error ("a notation name with no body: did you mean `:when<date> …`?").
- `<` directly after a bare label is an error today (labels lean: brackets "stay structural"), so this is a widening too.

## The hazard of the dot spelling

*Instinct, and field priors I'm confident of from memory but did not re-fetch:* TOML's dotted keys (`server.port = 8080` defines a nested table), Java/Spring properties (`server.port=8080`) and JSON-path habits all read `a.b` on a key as **nesting**. A writer with those priors who writes `|config :server.port 8080` means `{server: {port: 8080}}`; under M3-dot they silently get attribute `server`, slot kind `port`, text `8080`. Lite knows no notation names, so it can't warn. **This is a silent miss (A2, weighted heaviest), and the reason M3-dot scores 5 there.** M3-angle doesn't have it. Elements already accept the same reading risk with `|user.admin`, but there the trait's meaning ("what kind of thing") and the path reading ("user's admin") rarely give the same-looking intent.

## Composite set: rows that differ (M1 + M3-dot; M3-angle in comments)

```udon
|t :when.date 2026-01-10 :at.instant 2026-01-10T14:30Z :timeout.duration 30s   ; :when<date> …
  :span.duration P1Y2M
  :born.date.YY-MM-DD 27-03-05
|u :width.css 920px :timeout.duration 5m :length.length 5m :share.percent 50% :size.bytes 1.5GB
|p :port.port ssh
|p :port.port 22
|x :addr.i64 0x73DDF
|config :server.port 8080
```
````tree
root
  |t  :when{date} ‹2026-01-10›   :at{instant} ‹2026-01-10T14:30Z›   :timeout{duration} ‹30s›
      :span{duration} ‹P1Y2M›
      :born{date YY-MM-DD} ‹27-03-05›
  |u  :width{css} ‹920px›   :timeout{duration} ‹5m›   :length{length} ‹5m›   :share{percent} ‹50%›   :size{bytes} ‹1.5GB›
  |p  :port{port} ‹ssh›
  |p  :port{port} ‹22›
  |x  :addr{i64} ‹0x73DDF›
  |config  :server{port} ‹8080›      ← silent miss: meant {server: {port: 8080}}
````
*(`{…}` here shows the occurrence's slot traits; it isn't a proposed spelling.)*

| Item | Verdict |
|---|---|
| E6 | renders, values in the domain's own spelling, the parameterized date included (the one M2 couldn't do without a body convention). |
| E7 | renders; `5m` is told apart by the slot. |
| E8 | renders as the algebraic name intended: one slot kind `port`, two values in different arms. `:port.port` reads redundantly. With an external schema it disappears, which is M3's point: it is the fallback when there's no schema. |
| E9 | renders; `.i64` is storage plumbing on the name (A5 low, as in M2). |
| The dotted-key near-miss | silent under M3-dot; not expressible as a miss under M3-angle. |

## Scores and basis (hypotheses; M1+M3-dot in branch.md's table)

- **A5 8.** Values keep their domain spelling; a body governed by one trait has the least plumbing per domain fact of any branch here.
- **A1 8 (taste).** Traits meaning "what kind" on both elements and attributes is one concept, not two.
- **A2 5 / A3 6 (dot).** The dotted-key prior. For the angle spelling I'd put A2 7, A3 7, and A8 8 instead of 9.
- **C5 7.** It is the in-document slot type lite otherwise lacks; it doesn't do unions or aliases (`port = u16 | standard-port`), which stay a schema's.
- **B6 8.** It spends `.` (or `<`) after an attribute name, both errors today.

Confidence: low to medium. A panel on the dotted-key miss would settle the dot-vs-angle question quickly; it's the cheapest measurement in this family.
