# A notation for lite trees: proposal B

*Written 2026-10-09 by a general-purpose agent (Opus 5.5) at the udon-team coordinator's request, as one of two independent proposals; I have not read proposal A. Every single-tree transcript below, including the fixture `tree:` blocks, was printed by a throwaway prototype printer (Python, about 150 lines, in this session's scratchpad) from a tree I built by hand, so the canonical rules in §4 are known to be mechanical at least for these inputs. The side-by-side layouts in §6.3, §6.6 and §6.7 are arranged by hand from such output. What the printer can't check is whether I built each *tree* right from its UDON. That is my reading of the records, flagged where they are open. Where a tree depends on a question the records leave open, I say which, and print the reading the records lean toward.*

## 1. The proposal in one paragraph

Use **one notation everywhere**: an indented, line-per-item "transcript" of the tree, visibly unlike UDON, with a few Unicode marks. It has a **canonical printing**: one spelling per tree, defined by about ten rules. Fixtures store the canonical printing. A harness never parses the notation. Each lite parser ships a small *printer* (tree → transcript), and the harness byte-compares its output with the fixture and shows a line diff when they differ. Chat and the spec use the same notation with three liberties that fixtures don't take: remarks (`← …`, `⚠ …`), elision (`…`), and column alignment. One reference tool, written once in any language, parses the notation back, so it can check that hand-written expected trees are canonical.

Joseph's note ("indentation and unicode … over 'json s-expressions' or something verbose and jarring") matches where this landed independently: the readable form *is* the machine form. The machine-checkability comes from a canonical printer, not from a parse-friendly syntax.

## 2. The brief's example, first

```udon
|nav.main[top] :aria-label Site |{a :href / Home} |{a :href /about About}
  ; a note
  |p See |{a :href /docs the docs} and @{faq}.
    Second line ;{todo} here.
  :late 1
  ```sh
  make build
  ```
|cfg :port 8080 :ratio 0.5 :on true :tags [a "b c" 3] :when <2026-07-11> :x 1 :x 2
```

```text
nav
  $traits = t"main"
  $key = t"top"
  aria-label = t"Site " · {a href=t"/ Home"} · " " · {a href=t"/about About"}
  late = 1
  ; "a note"
  p
    $main = t"See " · {a href=t"/docs the docs"} · " and " · @{faq} · "."
    t"Second line " · ;{todo} · " here."
  ≡ sh
    "make build\n"
cfg
  port = 8080
  ratio = 0.5
  on = true
  tags = [t"a" "b c" 3]
  when = <2026-07-11>
  x = 1
  x = 2
```

`⚠ warning late-attribute 5:3`

How to read it:

- **No root line.** The root is implied in the source, so it is implied in the transcript too. Column 0 of the transcript is the inside of the root, just as column 0 of the source is.
- **An element is its bare name on a line.** Its attributes follow at +2 as `label = value`, in written order. Its children come after them, also at +2.
- **`t"…"` is text, `"…"` is a quoted string.** Text is `t` followed by its pieces, joined by ` · `. A piece is a run `"…"`, an inline element `{…}`, a reference `@{…}`, or an inline comment `;{…}`. So `tags = [t"a" "b c" 3]` shows at a glance that the author quoted one item and not the other.
- **`;` is a comment node, `≡` a fence.** A fence's body is shown one source line per transcript line.
- **Typed values, references and inline comments use lite's own spelling**, re-escaped by lite's span rule: `<2026-07-11>`, `@{faq}`, `;{todo}`.
- **Repeats are separate lines**, in order (`x = 1`, `x = 2`), never merged.

The same tree with meta: positions here, the fence's stripped indentation, and the filename on the root. A fixture that pins meta would hold all of it; `cfg`'s lines are elided here only to save space:

```text
(file "nav.udon")
nav  (at 1:1)
  $traits = t"main"
  $key = t"top"
  aria-label = t"Site " · {a href=t"/ Home"} · " " · {a href=t"/about About"}
  late = 1  (at 5:3)
  ; "a note"  (at 2:3)
  p  (at 3:3)
    $main = t"See " · {a href=t"/docs the docs"} · " and " · @{faq} · "."
    t"Second line " · ;{todo} · " here."  (at 4:5)
  ≡ sh  (at 6:3 strip [2])
    "make build\n"
cfg  (at 9:1)
  …
```

