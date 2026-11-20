# Branch page: notation values, designed (D4 revisited; J2 notations, J3 composites, J4 quote)

> **Read with page 60.** This is the cold pass: designs scored as they appeared. Page 60, written after Joseph's note on creativity, invents first and judges after. Its system (LW: attribute traits `:mass.kg 3.2`, a `$sig` key signature, backtick raw values, and NA reshaped as the hinged `<kind: items>`) outscores everything here, and it is the recommendation. NA's registry, its four reading layers and its before/after tree carry over into it.

*Spike b, second round, 2026-10-22, after Joseph's response: "These spikes were for designing meaning. A conclusion of "now if it's well designed, but a 'no' until it gets designed" is our premise when we started restated to ourselves." Page 40's "labels reserved in lite 0.1" is withdrawn and replaced by this page. Labels: [checked], [ran], [inferred], [taste], [hyp].*

*Tree notation on this page (illustrative): `‹…›` a text, `"…"` a string, `[…]` a list. A notation value is printed `literal date [‹2026-10-01›]`: the word `literal`, its notation's name, then its items. `⇒` gives what a reader attaches.*

## 1. What any design must carry

From Joseph's distinctions (`types-ideation-2026-10-22.md`), a value written with a named notation has five parts. The design question is where each one lives:

| Part | In `<datetime 2026-10-01T14:30-06:00[America/Denver]>` | Lives in |
|---|---|---|
| R, the spelling | `2026-10-01T14:30-06:00[America/Denver]` | the tree (always kept) |
| N, the notation | `datetime` (RFC 3339 plus RFC 9557's zone suffix) | the tree (the name) + a registry (what the name means) |
| T, the represented type | an instant with a named zone | the registry's entry for N |
| S, the slot | whatever `:start` accepts | a vocabulary (page 20) |
| C, the canonical spelling | as written, or the registry's canonical form | the registry, used by writers |
| H, the host type | `Temporal.ZonedDateTime`, `chrono::DateTime<Tz>` | each host's mapping guide |

**The constraint that matters most (from fork R §4, EDN):** the *items* of a notation value must be readable by lite's own rules, without the notation. Then a parser that has never heard of `datetime` still produces the complete tree, and a later UDON that defines more notations adds **readings, never different trees**. That makes reserve-don't-ignore (B2) hold without refusing what lite doesn't understand, and it is the reason "reserve for now" was never forced. [inferred; I think this is the key that unlocks the design]

## 2. The designs

All five are rendered on the same content: a date, a zoned datetime, a duration, a unit quantity, an exact decimal, a rational with a complex numerator, a user notation, and a reference kept as a reference.

### NA: the angle literal is a named list (`<name item …>`) — recommended

```udon
|event :on <date 2026-10-01> :start <datetime 2026-10-01T14:30-06:00[America/Denver]>
|event :lasts <duration 3mo 5d> :every <duration P1W>
|part :mass <qty 3.2 kg> :price <decimal 83.23> :sku <acme/sku AB-12 rev3>
|math :z <rational <complex 3 -7> 2>
|link :to <ref people/jw> :also @{people/jw}
|cfg :mask <0xFF> :owner <> :port <8080>
```
````tree
root
  |event
    :on literal date [‹2026-10-01›]                        ⇒ Date 2026-10-01 (day precision)
    :start literal datetime [‹2026-10-01T14:30-06:00[America/Denver]›]
                                                            ⇒ ZonedDateTime, offset −06:00, zone America/Denver
  |event
    :lasts literal duration [‹3mo› ‹5d›]                    ⇒ Duration 3 months 5 days
    :every literal duration [‹P1W›]                         ⇒ Duration 1 week
  |part
    :mass literal qty [‹3.2› ‹kg›]                          ⇒ Quantity 3.2 kilogram
    :price literal decimal [‹83.23›]                        ⇒ Decimal 83.23 (exact)
    :sku literal acme/sku [‹AB-12› ‹rev3›]                  ⇒ unresolved acme/sku (no reader knows it); the tree is complete
  |math
    :z literal rational [literal complex [‹3› ‹-7›] ‹2›]    ⇒ Rational(Complex(3, −7), 2)
  |link
    :to literal ref [‹people/jw›]                           ⇒ a reference value, not resolved
    :also ‹@{people/jw}›                                    (the referent's place; resolution as today)
  |cfg
    :mask 0xFF                                              (the primitives, unchanged from page 10)
    :owner nil
    :port 8080
````

**The rules:**

1. **`<` commits** at the first character (B1). After it:
   - `>` gives nil;
   - a digit, sign or `.` gives the rich number set, checked, with an error on mismatch;
   - `"` or `'` gives a string;
   - a letter gives a word, which ends at `>`, a space or `/`.
     - A word ending at `>` must be `nil`, `true` or `false`.
     - A word followed by a space or `/` is a **notation name**.

   The word's length is the name's length: nothing beyond the token is held, as with any label.
2. **The items** after the name are read exactly as a list's items ([[rule:list-items-whitespace-separated]]): whitespace-separated values that may be bare runs, strings, lists or nested notation values. At least one item is required, so `<kbd>` and `<now>` are errors. Lite evaluates nothing.
3. **The items get no default reading** (page 10's β3). The notation is their slot, and only it reads them.
4. **Names.**
   - An **unprefixed** name belongs to UDON's registry. An unprefixed name that isn't in the registry is an **error** that suggests the nearest registered name ("`<dtae …>`: did you mean `<date …>`?"). This is B2 for names: no user can have used `<colour …>` with a meaning of their own before UDON defines `colour`.
   - A **namespaced** name (`acme/sku`, `acme/geo/point`) is carried whole, whether or not any reader knows it.
   - `/` is the separator: [checked] EDN uses it, and Joseph's own `<namespaced/type: val>` (2026-07-21) did too. It doesn't collide with a payload's `:` (times) or with `xml:lang` in labels.
5. **No aliases inside documents.** Joseph's "`<timespan …>` as long as there is no ambiguity" is handled by keeping the registry's names short, rather than by resolving short names against whatever happens to be loaded. Resolution that depends on what else is loaded would let one document mean two things (B3). User notations are always written with their prefix.
6. **It must stand alone** (page 30, δ3). `|p Due <date 2026-10-01> sharp.` is plain text, because `<` is not recognized in prose and a run that starts with `D` isn't a literal. A typed value inside text is an element carrying a literal, which is HTML's `<time datetime=…>` pattern:

```udon
|p Due |{time Oct 1 :datetime <date 2026-10-01>} at noon.
```
````tree
root
  |p
    :$main ‹Due |{time …} at noon.›   (one text; its embed is the element:)
      |time
        :$main ‹Oct 1›
        :datetime literal date [‹2026-10-01›]   ⇒ Date 2026-10-01
````
   *(The `$main` text comes first so that it ends at ` :datetime`, and the literal stands alone before the `}`.)*
7. **The ornament.** `<date: 2026-10-01>` is allowed if, and only if, Joseph adopts the trailing `:` on attribute names: one decision, applied to both kinds of name. [taste: it reads well to me, and it's his `<dt: …>`]

### How a reader attaches meaning, in four layers (common to every design here)

| Layer | Reads | From | Example |
|---|---|---|---|
| 1. the default reading (page 10) | bare runs, in slots with no type | JSON's grammar, frozen | `:port 8080` ⇒ 8080 |
| 2. the notation registry | notation values | UDON's registry (unprefixed) and vocabularies (prefixed) | `<date 2026-10-01>` ⇒ Date |
| 3. the vocabulary | bare runs in typed slots; checks every value against its slot | lite documents, bound by convention | `:when 2026-10-01` with `when: date` ⇒ Date |
| 4. getters | whatever the consumer asks for | the consumer's own code | `get_date(:when)` |

Precedence: an asserted literal decides its own type (T), and the slot only **checks** it. `<datetime …>` in a slot typed `date` is an error at reading, unless the vocabulary declares a coercion. A bare run is **read by** the slot. That is the Lisp-quote alignment from page 00, carried through: delimited means the literal decides, bare means the slot decides.

**Before and after.** The tree holds the name, the items as lite values, and their spellings. It never changes. A reader with the registry produces typed values. A reader without it gets `unresolved(name, items)`, which it can carry, display or write back exactly, as EDN does with unknown tags [checked, fork R §4].

### UDON's registry for lite 0.1 (a proposal; each entry is a design, not a placeholder)

Admission test, adapted from page 10's lossless test: **an external standard fixes spelling → value exactly, and the spelling can be written back.**

| Name | Items | Spelling standard | Notes |
|---|---|---|---|
| `date` | one: `YYYY`, `YYYY-MM` or `YYYY-MM-DD` | ISO 8601 extended, 4-digit year | precision is part of the value; `<date 2026-1-3>` is an error ("did you mean 2026-01-03?") |
| `time` | one: `HH:MM[:SS[.frac]]` | ISO 8601 / RFC 3339 partial-time | no offset on a bare time; `24:00` an error |
| `datetime` | one: RFC 3339 date-time, optionally with RFC 9557's `[Zone]` suffix | RFC 3339, RFC 9557 [checked: RFC 9557, 2024, "Timestamps with Additional Information"; example `1996-12-19T16:39:57-08:00[America/Los_Angeles]`] | a missing offset is allowed and means local (floating) time; `T` and `Z` uppercase only, so a lowercase form is an error that teaches |
| `duration` | ISO 8601 `P…` as one item, **or** one or more `number unit` items from the closed set `y mo w d h min s ms` | ISO 8601; the shorthand closed by the spaces between items | `<duration 1d 12h>` replaces the old `1d12h` split; `m` alone is an error ("`mo` or `min`?") |
| `decimal` | one: a decimal spelling | exact base-10 | answers the old open question about `0d83.23` (`old-numeric-typing.md` §5 item 6): an exact decimal is a notation, not a prefix |
| `ref` | one: an address | the address theory | a reference **as a value**: Lisp's quote (fork P's J4), where `@{…}` stands for the referent. Replaces the `@{<…>}` idea that Joseph called "a little unprincipled" |

**Considered for the registry, and why they wait on a standard rather than on a design** (each is designed here; only the admission test holds them back):

- `rational` (`<rational 1 3>`) and `complex` (`<complex 3 -7>`). The spellings are designed above and nest. They pass "spelling → value exactly", but fail the host-equivalent half of page 10's test (JS has neither). My lean: **admit them anyway**, because an *asserted* value, unlike a guessed one, can carry a host-mapping note without surprising anyone. [taste]
- `qty` (`<qty 3.2 kg>`). It needs a unit vocabulary. UCUM is the real standard [recalled; not re-checked], but its codes are not what writers write for inches or CSS pixels. Design: `qty`'s second item is a UCUM code. Other unit systems are namespaced (`<css/length 920px>`), and typed slots read bare `920px` by their own notation (page 20 §4).
- `base64`, `uuid`: obvious, standard (RFC 4648, RFC 9562 [recalled]), and nothing in the composite set needs them.

**Two-digit years and format parameters** (Joseph's `:when:dt(YY-MM-DD)<27-03-05>`):

- On a **literal**, the canonical ISO spelling is required, because an asserted value must stand on its own. A two-digit year with no stated century changes meaning with the clock, as REBOL's do [checked, fork R §5], which fails B3.
- A format is a **slot** property, declared once in the vocabulary (`when: date :format YY-MM-DD :pivot 1950`), so bare `:when 27-03-05` reads as 2027-03-05 in that slot.
- That is the "this is what the slot is vs this is what my literal represents" split, applied: format parameters describe how a *slot* reads spellings.

### NB: notation values are elements (`|{date 2026-10-01}`)

A named value is an element, with its name bound by a vocabulary or registry. Traits name notation variants (`|{date.us 10/01/2026}`). Attributes carry parameters and named components (`|{rational :num |{complex 3 -7} :den 2}`). Standing alone in a value slot, `|{…}` is the element itself; in text it is an embed, so **typed values in prose come free**: `|p Due |{date 2026-10-01} at noon.`

```udon
|event :on |{date 2026-10-01} :lasts |{duration 3mo 5d}
|math :z |{rational :num |{complex 3 -7} :den 2}
```
````tree
root
  |event
    :on |date
      :$main ‹2026-10-01›                   ⇒ Date (if a reader binds `date`)
    :lasts |duration
      :$main ‹3mo 5d›
  |math
    :z |rational
      :num |complex
        :$main ‹3 -7›
      :den ‹2›                              (no default reading here: the notation reads it)
````

- **For:** no new construct at all (A8, A7); a fully parsed tree with nothing to reserve (B2); HTML's `<time>` and `<data>` resonance (C2); the mapping is beautiful: element name = represented type, trait = notation, attributes = parameters, `$main` = spelling. [taste]
- **Against:**
  - A typo is silent: `|{dtae 2026-10-01}` is just an element named `dtae`. Nothing can be an error, because elements are free (B4).
  - A consumer can't tell "this element is data" from "this element is document structure" without a vocabulary (C7).
  - It flips [[rule:embeds-in-text]], a steward decision ("always … a distinct chunk of distinct text … for right now"), in value position.
  - A line-final element value swallows the rest of its line (`|el :x |em hi :y 2` gives `:y` to `|em`; [checked] [[rule:element-after-attribute-with-no-value]]), so the brace form is needed everywhere except at the end of a line.
- **Its one unique strength, typed values in prose, NA gets too:** an element carrying a literal (rule 6 above), at the cost of the element's name. That dissolves the main argument for NB. [inferred]

### NC: attached tag (`date"2026-10-01"`, `rational[complex[3 -7] 2]`)

Fork P's strongest branch for guessability. Under δ3, NC and NA carry the same structure (a name plus list-like items). NC needs a bound on tag length to decide where the value ends (B1, fork P §2 P8). Its list form looks like an element head with a key (`|rational[…]`). **Dominated by NA** on B1 and A3, at equal information. It keeps a real edge only in A2, for agents that know Python and SQL string prefixes. [inferred]

### NA+E: NA plus unlabelled ISO temporal inside `<…>` (`<2026-10-01>`)

The 0.9-era form, now checked strictly. It is concise and guessable. But it gives a date two spellings (`<2026-10-01>`, `<date 2026-10-01>`), puts the temporal grammar into `<`'s first-character dispatch (a digit then forks between number and date at the `-`, a bounded decision), and costs A6 and A7. Under NA alone, `<2026-10-01>` is an error that teaches ("did you mean `<date 2026-10-01>`?"), so the guessability loss is caught, not silent. **Not adopted**, on one-spelling-per-notation grounds. Close, and Joseph's taste could reasonably flip it. [taste]

### ND: no literal notations; slot types only

Bare `:on 2026-10-01`, typed by the vocabulary. This is always available under every design here (layer 3), so it is a component, not a rival. As a *replacement* for literal notations it fails generic and heterogeneous slots: a metadata bag, a JSON-like list of mixed values, a document with no schema that wants to say "date". C4 is weight 8. **Kept as layer 3, not as the answer.**

## 3. Scores [hyp, computed by script]

| Factor (weight) | NA | NA+E | NB | NC | ND |
|---|---|---|---|---|---|
| A1 beauty (9) | 8 | 8 | 7 | 7 | 7 |
| A2 guessability (10) | 6 | 8 | 6 | 8 | 7 |
| A3 cold comprehension (10) | 6 | 7 | 8 | 7 | 5 |
| A4 readability (10) | 8 | 8 | 7 | 7 | 8 |
| A5 domain-forward (9) | 7 | 8 | 7 | 7 | 9 |
| A6 spec clarity (9) | 7 | 6 | 8 | 6 | 9 |
| A7 simplicity (8) | 6 | 5 | 8 | 6 | 9 |
| A8 parsimony (8) | 7 | 7 | 9 | 7 | 10 |
| A9 conciseness (6) | 7 | 8 | 6 | 7 | 9 |
| A10 self-description (5) | 8 | 8 | 8 | 8 | 3 |
| B3 stability (10) | 8 | 7 | 8 | 7 | 8 |
| B4 errors that teach (8) | 8 | 8 | 5 | 7 | 6 |
| B6 headroom (7) | 7 | 6 | 8 | 6 | 10 |
| C2 XML/HTML (10) | 7 | 7 | 9 | 7 | 8 |
| C3 Markdown (9) | 8 | 8 | 8 | 7 | 9 |
| C4 types, notations, units (8) | 9 | 9 | 8 | 8 | 4 |
| C6 extensibility (8) | 8 | 8 | 8 | 7 | 6 |
| C7 tree and API (8) | 8 | 8 | 6 | 8 | 6 |
| **weighted (max 1520)** | **1119** | **1130** | **1134** | **1071** | **1133** |

**The totals don't decide this.** Four designs land within 15 points of each other, well inside my error. What decides it is the handful of differences that carry weight, judged one at a time:

1. **Typos and unknown names** (B4): NA errors on them and NB can't. Weighed heavily, because a silent typo in a notation name is a silent different meaning, the kind of miss the CTQ weighs most.
2. **Typed values in prose** (C2): this looked like NB's alone. NA gets it through an element carrying a literal.
3. **Generic slots** (C4): ND can't serve them.
4. **One construct or two** (A7, A8): NB's real advantage, against NA's "angle asserts a value". I think "angle asserts" is the conceptual unity worth having: `<>`, `<0xFF>` and `<date …>` all say the writer is asserting a value. [taste]
5. **NA's real cost** (A3): `<date 2026-10-01>` reads, cold, like an HTML open tag. Mitigated by δ3, since it only means a literal when it stands alone as a value, and by the error on unknown unprefixed names.

**Recommended for lite 0.1: NA, with its six-name registry.** Confidence moderate: the margin is a judgment about items 1 and 4, not a total. NB is the honest runner-up; if Joseph weighs "one construct" above typo errors, NB wins, and its trees are above.

## 4. The other places that had landed on "later"

- **Composites (J3):** designed. In NA, items nest (`<rational <complex 3 -7> 2>`). Positional items are the default. Named components, if a notation wants them, are a notation's own item convention, not new syntax.
- **Quote, reference kept as reference (J4):** designed as the `ref` notation. `@{…}` stays the referent's place.
- **Keys (`|step[1]`):** designed. A key gets **no** default reading. A key is an identity, compared by spelling, so `[1]` and `[01]` are different keys, and `[1]` is the text `1`. A typed key is written as a literal (`|step[<1>]`) if anyone ever wants one. [inferred, from the key's purpose: [[def:key]] "says which one this element is"]
- **The trailing `:`:** still Joseph's taste. It is now coupled to the notation-name ornament (`<date: …>`), so it is one decision rather than two.
