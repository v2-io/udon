# A notation for the lite tree — proposal A

*Written 2026-10-09 by a Claude (Opus 5.5) agent at the udon coordinator's request, answering Joseph's ask in `STEWARD-VERBATIM.md` (2026-10-08, last entry). Written without reading proposal B. The ADRs in `adr/` are the authority for every tree below; where they leave a point open, the tree shows one reading and §8 lists it.*

## 1. The short answer

One notation for chat, the spec and the fixtures. It has one line per attribute or child, and indentation is the nesting:

- **Every line starts with the character the source would start it with:** `|` for an element, `:` for an attribute, `;` for a comment, ```` ``` ```` for a fence. Text is the one exception, because lite writes text without delimiters. The notation puts it in `‹…›`.
- **Every leaf is written the way lite writes it:** `"b c"`, `42`, `0.5`, `true`, `nil`, `<2026-07-11>`, `@{faq}`, `[‹a› "b c" 3]`. Inside `‹…›`, embedded forms keep their brace spelling, so a text with pieces reads like the source line: `‹See |{a :href ‹/docs›} and @{faq}.›`.
- **Sugar is always spelled out** (`:$key`, `:$traits`, `:$main`). An element's attributes come first, in written order, then its children, in written order.
- **Fixtures need no notation parser.** Each implementation writes a small printer from its own tree to this text, following §5's rules. The harness compares the printed text with the fixture's text byte for byte, and on a failure it shows a line diff that a person or an agent can read directly.

The root line is `root`, not `document`, because a «document» is the source ([[def:document]]).

## 2. The notation on one screen

| Line or leaf | Meaning |
|---|---|
| `root` | the implied root node; always the first line |
| `\|name` | an element child; its attributes and children are on the lines below it, indented two spaces more |
| `\|` | an element with no name |
| `:label value` | an attribute. A repeated label is repeated lines (stacking) |
| `:label \|name` | an attribute whose value is an element; that element's lines are indented below it |
| `‹…›` | a text, as a child or as a value |
| `; "…"` | a comment child (its content is raw, so it is a quoted literal) |
| ```` ```label "…" ```` | a fence: label, then the body as a quoted literal |
| `"…"` | a quoted string (from `"…"` or `'…'` alike; which quote was used is meta) |
| `42` `-7` `0.5` `true` `false` `nil` | the bare typed values |
| `<…>` `@{…}` | explicit typed value and reference: raw text, re-escaped the lite way |
| `[a b c]` | a list; items are values, separated by single spaces |
| inside `‹…›`: `\|{name :label value … children}` | an inline element; its interior uses the same notation on one line |
| inside `‹…›`: `@{…}` `;{…}` | a reference piece, an inline comment piece |
| ` #key value` at the end of a line | meta (position, `same-line`, quote kind, fence indentation…). Shown only when asked for |
| `← …` at the end of a line | commentary in chat and in the spec; never in fixtures |

Escapes inside `‹…›` belong to the notation, not to lite: `\\`, `\›`, `\n`, `\t`, `\r`, `\u{…}`, and `\|{` `\@{` `\;{` for a literal opener. Inside `"…"` they are lite's own string escapes.

`‹` and `›` are U+2039 and U+203A (Option-Shift-3 and Option-Shift-4 on a Mac). They are narrow in every terminal (East Asian width Neutral), and they never occur in lite syntax.

## 3. The brief's input

````udon
|nav.main[top] :aria-label Site |{a :href / Home} |{a :href /about About}
  ; a note
  |p See |{a :href /docs the docs} and @{faq}.
    Second line ;{todo} here.
  :late 1
  ```sh
  make build
  ```
|cfg :port 8080 :ratio 0.5 :on true :tags [a "b c" 3] :when <2026-07-11> :x 1 :x 2
````

The tree, as the decided rules give it:

