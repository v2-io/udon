# KDL v2 against UDON Lite, as of 2026-10-29

*For Joseph, from an Opus 5.5 agent asked for an honest, dispassionate comparison. I took lite to be the cards in `src/` and `def/`, with the values model replaced by `.int/spike-values-2026-10-22/typing-recommendation.md` wherever they disagree. I read every card's Statement and examples, all the objectives, `CTQ-FACTORS.md`, the proposal, and the trial's `RESULTS.md`. Of the rest of `.int/` I read only the lines that mention KDL. KDL is the v2.0.0 text (`draft-marchan-kdl2.md` in kdl-org/kdl, fetched today). Every KDL behavior I state below was run through ckdl 1.0 in v2 mode, except the ecosystem facts, which come from the kdl-org README. Lite has no parser, so the lite trees here are my reading of the cards.*

*One update applied after drafting (Joseph, via the coordinator): `<>` will not be reserved after all, so the proposal's rule 6 no longer holds. I read that as `<…>` being neither a value nor reserved, which makes it ordinary text. It touches only B6 below. If it means instead that `<…>` gets a meaning in lite, B6 goes back to where it was.*

---

## The short version

- **KDL is the better notation today for configuration and plain data, and it wins outright on everything that comes from being finished.** It has a 1,100-line spec with a complete grammar, a 338-case conformance suite, seventeen implementations listed as supporting v2, formatters, a language server and editor support. Lite has none of these yet, and its spec is still moving.
- **For lite's own purpose, prose and structure mixed and Markdown in prose, KDL isn't a contender.** Mixed content in KDL takes `-` nodes holding quoted fragments, and prose can only go in quoted strings. Lite's lead there is large and structural.
- **The comparison is useful because the two make opposite bets.** KDL marks *text* (anything with a space or a `/` is quoted) and keeps the bare space for numbers, keywords and annotations. Lite marks *structure* (`|`, `:`) and leaves text bare. Nearly every difference below follows from that choice, including most of the complexity in the typing proposal.
- **The uncomfortable finding:** on the factor group you weight highest, Beauty (A), lite's design doesn't currently beat KDL. It wins on domain-forwardness and readability, and loses on simplicity, parsimony and probably cold comprehension. The typing proposal adds to the loss: three spellings for a kind, a difference between element lines and attribute lines, and a list of notation names. Details are in §4 and §5.

---

## 1. The same content, both ways

### Config, KDL's home ground

```udon
|server[web] :host localhost :port 8080 :debug false
  :owner null
  |route :path /api :to backend
  |route :path /static :to files :cache 3600
```

```kdl
server web host=localhost port=8080 debug=#false {
    owner #null
    route path="/api" to=backend
    route path="/static" to=files cache=3600
}
```

They come out about even. KDL's line starts carry no sigils, and it reads like a command line. Lite has three real advantages here:

- `:owner null` on its own line is still an attribute of `server`. In KDL, `owner #null` on its own line is a child *node*, which is a different shape. The only way to continue properties onto a new line is a `\` continuation.
- Lite's paths are bare. In KDL they must be quoted, and leaving the quotes off isn't always a loud error (see §2).
- `#false`/`#null` are a KDL-only habit, and bare `true` is a syntax error in v2.

### Mixed content, lite's home ground

```udon
|section[setup]
  |h2 Setup
  Install the CLI, then run the check. See |{a :href /docs/cli \ the CLI guide}.

  ```sh
  make install
  make check
  ```
```

```kdl
section id=setup {
    h2 Setup
    p {
        - "Install the CLI, then run the check. See "
        a href="/docs/cli" "the CLI guide"
        - "."
    }
    code lang=sh #"""
        make install
        make check
        """#
}
```