Meta is always `(key value …)` at the end of a line. A `(…)` line on its own at column 0, before anything else, is the root's meta. In content mode none of it is printed.

### What the transcript shows about this example (worth a look by itself)

Printed honestly, the first line is probably **not what its author meant.** I read it by the records as they stand: Joseph's "embeds are always pieces of text", and 0.10.0's rule (K10, §6.4) that an unquoted value runs until a framed block marker, which the line-ownership record says the coordinator plans to follow; pre-design 71 is still formally open. Two things happen:

- **`aria-label` swallows both links.** `Site |{a…} |{a…}` is one text with four pieces. `nav` gets no `$main`.
- **`|{a :href / Home}` gives `href = t"/ Home"`** and no `$main`. "Home" doesn't end the value, because only a framed marker does. 0.10.0 §6.4 says the same thing explicitly. The same goes for `/about About` and `/docs the docs`.

What the author probably expected would need `:href "/" Home`, or `:aria-label "Site"`. Under the same records it prints as:

```text
nav
  $traits = t"main"
  $key = t"top"
  aria-label = "Site"
  $main = t{a href="/" $main=t"Home"} · " " · {a href="/about" $main=t"About"}
```

I think that's a strong counter fixture for the XML/HTML objective. It may also be something Joseph wants to see, since `|{a :href /docs the docs}` is the idiom people reach for. Whether this is the intended behavior is not mine to call. A notation that hides piece structure (one string per value, say) would have hidden it.

## 3. Why this shape and not another

- **Not UDON itself.** Writing the tree in UDON is circular in fixtures: the expected side needs a UDON parser, so a parser bug can appear on both sides. In chat it blurs input and output, which is exactly what Joseph needs kept apart when comparing options. The text-versus-string distinction is the very thing being specified, and UDON's spelling of it (quotes or no quotes) is the input, not a picture of the result. So the structure is deliberately non-UDON: no `|`, no `:label`. Only the **leaves** borrow lite's own spellings (`<…>`, `@{…}`, `;{…}`, `[…]`, `"…"` escapes), because those are opaque values whose transcript *is* their raw text.
- **Not JSON or S-expressions as the fixture form.** They are mechanical but unreadable at the sizes Joseph's composite examples reach, and a failing fixture is diagnosed by reading a diff. With a canonical printer, the readable form is just as mechanical. If a harness author wants structure anyway, the reference tool (§5) can emit JSON from a transcript, but no fixture stores it.
- **Not the box-drawn tree (`├ └ │`)** that the pre-design files use, even though Joseph is fluent in it. It has two practical costs:
  - **Diffs aren't local.** Adding a last sibling changes the previous sibling's `└` to `├` and rewrites the `│` prefix on every line of that sibling's subtree.
  - **It's error-prone to write by hand.** Expected trees will be written by hand for months before any parser exists.

  What it did well, telling attributes from children at a glance, is kept by `=`. Element lines are bare names, and every other kind of line starts with its own mark (`t"`, `; `, `≡`).

Carried over from the pre-design notation and `JOSEPH-FOR-0.10.01-FIX.md`, so existing trees convert almost line for line:

- `"…"` is a string;
- bare scalars are typed;
- `·` joins pieces;
- `(meta …)` in parentheses.

What changes: `element x` → `x`; `├ text "…"` → `t"…"`; `label value` → `label = value`.

## 4. The canonical printing (the printer's whole contract)

1. **Lines** end in LF; indentation is two spaces per level; no tabs; no trailing spaces.
2. **Root**: no line of its own. Its attributes, then its children, are at column 0.
3. **Element**:
   - the name, bare when lite could spell it unquoted, otherwise as a quoted string; `∅` when it has no name;
   - then its attributes in order, then its children in order, at +2.
4. **Attribute**: `label = value`.
   - The label follows the name rule.
   - An element value prints as `label =` with the element in block form at +2. So `author = "…"` is always a string, never an element.
5. **Text**: `t`, then its pieces joined by ` · `.
   - A run is a quoted string. A line break in the transcript follows every LF inside a run.
   - A continuation line is indented one column past the `t`. If it begins with `"`, it continues the same run; if it begins with `· `, a new piece starts.
   - Adjacent runs never occur, because a tree holds maximal runs.