````tree
root
  |nav
    :$traits ‹main›
    :$key ‹top›
    :aria-label ‹Site |{a :href ‹/ Home›} |{a :href ‹/about About›}›
    :late 1
    ; " a note"
    |p
      :$main ‹See |{a :href ‹/docs the docs›} and @{faq}.›
      ‹Second line ;{todo} here.›
    ```sh "make build\n"
  |cfg
    :port 8080
    :ratio 0.5
    :on true
    :tags [‹a› "b c" 3]
    :when <2026-07-11>
    :x 1
    :x 2
````

Anomalies: `warning late-attribute 5:3`.

What it shows at a glance, line by line:

- `$traits` comes before `$key` because `.main` is written before `[top]`, and attributes keep written order.
- **`nav` has no `$main`.** Both links are pieces of `aria-label`'s text, because unquoted text runs until a block form ([[decision:embeds-are-pieces-of-text]]), and `|{` is not one. That is what the rules say. It is probably not what an HTML author means. §8 has more on this.
- **The links have no link text.** Inside `|{…}`, an unquoted value runs to the `}` (0.10.0's K10 rule; pre-design 50 is still open). So `href` is `/ Home`.
- `:late 1` sits with the other attributes. The tree has no "came late"; the warning carries that. With `#at` meta asked for, the line would read `:late 1 #at 5:3`.
- `p`'s own line and the text below it stay separate, as `$main` and a text child ([[decision:main-is-an-attribute]]). Inside each text, the pieces are in the order written. The spaces around `;{todo}` are text.
- `[‹a› "b c" 3]` keeps unquoted `a` (a text) apart from quoted `"b c"` (a string).

Under pre-design 50's option B (in braces, an unquoted value is one token), three lines change:

```text
    :aria-label ‹Site |{a :href ‹/› ‹Home›} |{a :href ‹/about› ‹About›}›
      :$main ‹See |{a :href ‹/docs› ‹the docs›} and @{faq}.›
```

If the author wanted the links in `nav` itself, they would quote the label's value. Then `"Site"` stands alone and the rest of the line goes to `$main`:

````udon
|nav.main[top] :aria-label "Site" |{a :href / Home} |{a :href /about About}
````
````tree
root
  |nav
    :$traits ‹main›
    :$key ‹top›
    :aria-label "Site"
    :$main ‹|{a :href ‹/ Home›} |{a :href ‹/about About›}›
````

## 4. More inputs, chosen to show strengths and limits

### 4.1 Text, strings, and the typed values

````udon
|v :a hello :b "hello" :c 'hello' :d "say \"hi\"\n" :e 42 :f "42" :g <42> :h nil
````
````tree
root
  |v
    :a ‹hello›
    :b "hello"
    :c "hello"
    :d "say \"hi\"\n"
    :e 42
    :f "42"
    :g <42>
    :h nil
````

`:b` and `:c` print the same; with `#quote` meta asked for, `:c "hello" #quote single`. Every leaf except `‹hello›` is written as lite would write it, so a reader can check a leaf by eye against the source.

### 4.2 Embedded forms are pieces of text; the raw tree and a reading view

````udon
|nav |{a :href / Home} |{a :href /about About}
|el :x |{em hi} :y |em hi
|el :author @{people/jw} :n ;{}
|cite[@{ref.key}]
````
````tree
root
  |nav
    :$main ‹|{a :href ‹/ Home›} |{a :href ‹/about About›}›
  |el
    :x ‹|{em ‹hi›}›
    :y |em
      :$main ‹hi›
  |el
    :author ‹@{people/jw}›
    :n ‹;{}›
  |cite
    :$key ‹@{ref.key}›
````

Joseph's `nav $main text[a, " ", a]` reads straight off the first line. The same lines through the single-embed reading option ([[decision:representational-options]]) lose their brackets, and that loss is the whole visible difference:

```text
read, single-embed on:
    :x |{em ‹hi›}            ← now an element value, the same as :y below
    :author @{people/jw}
    :n ;{}                   ← a comment as the value: see §8
    :$key @{ref.key}
```