Lite is clearly better here. KDL's mixed content (XML-in-KDL's convention, which the KDL project publishes) is legible, but it is plumbing, with the sentence's spaces kept inside quoted fragments. Lite's prose is the sentence itself, and its fence reads like Markdown. (One thing on the lite side is still open: whether `the CLI guide` becomes `$main` or the inline element's own text, which [[rule:inline-element-value-end]] leaves to the embeds discussion.)

### Values with kinds (the typing proposal against KDL's type annotations)

```udon
|samples
  |sample[s1] :mass(kg) 3.2 :temp(°C) 21.5 :taken datetime(2026-10-01T14:30Z)
  |sample[s2] :mass(kg) 2.9 :temp(°C) 22.0 :taken datetime(2026-10-01T15:10Z) :tags [repeat flagged]
```

```kdl
samples {
    sample s1 mass=(kg)3.2 temp=(°C)21.5 taken=(date-time)"2026-10-01T14:30Z"
    sample s2 mass=(kg)2.9 temp=(°C)22.0 taken=(date-time)"2026-10-01T15:10Z" {
        tags repeat flagged
    }
}
```

They're close. KDL has one mechanism: a parenthesized annotation in front of any value or node name. It's never checked, and the meaning is up to each application. The proposal's kind goes after the name for units, and its notation wraps the value for dates. The notation is checked, takes parameters (`:format`, `:pivot`) and nests. KDL needs quotes around the date (an unquoted `2026-10-01` is a syntax error). KDL has no list value, so `tags` becomes a child node.

---

## 2. Silent misses: what each one does with what an agent writes by reflex

A2's footnote weighs silent misses (the document parses, to a different tree) above errors. The KDL column was run through ckdl. The lite column is read from the cards and the proposal.

| Written by reflex | KDL v2 | Lite (cards + proposal) |
|---|---|---|
| `url=https://example.com` / `:url https://example.com` | **silent: `url` is `"https:"`**, because `//` starts a comment | the text `https://example.com` |
| `title War and Peace` / `\|title War and Peace` | **silent: three arguments**, `War`, `and`, `Peace` | one text |
| `msg "Hello," she said` / `\|p "Hello," she said` | **silent: three arguments** | one text, quotes included (proposal rule 2) |
| `zip=01234` / `:zip 01234` | **silent: the number 1234** | the text `01234` |
| `a=1 a=2` / `:a 1 :a 2` | **silent: `a` is 2**, and the 1 is gone | both kept, in order (stacking) |
| `version=1.10` / `:version 1.10` | silent: 1.1 | silent: 1.1 (the proposal names this cost) |
| `move 10 20` / `\|move 10 20` | two numbers | **silent: the text `10 20`** |
| `a href=/ Home` / `\|a :href / Home` | error (`/` must be quoted) | **silent: `href` is `/ Home`**, as [[rule:inline-element-value-end]] warns for the inline form |
| `cmd "ls \|grep x"` / `\|cmd ls \|grep x` | must be quoted | **silent: `grep` becomes a child element** |
| `el .gitignore is a file` / `\|p .gitignore is a file` | four arguments | **silent: the trait `gitignore`** (provisional rule) |
| a sameline child misaligned by one column | n/a, since braces decide nesting | **silent: a different parent** |
| `debug=true` / `:debug true` | error (v2 wants `#true`) | true |
| `mass=3.2kg` / `:mass 3.2kg` | error | text |
| `:href "https://…" Click here` (HTML habit) | the property, then `Click` and `here` as two arguments | text with quotes, plus the proposal's new warning |

What I take from it: each notation is safe on its own ground and silently wrong on the other's. KDL's worst misses come from writing text unquoted, which is the one habit lite exists to allow. Lite's worst misses come from data that looks like text, and from columns. KDL's URL miss and leading-zero miss are, to my eye, worse than anything in the lite column, because they corrupt values that look right. Lite's column-alignment miss is the one I'd worry about most for agents, because nothing about the line looks wrong.

---

## 3. Factor by factor

Scores are my judgment, 0–10, against `CTQ-FACTORS.md`. A2 and A3 are untested intuition. The trial measured lite readings, but nobody has run the same panel on KDL. "As it stands" counts maturity; "design" leaves out the factors that only maturity moves (A6, C5, D1–D3).

| | Factor (weight) | KDL | Lite | Why |
|---|---|---|---|---|
| A1 | Agent-subjective beauty (9) | 6 | 7 | For config, equal or slightly KDL. For anything with prose, lite by a lot. `\|{a :href / \ Home}` is lite's least beautiful common construct. |
| A2 | Generative guessability (10) | 5 | 6 | Lite matches the instinct to leave text bare and JSON literals. KDL's quoting, `#true` and URL rules have to be learned, and some of them miss silently. Lite's notations and columns have to be learned too. |
| A3 | Cold comprehension (10) | 8 | 6 | KDL reads cold almost entirely right: a name, arguments, `key=value`, braces. In lite, `$main` against the body, the framed `\`, sameline nesting and `.trait` after a space are not guessable. |
| A4 | Agentic readability (10) | 7 | 8 | Lite's line-start sigils and indentation show kind and depth with no brace counting, and prose reads as prose. |
| A5 | Domain-forward (9) | 6 | 8 | Lite shows the domain: unquoted text, prose, notations. KDL's plumbing is quotes, `#` keywords and XiK's `-` nodes. |
| A6 | Spec clarity (9) | 9 | 3 | KDL: one file and an authoritative grammar. Lite: about 9,500 lines of cards with provenance inline, ten gap rows, and value cards that contradict the proposal. |
| A7 | Syntactic simplicity (8) | 8 | 4 | KDL has few context rules. Lite has framing, the stand-alone rule, the left edge, sameline columns, `$main`, and the element/attribute asymmetry for `name(…)`. |
| A8 | Parsimony (8) | 7 | 4 | KDL: `/` does three comment jobs and `#` two. Lite: `\` has about six roles (string escape, attached escape, line-start, lone line, framed end, prose embed escape), `;` three, and `()`, backticks and `[]` two each. |
| A9 | Conciseness (6) | 6 | 8 | Data comes out even. Mixed content is far shorter in lite. |
| A10 | Self-description (5) | 6 | 6 | KDL can annotate anything. Lite's notations are checked. |
| A11 | Human readability (5) | 8 | 7 | |
| A12 | Human writability (2) | 7 | 6 | KDL is insensitive to indentation. |
| B1 | Bounded streaming (veto) | pass\* | pass | \*A KDL multi-line string is dedented by its *last* line, so its content can't be emitted until it closes. Lite's left edge is set by the first line, by design. |
| B2 | Reserve, don't ignore (veto) | pass | pass | KDL's v1→v2 guarantee ("parse either fails, or the data is identical") is lite's clause-2 aspiration, achieved. |
| B3 | Stability (10) | 8 | 7 | KDL: one tree per document, but annotation meaning varies by application, and last-wins drops data. Lite's design is strong (characters kept, notations checked) but unbuilt and still moving. |
| B4 | Errors that teach (8) | 4 | 8 | KDL's spec says nothing about messages (ckdl: "Parse error"). Lite makes "did you mean" a spec commitment. |
| B5 | Parse speed (9) | n/a | n/a | No lite parser. Both grammars look linear. |
| B6 | Headroom (7) | 7 | 5 | KDL keeps `[ ]` unused and `#` prefixes available. The proposal spends `(…)` twice, and backticks. With `<…>` no longer reserved it is text, and the proposal's rule 8 then bars a later UDON from ever giving it meaning, so another bracket pair is spent. (The gain: `<` is free in text values, which helps HTML.) |
| B7 | Size in bytes (3) | 6 | 8 | |
| C1 | Structured data (10) | 6 | 6 | KDL: clean literals, but no list value, unordered last-wins properties, and leading-zero numbers. Lite: lists can't span lines, the attribute-bodies card is still a gap, and string and text are two kinds. |
| C2 | XML/HTML (10) | 4 | 8 | |
| C3 | Markdown in prose (9) | 3 | 7 | KDL keeps Markdown byte-exact only as an opaque raw string. It can't interleave it with structure. |
| C4 | Types, notations, units (8) | 6 | 7 | |
| C5 | Schemas (8) | 5 | 1 | KDL Schema exists, but as 1.0.0 from 2021 (the KDL v1 era). Lite has nothing yet. |
| C6 | Extensibility (8) | 6 | 6 | |
| C7 | Predictable tree and API (8) | 7 | 5 | KDL's data model is small. Lite has string versus text, `$main` versus the body, stacking everywhere, and a tree notation not yet settled. |
| C8 | Other languages, exactly (8) | 7 | 9 | Lite's fences: a tag, dedent from the first line, `exact`. |
| C9 | Composition (7) | 2 | 2 | |
| C10 | Round-trip fidelity (7) | 5 | 8 | Lite keeps comments and characters by spec. KDL leaves that to format-preserving implementations. |
| D1 | Agent tooling (8) | 6 | 1 | |
| D2 | Language integration (7) | 8 | 0 | |
| D3 | Editor integration (5) | 7 | 2 | |

**Weighted averages** (arithmetic on my own scores, so they're no more reliable than the scores):

| | KDL | Lite |
|---|---|---|
| A, Beauty | 6.9 | 6.1 |
| B, Performance and robustness | 6.4 | 6.9 |
| C, Utility | 5.1 | 6.0 |
| **As it stands, all factors** | **6.2** | **5.7** |
| A, design only | 6.7 | 6.4 |
| C, design only | 5.1 | 6.5 |
| **Design only** | **6.0** | **6.5** |

---

## 4. Where KDL is simply better

1. **It exists.** A spec, a grammar that is authoritative over the prose, a test suite, v2 implementations in fourteen languages, formatters, a language server, a query language, real users (Zellij, Niri, Bikeshed, mise, among others). Every D factor and A6 belong to KDL, and nothing in lite's design changes that until lite ships.
2. **Rule count and character economy (A7, A8).** KDL's whole grammar is about 130 lines. Lite has about 95 rule cards, and the backslash alone has about six jobs.
3. **Cold reading of configuration (A3).** `route path="/api" to=backend` needs no explanation. Lite's `$main` and the framed `\` do.
4. **Structure doesn't depend on columns.** Re-indenting, pasting or dropping a level can't silently re-parent a KDL node; a brace mismatch fails loudly. Lite's sameline alignment (`|table |tr |td A1` and then a `|td` at exactly column 11) is the most fragile thing in it for an agent writing without highlighting.
5. **Several positional values.** `move 10 20` and `tags a b c` are natural. Lite needs `[…]` or `\` for that.
6. **Slashdash.** `/-` comments out a node, a property, an argument or a children block in place, across lines. Lite's `;` block covers a whole subtree, and the framed ` ; ` covers the rest of a line, but nothing removes one attribute in the middle of a line.
7. **One annotation mechanism.** `(x)` goes before any value or node name, and nothing else is involved. The proposal has three spellings of one idea (`:mass(kg)`, `qty(…)`, `|{qty …}`), plus backticks for verbatim.
8. **Proof of the forward-compatibility contract.** KDL v2 made every changed spelling a v2 error (bare `true`, `r"…"`), so no v1 document reads differently under v2. That is reserve-don't-ignore as practiced, and evidence that clause 2 can be held as a promise rather than an aspiration.

## 5. Where lite is better

1. **Prose and mixed content (C2, C3, A5).** This isn't close, and it's lite's reason to exist.
2. **Text without quotes.** Titles, paths and URLs are written as they are. That spares writers KDL's two worst silent misses (`//` in an unquoted URL, multi-word text splitting into arguments).
3. **Nothing is silently lost.** Repeated attributes stack, in order. KDL keeps only the rightmost property and doesn't promise property order: the same duplicate-key corruption lite's data objective names in YAML.
4. **`01234` stays text.** KDL makes it 1234.
5. **`true`, `false`, `null` as JSON writes them.** That's more guessable than `#true`, and lite's set has no Norway problem.
6. **Fences.** A language tag, dedent from the first line (streamable), `exact`, and Markdown familiarity, against KDL's `#"""…"""#` dedented by the last line.
7. **Round-trip and errors as spec commitments (C10, B4).** Comments are in the tree, characters are kept, and every error and warning suggests a fix. In KDL each of these is an implementation's choice.
8. **Attribute lines under the element line.** This is the "crucial real-world use" of [[rule:line-scan]]. KDL can only do it with `\` continuations.
9. **Lists as values,** where KDL has none. (Multi-line lists remain a lite gap.)

---

## 6. On the typing proposal specifically

KDL is the nearest living relative of what the proposal is trying to do, so it is a good control.

- **The proposal's complexity is the bill for unquoted text.** KDL can put a bare `(` in front of any value, keep bare words for identifiers, and mark keywords with `#`, because it never has to tell text from syntax: text is quoted. The spike killed KDL-style `(dt)value` for lite for exactly that reason (`.int/spike-values-2026-10-22/a/forks/angle/other-branches.md`: "`(` at a value's start is text today"). The same pressure is behind the proposal's restrictions:
  - `name(…)` only in attribute values, never in `$main`;
  - the stand-alone rule for quotes, decided one character after the closing quote;
  - the warning for a space before `(kg)`;
  - the warning for a URL containing a space.

  Each is reasonable, and each exists only because lite's values are bare text. I don't think that's a reason to change course: bare text is what lite is for. It does mean the proposal can't reach KDL's simplicity by refinement. The gap is the price, and it should be weighed as one.
- **The proposal and KDL agree** on bare numbers including `0x`/`0o`/`0b` and `_`, on `null` as the spelling, on raw text with no escapes, and on putting the kind in parentheses. KDL v2 also had to decide what bare `true` means once bare words are strings. It chose an error plus `#true`; the proposal chooses JSON's reading. For agents I think the proposal is right: the trial's fresh agents all wrote `null` and `true` untaught.
- **The proposal is ahead of KDL on two points:**
  - it *checks* known notations (`date(2026-13-45)` is an error). KDL annotations are suggestions any application may read differently, which weakens stability (B3) across tools;
  - "a leading zero is never a number" closes a hole KDL left open.
- **KDL is ahead on uniformity.** One position for the kind (before the value), legal on node names too, with no difference between line kinds. The proposal's rule 3, `name(…)` recognized in attributes but not in `$main`, is the first place lite reads an element line and an attribute line differently. That cuts against [[rule:line-scan]], which you called "the final word". A KDL user would never meet that rule, and I'd count it as a real cost in the decision, not a footnote.
- **KDL's reserved annotation list** (`date-time`, `date`, `time`, `duration`, `decimal`, `uuid`, `url`, `regex`, `base64`, the integer widths…) is a reasonable checklist for which notation names lite might eventually know. KDL has already named things; that doesn't make its names right for lite.

## 7. Things lite might take from KDL

My suggestions, for whatever they're worth:

- **The conformance-suite shape.** Input file → expected canonical output, about 340 cases, with failure cases. That is what A6, B3 and the tree-transcript card are reaching for, and KDL shows the size at which it was enough.
- **A grammar that outranks the prose.** KDL's spec says its grammar "should be considered authoritative if something seems to disagree with the text above". Lite's cards are the authority now, which suits drafting; at release, a single grammar that wins conflicts would raise A6 and A7 more than any card edit.
- **A slashdash equivalent**, if one can be found that fits lite's character budget. Agents editing files comment things out constantly.
- **Promoting the reserve-don't-ignore aspiration to a promise.** KDL shows it can be held across a major version.

## 8. What I'm unsure of

- A2 and A3 are my intuition. The method in the CTQ footnotes would settle them cheaply: a fresh panel writes held-out trees in KDL and in lite, at the same exposure. Lite's readability argument rests on agents *without highlighting*, and I don't know which way that panel would come out. I'd bet lite reads better and KDL is written with fewer silent misses, but it's a bet.
- My lite trees come from reading the cards, not from running a parser. Where a card is provisional (traits after a space, the placement of embeds' left-over text), I've said so.
- I scored lite's design with the proposal adopted whole. If it isn't adopted, A7 and A8 improve a little, and C1, C4 and A2 get worse.
- The KDL ecosystem facts come from the kdl-org README as of today. I didn't check implementation quality or speed.

*I'm available for follow-ups.*
