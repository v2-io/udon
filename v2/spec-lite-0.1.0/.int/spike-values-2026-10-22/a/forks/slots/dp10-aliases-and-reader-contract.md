# DP10: aliases and algebraic names, and what lite owes the reader layer

*Slots fork, spike a, 2026-10-22. Labels as in `dp6-slot-types.md`.*

## Aliases live in the dialect

Joseph's concept: "designating `port` as one of u16 | standard-ports, with standard-ports designated as {'smtp','ssh','http',...} … At the very least, type aliases." It's a statement about a slot's domain, so it lives where slot types live (DP6 S0): the dialect. Lite has no declarations (`!` is reserved), so:

- **L0, alive:** aliases and unions are written in a dialect, which may itself be a lite document; lite reads it as plain data, and the reader gives it meaning.
- **L1, dead for lite:** declaring an alias inside the document being read needs a directive or a header, which is full UDON. *Reason it died:* lite has nowhere to put a declaration that isn't data, and `!` is refused ([[obj:reserve-dont-ignore]]).

```udon
; dialect "server" (illustrative)
|type[standard-port] :one-of [smtp ssh http https]
|type[port]          :union  [u16 standard-port]
|slot[port]          :type port

; a document
|server[web] :port ssh
|server[db]  :port 5432
```
````tree
root
  |server
    :$key ‹web›
    :port ‹ssh›
  |server
    :$key ‹db›
    :port ‹5432›
````
The reader resolves `ssh` through `standard-port` to 22 and reads `5432` as a u16. Lite's tree is the same with or without the dialect.

**One case where lite's evidence decides the reading:** a union whose arms overlap. Take `version = integer | semver`: `:version 2` could be either. The reader needs the value's **form** as evidence: bare `2` is an integer by the dialect's first matching arm, or the author writes `"2"` (quoted, a «string») to pick the semver arm. So lite must keep bare and quoted apart in the tree. It already does: a «string» and a «text» are different values ([[def:value]] invariants).

On host types: `u16` straddles a domain range (0–65535) and a storage type. Read in a dialect, I'd treat it as the **domain range** with a familiar name, and let each host pick its storage. That keeps H (host type) out of the documents and the dialects, as the ideation notes' lean put it. *Taste, M.*

## What lite owes the reader layer: the contract

Every reader that gives values meaning (the default view, a dialect, a notation) leans on the same evidence in the tree. Stated as invariants, these are what DP6, DP9 and DP10 turn out to need, and nothing more:

| | Lite guarantees | Why a reader needs it | Where lite stands today (checked against the cards) |
|---|---|---|---|
| R1 | Every value's exact spelling is recoverable | readers parse notations (`5m`, `05-03-27`, `0xff`) from the spelling | text carries its characters; the original spelling, in «meta», is open ([[def:meta]]) |
| R2 | Every value's **form** is distinguishable: bare, double-quoted, single-quoted, angle, list, element | form is the evidence for overlapping unions and for "insist it's text" | string vs text is a value-level distinction ([[def:value]]); quote kind is in «meta» per [[rule:tree-transcript]] |
| R3 | Every value's **slot** is addressable: file designator, element name, key, traits, ancestors, attribute name, occurrence, list index | slot types and aliases are looked up by address | yes, except that the file designator is only a convention (`design/file-naming.md`) |
| R4 | Stacked occurrences and list items keep written order | unions and lists are read in order | [[def:stacking]] |
| R5 | Lite never converts a spelling to a host value | readers never have to undo a lite guess (the old `0755`→755 kind of loss) | true of every card; the default view is the only reading lite names |
| R6 | Spellings a later UDON may use to declare types inline stay errors in lite: `:name<…>`, `:name(…)`, `:name[…]` directly after a name, and `!` | a later in-document declaration then changes no accepted tree | true under the label lean (brackets are errors in labels); worth stating as the reason |
| R7 | The default reading (the typed-primitive view) is defined in exactly one place | schema-less readers agree with each other | the classification fork's question |

**The finding:** under the bare-is-text lean, lite already meets R1–R5 and R6 almost by accident. The type system Joseph sketched (slot types, aliases, units, coercion, canonical display, host types) needs **no new syntax in lite 0.1**, only these guarantees stated once. A proposed card for that: a short invariants card, "lite records, readers mean", citing R1–R7. It would answer [[obj:represent-structured-data]]'s question of what "the same data" means: the same evidence, read by the same dialect.

## Composite lines under the slots fork's lean (S0, T2, U2, L0)

C-a, the server line:
```udon
|server[web] :port: 8080 :timeout: 30s :started-at: 2026-07-21T14:20 ; prod
```
````tree
root
  |server
    :$key ‹web›
    :port ‹8080›
    :timeout ‹30s›
    :started-at ‹2026-07-21T14:20›
    ; prod
````
*Meta:* the three ornamental colons. With the `server` dialect: u16 8080, a duration of 30 s, a datetime. Without it: three texts (and `8080` read as a number by the default view). How `started-at` would be written for a reader with no dialect at all (`<…>` or not) is the angle-bracket fork's question.

C-b, unaffected by these branches:
```udon
|p Chapter 3: The Return
  See |{a :href: /x the docs} ;{todo} for more.
```
`$main` is ‹Chapter 3: The Return›, and the first word isn't followed by `:`, so there is no warning. Inside the inline element `:href:` takes the ornament like any attribute name; the embed's interior is still undesigned ([[rule:inline-element-value-end]]).

C-c:
```udon
|post :tags: [1 two 2026-07-21]
```
A list of three «texts» (the view reads `1` as a number). A dialect with `tags: list of (integer | word | date)` reads 1, `two`, and a date. Without one, all three are texts, honestly.