In a raw tree an embed never stands outside `‹…›`, so a reader of raw trees never has to ask whether `@{…}` alone is a reference or a one-piece text. In a reading view it is the reference, and the view is labelled.

### 4.3 `|{em hi}` and `|em hi` are different shapes

`:x` and `:y` above show it: the inline `em` has a text **child** `‹hi›` (0.10.0's interior-content rule for `|{…}`), while the block `em` has a `$main`. In the one-line form of §6, that's `|{em ‹hi›}` beside `|{em :$main ‹hi›}`. The notation doesn't decide this; it puts the two side by side. §8 says why that may matter.

### 4.4 Same-line chains, and meta when asked for

````udon
|table |tr |td A1
           |td A2
````
````tree
root
  |table #at 1:1
    |tr #at 1:8 #same-line
      |td #at 1:12 #same-line
        :$main ‹A1›
      |td #at 2:12
        :$main ‹A2›
````

Without meta, the same tree is the four structure lines and two `:$main` lines. Meta is printed only for the keys a fixture names, so most fixtures never mention positions.

### 4.5 Attribute-sameline and an element as a value

Joseph's example from 2026-09-29:

````udon
|element
   :attr this value :another <34>
   :third value
   :from |other-element
            and a child of it...
````
````tree
root
  |element
    :attr ‹this value›
    :another <34>
    :third ‹value›
    :from |other-element
      ‹and a child of it...›
````

### 4.6 Blank lines inside text; a comment block

Joseph's blank-line example (the third line holds six spaces), followed by a comment block that owns a deeper line:

````udon
|node some $main prose
    child prose section starting...
      
    more prose...
; a comment
  still the comment |el
````
````tree
root
  |node
    :$main ‹some $main prose›
    ‹child prose section starting...\n  \nmore prose...›
  ; " a comment\nstill the comment |el"
````

His reassembled text, `"child prose section starting...\n  \nmore prose..."`, is the text line exactly. The `|el` inside the comment is comment content, and it prints inside the quoted literal, where nobody can mistake it for an element.

### 4.7 Fences: nesting by length, and verbatim

`````udon
|doc
  ````md
  Use:
  ```js
  run()
  ```
  ````
|patch
  ```diff-
 context
-removed
  ```
`````
````tree
root
  |doc
    ```md "Use:\n```js\nrun()\n```\n"
  |patch
    ```diff- " context\n-removed\n"
````

A fence always prints with three backticks, because its body is a quoted literal and can't end early. The opener's length is meta (`#ticks 4`), and so is the indentation removed from each body line (`#strip 2`). When a fence tree goes inside Markdown (a spec record, or chat), the fence line has text after its backticks, so CommonMark never reads it as a closer. The wrapper here uses four backticks anyway, because the input beside it needs them.

### 4.8 Stacking versus a list

````udon
|el :x 1 :x 2
|el :x [1 2]
````
````tree
root
  |el
    :x 1
    :x 2
  |el
    :x [1 2]
````

Two raw trees. Whether a consumer reads them the same (0.10.0's K15 "default read") is a reading view, and the notation shows it as one if it is ever named.

### 4.9 Errors, and the implied root

An error gives no tree, so its expected result is one line:

```text
|el[abc              →  ✗ error unclosed-key 1:4
|a :x 1⇥|b           →  ✗ error tab-shifts-column 1:8
```

(The codes are placeholders until the anomaly inventory names them.)

The implied root, with parser-supplied meta asked for:

````udon
|document
  |section
````
````tree
root #file "notes.udon"
  |document
    |section
````

## 5. Fixtures, and how a harness compares

A fixture case keeps today's shape (`dat/implied-root.yaml`). Its `tree` field holds the notation in canonical form. Its `anomalies` are a list of `severity code line:col`. A case that errors has `error` in place of `tree`. A case about meta names the keys it compares, and a case about a reading view adds the view's tree under `read`:

````yaml
- id: nav_label_swallows_links
  profile: counter
  exercises: [unquoted-values, inline-elements]
  per: [embeds-are-pieces-of-text, line-ownership-main]
  udon: |
    |nav :aria-label Site |{a :href /about About}
  expects: >-
    aria-label "Site", and the link as nav's content.
  tree: |
    root
      |nav
        :aria-label ‹Site |{a :href ‹/about About›}›
  anomalies: []
````

**What each implementation writes:** a printer from its own tree to the canonical text, with a list of meta keys to include. Printing is much easier than parsing. A printer is about a hundred lines, and most implementations want a debug printer anyway.

**What the harness does,** for each case:

1. Parse `udon`.
2. If the case has `error`, compare the error's code and position.
3. Otherwise print the tree, including only the meta keys the case names, and compare the result with `tree` byte for byte.
4. Compare the anomalies as a list sorted by position.
5. On a failure, show a unified diff of the two printed trees. One line per attribute or child makes that diff point at the exact node.

**The canonical printing rules,** which are also the rules a fixture author's tree must follow:

1. The first line is `root`, plus any requested root meta. Each attribute or child is one line, indented two spaces per level. An element's attributes come first, in written order, then its children, in written order. An element-valued attribute is `:label |name`, with that element's lines one level deeper.
2. Names and labels are printed bare, unless they are empty, contain whitespace or any of `"‹›{}[]<>#\` and the backtick, or start with `: ; @ |`. Otherwise they are printed as `"…"`.
3. Quoted strings, comment content and fence bodies are printed as `"…"`. `\` and `"` are escaped, as are `\n` `\t` `\r`, and `\u{X}` (uppercase hex) is used for every other character in the Unicode categories Cc, Cf, Zl and Zp, and for every Zs character other than U+0020. This means a no-break space is always visible as `\u{A0}`.
4. Text is printed as `‹…›`. Runs use the same character escapes as rule 3, plus `\›`, and `\|` `\@` `\;` before a `{`. Inline elements are printed as `|{name :label value … child …}`, single-spaced.
5. `<…>`, `@{…}` and `;{…}` print their raw text with `\` doubled and only the unmatched delimiters escaped, so `@{x {y} z}` prints as written.
6. Integers are printed in decimal. Floats take the shortest digits that round-trip, laid out by ECMAScript's `Number::toString` rule, with `.0` added when no `.` or `e` appears. This holds if the tree carries number values; if lite decides the tree carries the spelling, rule 6 is replaced by "print the spelling" (§8).
7. Meta is printed as ` #key value` after the line's value or head. Only requested keys are printed, in alphabetical order.
8. There are no trailing spaces, and there is one final newline.

**A shared tool, written once:** a reader and printer for the notation (one Python file) can check that every fixture's tree is canonical (read, print, compare), show trees side by side, and emit JSON for anyone who wants structure. A rough version exists at `/private/tmp/claude-505/-Users-josephwecker-v2-src-arch-firmatum-udon/293bb1ee-c26c-4c95-bc14-6f01bedb2879/scratchpad/treenote.py` (session scratchpad, so not kept). Every `tree` block in this file reads and prints back to itself under it. That check covers only those blocks: the one-line form, the reading views and the error lines in `text` blocks were not checked.

## 6. Chat, spec and fixtures: one notation, three latitudes

- **Fixtures:** canonical form only, as in §5.
- **Spec:** canonical form, plus `←` commentary on lines, plus `#` meta wherever the record is about meta.
- **Chat:** all of that, plus two shortcuts for comparing many examples quickly:
  - **The one-line form.** Any element may be written `|{name …}` on one line. It's the inline-element spelling used for a block element, and a reader can tell which is which, because inline elements only ever appear inside `‹…›`. The one-line form can also drop the `root` line when only one node matters.
  - **Arrow lists.** For example:

    ```text
    |p Intro text |em x       →  |{p :$main ‹Intro text› |{em :$main ‹x›}}
    |p Hello                  →  |{p :$main ‹Hello›}
    |table |tr |td A1         →  |{table |{tr |{td :$main ‹A1›} |{td :$main ‹A2›}}}
               |td A2
    |ul |{li one} |{li two}   →  |{ul :$main ‹|{li ‹one›} |{li ‹two›}›}
    ```

  The shared tool can expand a one-line tree to the canonical form, so nothing written in chat is a different language.

When options are compared in chat, each tree carries a one-word label above it (`A`, `B`, `raw`, `read, main-first`), and the lines that differ can be marked `←`.

## 7. What I weighed, and why not

- **UDON itself as the notation.** It's appealing, but circular: reading an expected tree means parsing UDON in your head, so a lite parser bug can hide in the expectation. It also can't show the hard case. In UDON, `"…"` means a string and text has no delimiter, so a text and a string can't both be shown. The proposal keeps UDON's line-start characters and leaf spellings and changes only what needs changing.
- **A JSON transcript (pre-design 86's option B).** It's mechanical, but a text with three pieces becomes an array of tagged objects, diffs become noisy, and Joseph called that kind of thing jarring. If someone needs JSON, the shared tool can emit it from the notation; nothing has to be written in it.
- **S-expressions.** They're compact, but deep nesting turns into a run of closing parentheses that a terminal reader has to count, and they don't diff line by line.
- **The pre-design notation** (`document`, box-drawing branches, `element`/`text` words, `"…"` for both text and strings). I kept its spirit: one line per node or attribute, nesting by indentation. I changed three things:
  - `"…"` stood for both text and quoted strings, which is exactly the distinction the brief names as hard;
  - box branches change on the previous sibling's line whenever a sibling is added, which adds diff noise and is fiddly to write by hand (agents write most fixtures);
  - pieces joined with `·` take more room and read less like the source than the brace spelling inside `‹…›`.

## 8. What the notation surfaced (for the spec work, not decided here)

These turned up as soon as the trees had to be written out exactly. Each is a fact about the rules as recorded, not a lean.

1. **The HTML link idiom loses its text, twice over.** Under [[decision:embeds-are-pieces-of-text]], `|nav :aria-label Site |{a …} |{a …}` puts both links inside `aria-label`. Under K10 inside braces (pre-design 50, open), `|{a :href /docs the docs}` has no link text at all. The brief's own example hits both. For lite's XML/HTML objective ([[obj:represent-xml-html]]), 50 looks like the most urgent open question, and the first case is a natural counter fixture (§5's example).
2. **`|{em hi}` versus `|em hi`** (§4.3): interior text child versus `$main`. One rule everywhere ([[prin:one-rule-everywhere]]) would make them the same shape, either way round. HTML readers get content either way, through the main-first view.
3. **The main-first reading view gives two text children in a row** for `|p See … and @{faq}.` followed by an indented line. Does the view merge them, and with what between them?
4. **Single-embed on `:n ;{}`** reads the value as a comment. Perhaps the option should apply only to `|{…}` and `@{…}`.
5. **Small facts the printer has to know,** each a one-line decision when its record is written:
   - whether a comment's text keeps the space after `;` (shown kept: `; " a note"`);
   - whether a text ends with its final newline (shown without one, per the trailing ` \` discussion; fence bodies shown with one, per [[decision:fence-body-indentation]]'s example);
   - whether `.main` is a text, a string or a name (shown as text, like `[top]`);
   - whether the `-` stays in a fence label (shown kept: `diff-`);
   - whether numbers are values or spellings (`0x10` versus `16`);
   - whether columns in positions count code points;
   - which invisible characters are escaped.

## 9. On the question itself

The outline already has a row for this: [[rule:tree-transcript]], "the one written form of a «tree»". I'd suggest that record be §5's printing rules. It has a useful side effect for pre-design 60. If the canonical printer can't print something, the raw tree doesn't hold it. So "what the tree must preserve" becomes a checkable list: the printed fields, and the meta keys, kept separate.

I'm available for follow-up questions, and for trying the notation on any examples you or Joseph want to put through it.