6. **Comment node**: `; ` and a quoted string; continuation lines at +2.
7. **Fence**: `≡`, a space and the label (omitted when empty); the body as quoted lines at +2, one per source line.
8. **Scalars**:
   - **String:** `"…"` with lite's `"…"` escapes (`\\ \" \n \t \r \f \e`). Every Cc, Cf and `White_Space` character other than U+0020 is written `\u{X}`; everything else is literal.
   - **Integer:** decimal.
   - **Float:** see below.
   - **Booleans and nil:** `true`, `false`, `nil`.
   - **List:** `[…]`, items separated by single spaces.
   - **Typed value, reference, inline comment:** `<…>`, `@{…}` and `;{…}` with the raw text. Every `\` and every delimiter character is backslash-escaped, so the result is also a valid lite spelling of that span.
   - **Inline element:** `{name label=value …}` on one line.
9. **Floats**: ECMAScript `Number::toString` (shortest round-trip digits; plain decimal for exponents in [-6, 21), else `1e+21` / `1e-7`), with `.0` appended when the result has neither `.` nor `e`. That makes `1.0` never print as the integer `1`, and every language gets the same bytes. Each language has a shortest-round-trip formatter (Python `repr`, Rust `{}`, JS `String`). This rule is the fiddliest part of the printer, and I'd rather pin it now than discover the differences from failing fixtures later.
10. **Meta mode only**:
    - `  (key value …)` at a line's end;
    - a root-meta line `(…)` first;
    - `(blank)` lines where the tree records ornamental blank lines.

    Which meta keys exist is lite's to decide. The notation only needs `(key value …)`.

In the chat and spec forms, three liberties are allowed and the fixture form takes none of them:

- remarks after `←`, and anomalies after `⚠` (warning) or `✗` (error);
- `…` for elided material;
- aligned `=` columns.

## 5. Fixtures and the harness

The case shape stays as in `dat/implied-root.yaml`. `tree:` holds the canonical transcript as a YAML literal block. Because every character of content is inside quotes, YAML's whitespace handling can't change a tree. And no transcript line starts with three backticks (`≡` is the fence mark), so transcripts nest safely inside Markdown fences in the spec.

```yaml
  - id: nav_aria_label_swallows_links
    profile: counter
    exercises: [line-scan, inline-elements]
    per: [line-ownership-main, inline-elements-in]
    udon: |
      |nav :aria-label Site |{a :href / Home}
    expects: >-
      aria-label is "Site" and the link is nav's $main, with href "/" and
      text "Home".
    tree: |
      nav
        aria-label = t"Site " · {a href=t"/ Home"}
    anomalies: []

  - id: late_attribute_warns
    profile: canonical
    udon: |
      |el
        |child
        :late 1
    tree: |
      el
        late = 1
        child
    anomalies:
      - warning late-attribute 3:3

  - id: inline_element_unclosed
    profile: canonical
    udon: |
      |p See |{a :href /docs
    error: unclosed-inline-element 1:8
```

**How a harness compares:**

1. The implementation exposes `transcript(tree, meta=false)`.
2. The harness parses the case's `udon`, prints the tree, and compares the result byte for byte with `tree`. The canonical form ends every line, including the last, with LF, which is what a YAML `|` block yields. An empty tree is `tree: ""`.
3. On a mismatch it prints a unified diff. Because the notation puts one item on each line, the diff points at the wrong attribute or piece.
4. Anomalies are compared as an ordered list of `severity kind line:col`. An error case has `error:` and no `tree:`, and compares only the kind and position. Message wording is free.
5. A case that pins meta says so (e.g. `meta: true`), and the harness prints with `meta=true`. Every other case compares content only, which leaves meta free to evolve ([[decision:forward-compat-aspiration]]).

**What each language implements:** only the printer, about 100 lines plus float formatting. Printing a tree into one canonical form is much easier than parsing a notation, and the parser being tested already has the tree.

**Hand-written expected trees:** one reference tool, written once, parses a transcript and reprints it canonically. Its lint fails a fixture whose `tree:` isn't already canonical, and shows the diff. That catches the hand-writing slips (spacing, a missing `t`, `·` spacing) before any parser exists. The same tool can emit JSON for anyone who wants it. The scratchpad prototype is the printer half; I haven't written the parser half.

**Positions** are `line:col`, 1-based. I'd count columns in Unicode scalar values. That is a choice to confirm with [[rule:lines-and-columns]], since lite says only U+0020 sets nesting columns but positions also have to count other characters.

**Reading options**: `tree:` is always the raw tree. If the spec names reading options normatively, a case can add `read: {embed-alone: |…}`, written in the same notation (§6.3).

## 6. More examples, chosen to show strengths and limits

### 6.1 `$main` versus a text child

```udon
|p Hello
|p
  Hello
```
```text
p
  $main = t"Hello"
p
  t"Hello"
```

The difference [[decision:main-is-an-attribute]] makes ("text on the same line … more like the 'name' or heading") is visible at the first glance: an attribute line against a child line.

### 6.2 Joseph's attribute-sameline example

```udon
|element
   :attr this value :another <34>
   :third value
   :from |other-element
            and a child of it...
```
```text
element
  attr = t"this value"
  another = <34>
  third = t"value"
  from =
    other-element
      t"and a child of it..."
```

(I read the deeper line as `other-element`'s text, which pre-design 74 leaves open.)

### 6.3 Raw versus read: three reading options in one notation

Raw is what fixtures hold. A read view is the same notation with the option applied. For chat I'd show raw, then only the lines the option changes:

```text
|el :x |{em hi}          raw:   x = t{em $main=t"hi"}
                         read (embed-alone):
                                x =
                                  em
                                    $main = t"hi"        ← now identical to raw |el :x |em hi

|el :who @{people/jw}    raw:   who = t@{people/jw}
                         read (embed-alone):   who = @{people/jw}

|p Hello                 raw:   p                read (main-first):   p
                                  $main = t"Hello"                       t"Hello"    ← from $main

|el :x 1 :x 2            raw:   x = 1            read (stacked default, K15):   x = [1 2]
                                x = 2
```

The `t` prefix is what makes the single-piece rule show up as a visible one-character change (`t@{…}` → `@{…}`) rather than an invisible one. Joseph's own sketch of `|nav |{a} |{a}`, `text[embedded_node(a...),' ',embedded_node(a...)]`, prints as:

```text
nav
  $main = t{a} · " " · {a}
```

The space between the two links is a piece of its own, so the question of whether it is content is answered on the page, not left implicit.

### 6.4 Text across lines, blank lines inside text, embeds across lines

```udon
|node some $main prose
    child prose section starting...
      
    more prose...
|p See |{em this}.
  And on the next line
  @{a.b} tail
```

(The third line has six spaces.)

```text
node
  $main = t"some $main prose"
  t"child prose section starting...\n"
   "  \n"
   "more prose..."
p
  $main = t"See " · {em $main=t"this"} · "."
  t"And on the next line\n"
   · @{a.b} · " tail"
```

One source line gives one transcript line, so a fixture diff for a prose change is a one-line diff. Joseph's reassembled text `"child prose section starting...\n  \nmore prose..."` is the plain concatenation of the three quoted lines. Whether the last line of a text child carries its LF is open (57); the transcript shows either reading exactly.

### 6.5 Strings, escapes, names, nameless, node values

```udon
|'something "hey"\'' weird node name
|el :re <re:\\d+> :path "C:\\Users\tx\u{A0}y" :author
  |person :name "Jane Doe"
|[k] :a 1
|step[1].a.b
```

```text
"something \"hey\"'"
  $main = t"weird node name"
el
  re = <re:\\d+>
  path = "C:\\Users\tx\u{A0}y"
  author =
    person
      name = "Jane Doe"
∅
  $key = t"k"
  a = 1
step
  $key = 1
  $traits = t"a"
  $traits = t"b"
```

Notes on these:

- **The typed value prints as its lite spelling, `<re:\\d+>`.** The raw text is `re:\d+`. The printer re-escapes by the span's own rule, so what you read is a valid lite spelling of that tree, but you must remember the backslash is escaped. The alternative, a JSON string inside (`<"re:\\d+">`), has the same escaping and is uglier, so I didn't take it.
- **The no-break space and the tab are made visible.** That matters for the NBSP and tab questions still being settled.
- **Nameless elements** (`∅`) print only if lite keeps them (77 Q3).
- **A quoted element name** starts its line with `"`. Such a line is told from a text continuation line by indentation alone: two-space steps for item lines, one past the `t` for continuations. A reader who misreads it gets corrected by the lint. It's rare enough that I didn't spend a mark on it.

### 6.6 Descriptive readings: where a blank line goes (55)

```udon
|a
  |b
    text of b

  |c
|d
```

Shown in meta mode, because blank lines at seams are ornament:

```text
A (deepest open node)     B (parent of the next line)     C (not in the tree)
a                         a                               a
  b                         b                               b
    t"text of b"              t"text of b"                    t"text of b"
    (blank)                 (blank)                         c
  c                         c                             d
d                         d
```

Side by side works when the trees are short. Otherwise stack them, each under its option label.

### 6.7 The root's attributes (04 Q2), and the counter case in `implied-root.yaml`

```text
04-Q2-A                          04-Q2-B
t":title My Notes"   ⚠ …         title = t"My Notes"
section                          section
```

The counter case `root_is_never_spelled` (`|document` with `|section` under it) prints as:

```text
document
  section
```

This is the one place where dropping the root line costs something. A reader who forgets the rule "column 0 is inside the root" might take `document` for the root, which is the very mistake that case is there to correct. The alternative is a `⊤` line for the root, with everything else one level deeper. That costs two columns on every line of every tree. I'd keep the root implicit and let the spec's first example teach the rule, but it is a cheap flip.

## 7. Limits and costs, honestly

- **Long inline elements get wide.** `{a href=t"/docs the docs"}` is fine. An inline element whose text holds another inline element (`t"x " · {b $main=t"y " · {i $main=t"z"}}`) is still exact but takes effort to read. Lite's one-line inline forms keep the nesting shallow in practice. Chat may break such a line with a remark; fixtures can't.
- **The `t` costs a character on every text**, which is most values. If Joseph's worry about "string" being a distinct type from "text" ends with them merged, delete the `t` (and `"…"` means both); nothing else changes.
- **Some glyphs are "ambiguous width" in Unicode** (`·`, `≡`, `←`). They render as one column in Western terminals but as two in some CJK-locale terminal setups, where alignment would drift. Content is unaffected; only the alignment of chat remarks is.
- **Every implementation must write the printer**, including the float rule. That's a real cost, though smaller than writing a parser for any structured notation, JSON included, in the languages that lack one.
- **Hand-written expected trees need the lint tool to be trustworthy.** Without it, a fixture can fail on a missing space after `·` rather than on a real difference. Until the tool exists, a mismatch that is only spacing is a fixture bug, not a parser bug.
- **One spelling per tree is not one spelling per meaning.** `:x [1 2]` and `:x 1 :x 2` print differently because the raw trees differ. Readings that equate them belong in `read:` views, not in a looser comparison.

## 8. Things the notation forced me to decide or flag (feedback)

These came up only because printing a tree exactly leaves no room to be vague. None of them is mine to settle:

1. **The HTML idiom** in §2: `|{a :href /docs the docs}` gives `href = t"/docs the docs"` under the current reading of K10 and "embeds are always pieces of text". I think this deserves Joseph's eyes before it hardens into fixtures.
2. **What kind a `.trait` value is.** I printed `$traits = t"main"` (text). A trait is spelled as an identifier, not a value, so string, text, or a third kind ("name") are all defensible. `$key` follows the value grammar ([[decision:key-brackets-and-lists]]), so `[top]` gives text and `[1]` an integer.
3. **Whether the space after `;` in a comment is content** (`; "a note"` or `; " a note"`), and whether framing spaces around `;{…}` and embeds belong to the neighboring runs (80). The transcript shows the difference; the records don't say yet.
4. **The final LF of a text child** (57), and **which spaces at a value's edges are content** (80).
5. **Whether inline elements can have children.** I gave the one-line form none: 0.10.0's bracket mode lets only inline forms nest, and those land in text. If lite allows children, a separator after the attributes (I'd use `▸`) is all it needs.
6. **Meta vocabulary** (`at`, `strip`, `file`, `same_line`, blank-line ownership) is undefined. The notation is agnostic about it.

On the question itself: asking for one notation for chat, spec and fixtures was the right call. The three audiences turned out to differ only in which liberties they take, not in syntax. The real fork in the road wasn't "readable or mechanical" but "compare by parsing the notation, or by printing into it", and printing is what makes the readable form mechanical. One more coordination thought: [[rule:tree-transcript]] in the outline is where §4 would land, and `def-fixture-profiles`'s working note ("the tree notation in fixtures is the pre-design text form until a machine transcript is decided") would close with it.

I'm glad to stay available for follow-ups: converting `dat/implied-root.yaml` to this form, writing the parser half of the reference tool, or printing whatever composite examples you and Joseph want to weigh.
