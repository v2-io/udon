# A cross-domain survey of "path" / addressing notations

**Purpose.** Cross-pollination fuel for UDON's path-capability ideation — *not*
a spec, *not* an evaluation, *not* authoritative on any single system. Each row
is a seed to react against. Breadth and idea-density over depth; where I'm
unsure of a fine detail I've said so rather than stalling.

**How to read it.** Grouped by family so related notations sit near each
other; numbering is continuous across the whole document so rows can be
cited (`#88`) from elsewhere. Every row carries a `scope` tag from the
brief's own frame:

- **to** — locates a resource (a document, an object, an endpoint)
- **into** — addresses a place *within* an already-located structure
- **across** — the notation's own syntax composes the two in one expression

Some systems are ambiguous or split across their own history — I've tagged
what the *notation itself* does, not the surrounding ecosystem. A `brief`
column of terse tags per row; the real content — the **distinctive mental
model** each notation embodies — lives in the `## Notes`, keyed by number.

I ranged fairly far on some corners (esoteric OSes, math notations, robotics)
using general knowledge without fresh verification — flagged inline with
`(recall, not verified)` wherever I'd genuinely want a second check before
anyone treated the specific syntax as gospel. The *shape* of the idea is
solid even where a syntax detail might be slightly off.

---

## A. Filesystem & OS

| # | source | example | brief | scope |
|---|---|---|---|---|
| 1 | POSIX/Unix fs | `/usr/local/bin/../share` | fs, single root, `/`-sep, `.`/`..` | to |
| 2 | DOS/Windows | `D:\HOME\file.txt` | fs, drive-letter roots (no single tree), `\`-sep | to |
| 3 | Windows UNC | `\\server\share\dir\file` | network fs, host is part of the root, not an add-on | to |
| 4 | Windows long-path prefix | `\\?\C:\very\long\path` | opts out of legacy parsing/length limits — a path with a mode-selector prefix | to |
| 5 | Classic Mac OS (pre-X) | `HD:System Folder:Extensions` | `:` separator, volume-name-as-root, no leading/trailing slash convention | to |
| 6 | Amiga OS | `Work:Project/Source/main.c` | named-volume root (`Work:`) then `/`-descent — hybrid of #2 and #1 | to |
| 7 | VMS | `DISK$USER:[DIR.SUBDIR]FILE.TXT;5` | device + bracketed directory *list* + explicit **version number** in the name itself | to |
| 8 | Plan 9 | `/n/sources/plan9` (everything, incl. network/devices, mounted into one namespace) | radically uniform: no drive letters, no device files as a special case — **everything is a path** | to |
| 9 | Multics | `>udd>Project>user>file` | hierarchical directory, `>` separator predates Unix `/` — direct ancestor | to |
| 10 | macOS/Linux symlink resolution | `/etc/hosts` may resolve through 3 hops | the *notation* is #1's, but the addressed identity is not the string — pointer-chasing is implicit | to |
| 11 | Shell `~` expansion | `~alice/bin`, `~/bin` | a *named-user* anchor baked into the string itself, resolved before the fs sees it | to |
| 12 | Shell CDPATH / relative search | `foo/bar` resolved against a *list* of roots, not one | multi-root relative resolution — closest fs analog to "search path" as sequence | to |

## B. Globbing, brace expansion, search paths

| # | source | example | brief | scope |
|---|---|---|---|---|
| 13 | POSIX glob | `*.txt`, `dir?/file[0-9].c` | wildcard-as-set-membership per path *segment*, not across `/` by default | to |
| 14 | Bash globstar | `**/*.rs` | `**` explicitly crosses depth — glob had to grow a second wildcard for "any depth" | to |
| 15 | Bash brace expansion | `file{1,2,3}.txt`, `{a,b}/{c,d}` | not matching, *generating* — cartesian product of literal path strings before anything is looked up | to |
| 16 | `$PATH` / `PATH` env var | `/usr/bin:/bin:/usr/local/bin` | an *ordered list* of anchors is itself the addressing unit — first-match-wins across roots | to |
| 17 | rsync/tar include-exclude | `--exclude='*/node_modules/*'` | glob repurposed as a *predicate* over paths, not a locator — filter, not address | into |

## C. URIs, URLs, and web addressing

| # | source | example | brief | scope |
|---|---|---|---|---|
| 18 | URI generic syntax (RFC 3986) | `scheme://user@host:port/path?query#fragment` | five slots, each independently addressable; `scheme` makes the whole thing pluggable | across |
| 19 | URL fragment | `https://example.com/doc.html#section-2` | fragment resolution is **client-side, out of band from the server** — the "into" half is deliberately not the resource's job | across |
| 20 | Query string | `?sort=name&order=desc` | a flat, repeatable key-value bag bolted onto a locator — not hierarchical at all | to (annotation) |
| 21 | `mailto:`/`tel:`/`data:` URI schemes | `data:text/plain;base64,SGVsbG8=` | the "resource" can *be* the payload — the locator and the content collapse into one string | to |
| 22 | `file://` URI | `file:///home/user/doc.udon` | fs path reified as a URI — three slashes because the empty-host slot is still there | to |
| 23 | JAR/ZIP URL nesting | `jar:file:/app.jar!/com/Foo.class` | `!` is a **container-boundary marker** — one string threading through two different addressing systems (fs → archive) | across |
| 24 | Java classpath resource | `com/acme/widget/Config.properties` | package-dot-name reinterpreted as fs path at classload time — two notations forced to alias | to |
| 25 | RFC 3987 IRI | Unicode-bearing URLs | same shape as #18, wider alphabet — the *addressing model* didn't have to change, only the character set | to |
| 26 | URN | `urn:isbn:0451450523` | deliberately **location-independent** identity — a "path" that promises never to resolve to a place, only to a thing | to (identity, not location) |
| 27 | Magnet URI | `magnet:?xt=urn:btih:<hash>` | address *is* a content hash plus optional tracker hints — location is advisory, identity is the hash | to (content-addressed) |
| 28 | IPFS path | `/ipfs/QmXo.../a/b/c.txt` | fs-shaped syntax laid over a content-addressed root — the root segment is a hash, not a name | across |
| 29 | data-URI-adjacent: `blob:` URL | `blob:https://example.com/uuid` | a locator that is only valid within one browser tab's memory — path-to-ephemeral-object | to |
| 30 | WebDAV/CalDAV collection paths | `/calendars/users/alice/home/` | HTTP path segments reused as a full hierarchical resource tree (fs-over-HTTP) | to |

## D. Programming-language import / include / require

| #   | source                                       | example                                                           | brief                                                                                                                           | scope                     |
| --- | -------------------------------------------- | ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| 31  | C/C++ `#include`                             | `#include <stdio.h>` vs `#include "local.h"`                      | **the delimiter itself changes the search-path semantics** — angle vs quote is a resolution-strategy switch, not styling        | to                        |
| 32  | Python `import`                              | `import a.b.c`, `from ..pkg import mod`                           | dots double as both package hierarchy *and* relative-ascent count (`.`, `..`) — one glyph, two jobs by position                 | to                        |
| 33  | Java package/import                          | `import com.acme.widget.Config;`                                  | reverse-DNS convention makes the "root" a social/organizational namespace, not a filesystem one                                 | to                        |
| 34  | Ruby `require`/`require_relative`            | `require 'active_support/core_ext'`                               | load-path search (like `$PATH`) vs explicit relative — the *method name itself* encodes the anchor kind                         | to                        |
| 35  | Node/CommonJS `require`                      | `require('./foo')` vs `require('lodash')`                         | **leading-dot presence is the entire signal** for relative-vs-package resolution — no scheme keyword needed                     | to                        |
| 36  | ES modules `import` specifiers               | `import x from './a.js'` (extension usually required, unlike CJS) | resolution algorithm is spec'd and pluggable (import maps) — the string is inert until a resolver interprets it                 | to                        |
| 37  | Go import paths                              | `import "github.com/user/repo/pkg"`                               | the import path **is** a URL-shaped fetch address *and* the package identity simultaneously — no separate registry indirection  | to                        |
| 38  | Rust `use` paths                             | `use crate::module::sub::Item;`                                   | `crate`/`self`/`super` as **named relative anchors** (like `.`/`..` but spelled as words) plus `::` as the only separator, ever | into/to                   |
| 39  | Elixir/Erlang module paths                   | `alias MyApp.Sub.Module`                                          | dotted namespace *is* the module's real name — no separate fs mapping assumed (unlike Java)                                     | to                        |
| 40  | Perl `use`/`require` + `::`                  | `use Data::Dumper;` maps to `Data/Dumper.pm`                      | same fs-aliasing move as #24/#33, older lineage                                                                                 | to                        |
| 41  | XML `xi:include` (XInclude)                  | `<xi:include href="chap1.xml" xpointer="id('sec2')"/>`            | **explicitly separates** the fetch (`href`) from the in-doc address (`xpointer`) into two attributes rather than one string     | across (split, not fused) |
| 42  | Makefile VPATH / include                     | `include config.mk` searched over `VPATH` list                    | build-system reuse of the `$PATH`-list idea for a totally different resolution job                                              | to                        |
| 43  | LaTeX `\input`/`\include` + `TEXINPUTS`      | `\input{chapters/intro}`                                          | extension-optional, multi-root search path, decades before Node's resolver                                                      | to                        |
| 44  | Lisp/Scheme `require`/`load` + `*load-path*` | `(require 'srfi-1)`                                               | symbolic name resolved through a mutable runtime search list — resolution is a *first-class, inspectable* value                 | to                        |

## E. Module & package namespacing (identity, not fs)

| # | source | example | brief | scope |
|---|---|---|---|---|
| 45 | Maven coordinates | `groupId:artifactId:version` | three-part compound key, reverse-DNS group — a "path" with exactly three fixed segments, no more, no less | to |
| 46 | npm scoped packages | `@scope/name` | `@`-sigil marks a namespace segment distinct from the name itself — visually different from a path separator on purpose | to |
| 47 | Python dotted `entry_points` / `sys.path` combo | `pkg.module:function` | `:` switches from *module path* to *attribute-within-module* — a mini across-the-seam notation in one string | across |
| 48 | OSGi bundle symbolic names | `org.acme.widget;version="[1.0,2.0)"` | version isn't a point, it's an **interval expression** riding along in the address | to |
| 49 | Cargo crate + feature paths | `serde/derive`, `tokio::sync::Mutex` | package-name/feature-flag (`/`) is a *different* namespace than in-crate module path (`::`) — same crate, two separator conventions for two purposes | to/into |

## F. Structured-data query & selector languages

| # | source | example | brief | scope |
|---|---|---|---|---|
| 50 | XPath | `/bookstore/book[1]/title/text()` | axis + node-test + predicate per step; `[1]` is **1-indexed** and positional by default (identity needs an explicit predicate) | into |
| 51 | XPath axes | `ancestor::*`, `following-sibling::node()`, `//` | **thirteen named directions of travel**, not just "down" — the richest navigation vocabulary in this whole survey | into |
| 52 | XPointer | `xpointer(id('ch2')/section[2])` | layers XPath *onto* a URI fragment — the canonical "across" precedent (#19's more powerful cousin) | across |
| 53 | CSS selectors | `div.card > p:first-child::after` | combinators (`>`, `+`, `~`, space) each mean a *distinct structural relationship*; pseudo-classes are predicates, pseudo-elements aren't even real nodes | into |
| 54 | XQuery FLWOR | `for $b in //book where $b/@id="42" return $b/title` | path expressions embedded inside a full query language — path as one clause among for/let/where/order/return | into |
| 55 | JSONPath | `$.store.book[*].author`, `$..price` | `$` = document root as a first-class symbol; `..` = **recursive descent**, a single glyph for "at any depth" | into |
| 56 | jq | `.a.b[] | select(.x > 2) | .y` | path expression *is* a pipeline of filters — addressing and transformation are literally the same syntax, no seam at all | into |
| 57 | yq | `yq ea '. as $item ireduce ({}; . * $item)' path/to/*.yml` | jq's model plus multi-document reduce and file-glob-as-input — "path" here is doing double duty (fs glob feeding a jq-model query) | to+into |
| 58 | GraphQL selection sets / field paths | `user.address.city` (as used in error paths / directives) | fields, not a query language per se — but every GraphQL error carries a **response-shaped path array** back to the client, addressing-as-diagnostics | into |
| 59 | Protocol Buffers `FieldMask` | `paths: ["user.address.city", "user.name"]` | a flat list of dotted strings sent *alongside* a message to say which fields a partial-update touches — address as a wire-level update scope, not a query | into |
| 60 | GraphQL/gRPC "field path" conventions differ from #58/#59 mainly in casing/plurality — worth noting the same idea (dotted field selection) reinvented per-ecosystem with zero syntax sharing | — | into |
| 61 | HTML DOM `querySelector`/`querySelectorAll` | reuses #53 verbatim as a live API, blurring "selector" and "live handle" | into |
| 62 | XSLT match patterns | `<xsl:template match="section[@type='intro']">` | a predicate-shaped path used as a **dispatch key**, not a lookup — closer to pattern-matching than querying | into |
| 63 | Selenium/Playwright locators | `page.locator("text=Submit")`, `role=button[name="OK"]` | locators are **semantically-typed** (by role, text, test-id) rather than structurally positional — addressing by *meaning* not *shape* | into |

## G. Array / hash / object dereferencing across languages

| # | source | example | brief | scope |
|---|---|---|---|---|
| 64 | C/JS/most C-family | `arr[3]`, `obj.key`, `obj["key"]` | dot for statically-known names, brackets for dynamic/computed — two syntaxes for the same operation, chosen by whether the key is a literal | into |
| 65 | Perl sigils + arrows | `$hash{key}`, `@array[1,2]`, `$ref->{a}[0]` | **the sigil encodes the result's type**, not the container's — famously alien to newcomers, deeply consistent internally | into |
| 66 | Lisp `car`/`cdr` chains | `(caddr lst)` = `(car (cdr (cdr lst)))` | **the path is encoded in the function name's letters** — `a`/`d` sequence *is* the address, read right-to-left | into |
| 67 | R data-frame/list `$`/`[[ ]]`/`[ ]` | `df$col`, `lst[["a"]]`, `v[1]` | three distinct extraction operators with different **simplify vs preserve-structure** semantics — the bracket style changes the *type* of the result | into |
| 68 | MATLAB/Octave indexing | `A(2,:)`, `A(end)` | `:` means "all along this dimension" (predates numpy's reuse); `end` is a **live symbolic bound**, not a number | into |
| 69 | NumPy/Python slicing | `a[1:5:2]`, `a[..., 0]` | start:stop:step triple: negative indices count from the end natively; `...` (Ellipsis) fills "however many dims are needed" | into |
| 70 | APL/J array indexing | `A[1;;2]` style bracket-with-semicolons per axis; index origin `⎕IO` (0 or 1, default 1) is a *settable system variable* | one bracket, N semicolon-separated axis-selectors — addressing scales with array rank as a first-class idea, not nested nulls; verified: `⎕IO` really is a mutable global that redefines what every address in the workspace means ([APL Wiki, "Index origin"](https://aplwiki.com/wiki/Index_origin); [Dyalog docs, "IO"](https://help.dyalog.com/19.0/Content/Language/System%20Functions/io.htm)) | into |
| 71 | Clojure `get-in` | `(get-in m [:a :b 0])` | the **path itself is reified as a vector value** you can build, store, and pass around — not baked into concrete syntax at all | into |
| 72 | Elm/Haskell record dot-access via lenses (see also §M) | `record^.field1.field2` (via `lens`) | ordinary languages with *no* mutation add a whole optics library just to get "path" back — evidence paths and mutation are entangled | into |
| 73 | Excel/VBA object model paths | `Workbooks("Book1").Sheets("Sheet1").Range("A1")` | chained *method-call-shaped* addressing rather than punctuation-shaped — the "path" is a sentence of accessor calls | into |
| 74 | Terraform resource addressing | `module.vpc.aws_subnet.public[2]` | mixes **module namespace**, **resource type**, **resource name**, and **count/for_each index** in one dotted string — four different kinds of segment, visually uniform | into |
| 75 | Bazel/Buck labels | `//path/to/pkg:target_name` | `//` = repo root (always absolute, no relative form exists at all); `:` splits *directory* from *target-within-directory* | to+into |

## H. Version control & content addressing

| # | source | example | brief | scope |
|---|---|---|---|---|
| 76 | Git revision syntax | `HEAD~2^`, `main@{yesterday}`, `v1.0..v2.0`, `:/fix bug` | a whole **algebra**: `~n` = nth ancestor, `^n` = nth parent of a merge, `@{...}` = reflog/date query, `..`/`...` = range operators | into (of a graph, not a tree) |
| 77 | Git pathspec | `git log -- 'src/**/*.rs' ':!vendor'` | magic prefixes (`:!`, `:(glob)`, `:(icase)`) turn a path string into a **mini predicate language** for the working tree | into |
| 78 | Git object addressing | `HEAD:path/to/file.txt` | `:` again splits a *revision* selector from a *tree-path* selector — same glyph as #47, different domain, same "across" move | across |
| 79 | Content hashes as identity | git SHA blobs, IPFS CIDs, Nix store paths (`/nix/store/<hash>-name`) | the address **is** a cryptographic digest of the content — no separate "location," the name self-verifies | to (content-addressed) |
| 80 | Nix store paths | `/nix/store/9r…-glibc-2.35` | fs-shaped path where the leading segment is a hash of the *build inputs*, not the content — reproducibility encoded into the address itself | to |
| 81 | Mercurial changeset revsets | `ancestors(.) and not public()` | revision addressing as a **boolean query language** over the DAG, not a positional offset syntax at all | into |

## I. Databases, query DSLs, protocol field addressing

| # | source | example | brief | scope |
|---|---|---|---|---|
| 82 | SQL dotted qualification | `schema.table.column`, `db.schema.table` | strictly ordered containment, no wildcards, no predicates in the path itself — filtering lives entirely in `WHERE`, kept apart on purpose | into |
| 83 | MongoDB dot-notation queries | `{"address.city": "Provo"}`, `"items.$.qty"` | dots address into embedded documents *and* arrays uniformly; `$` is a **positional placeholder** meaning "the matched array element" | into |
| 84 | LDAP Distinguished Name | `cn=Alice,ou=People,dc=example,dc=com` | **read right-to-left as ascent** (most-general first) — the reverse ordering convention of nearly every other tree notation here | to |
| 85 | LDAP RDN multi-valued | `cn=Alice+ou=Sales,dc=example,dc=com` | `+` composes multiple attributes into *one* node-identifying segment — identity can be a compound key at a single tree level | into |
| 86 | SPARQL property paths | `?a foaf:knows+/foaf:name ?name` | regex-like operators (`+`, `*`, `?`, `|`, `^` for inverse) applied to graph-edge labels — "path" as a **regular expression over relationship types**, not positions | into |
| 87 | XBRL Dimensions 1.0 | a fact's context = base concept + N `(axis, member)` pairs against a declared hypercube (open or closed) | verified against the spec: addressing a fact requires a **base concept plus N orthogonal dimension-qualifiers**, validated against a hypercube that can be *open* (extra dimensions tolerated) or *closed* (must match exactly) — not a single descent chain at all, more like a composite database key with its own conformance rules ([XBRL Dimensions 1.0 spec](https://www.xbrl.org/specification/dimensions/rec-2012-01-25/dimensions-rec-2006-09-18+corrected-errata-2012-01-25-clean.html)) | into |
| 88 | Protobuf field numbers vs field paths | wire uses integer tags; `FieldMask`/reflection use dotted names (#59) | two *parallel* addressing systems for the same data — compact numeric for wire, human dotted for tooling — chosen per audience | into |
| 89 | Redis key patterns | `user:1000:profile`, `KEYS user:*` | `:` as pure convention (not enforced structure) turns a flat key-value store into a *simulated* hierarchy — the "path" is a social contract, not a parser rule | to |
| 90 | Cypher (Neo4j) path patterns | `(a)-[:KNOWS*1..3]->(b)`, `p = (a)-[]->(b)` | the query syntax **literally draws the graph shape** with ASCII art; `*1..3` bounds the traversal depth range inline | into |
| 91 | Datalog/Prolog path predicates | `path(X,Y) :- edge(X,Y). path(X,Y) :- edge(X,Z), path(Z,Y).` | "path" isn't a syntax at all here — it's a **user-defined recursive relation**; the addressing scheme is whatever you derive | into |
| 91a | SQL `SELECT`/`WHERE`/`JOIN` | `SELECT o.* FROM orders o JOIN customers c ON o.cust_id = c.id WHERE c.city = 'Provo'` | see the paradigm note below — addresses a **set matching a predicate**, and relates across tables by shared *value*, never by containment or position | into (declarative, set-based) |
| 91b | Relational algebra | selection σ, projection π, join ⋈, union ∪ | the formal ancestor of #91a — each operator is a **set-to-set transform**, and "address" only ever means "the subset satisfying this operator chain," never a single located cell | into |
| 91c | Prolog unification | `parent(tom, X), parent(X, bob)` | addressing-by-**pattern-matching against logical variables** — the "path" is discovered by the solver backtracking through facts/rules, not walked by the caller at all | into |
| 91d | LINQ (C#/.NET) | `from o in orders where o.Total > 100 select o.Customer.Name` | SQL's predicate/set model **embedded as a first-class expression in a general-purpose language**, type-checked against the object graph at compile time — the addressing and the host language share one type system | into |
| 91e | CODASYL / DBTG network-database navigation (pre-relational, 1970s) | `FIND NEXT MEMBER WITHIN owner-set` (one of the seven `FIND` formats) | verified: the DBTG model really does track a "current of set / current of run-unit" **currency indicator** per relationship, and every `FIND` implicitly reads and updates it — addressing as procedural navigation of physical pointers along paths the database designer pre-declared, which is exactly what the relational model (and declarative query languages generally, #91a–91d) was invented to escape ([CACM, "50 Years of Queries"](https://cacm.acm.org/research/50-years-of-queries/)) | into |

## J. Semantic web / RDF / knowledge graphs

| # | source | example | brief | scope |
|---|---|---|---|---|
| 92 | RDF triple + IRI subject/predicate/object | `<ex:Alice> <foaf:knows> <ex:Bob>` | there is no "path" primitive at all — addressing *emerges* from chaining triples; #86 (SPARQL paths) was invented precisely to compensate | into |
| 93 | JSON-LD `@context` + compact IRIs | `foaf:name` expands via a context map to a full IRI | the short form is not the real address — a **lookup table sits between the notation and the identity**, unlike almost everything else here | to |
| 94 | Wikidata property-path style queries | `wdt:P31/wdt:P279*` (instance-of / subclass-of-star) | same operator family as #86 applied to a specific huge public graph — `*` here means "climb the taxonomy arbitrarily far" | into |
| 95 | OWL/description-logic class expressions | `hasParent some (Person and hasChild min 2 Person)` | not a "path" to a node but a **path through logical constraints** — addresses a *set* defined intensionally, not a location extensionally | into |

## K. Spreadsheets

| # | source | example | brief | scope |
|---|---|---|---|---|
| 96 | A1 notation | `A1`, `$B$2`, `Sheet2!C3:C10` | column-as-letters + row-as-number is a **positional coordinate system disguised as an alphabet** — `$` toggles relative vs absolute per axis independently | to+into |
| 97 | R1C1 notation | `R[-1]C[2]` | pure relative-offset addressing — the *same cell reference* means something different depending on where the formula lives, by design | into |
| 98 | Named ranges | `=SUM(Revenue)` | indirection layer: a human name resolves to an A1 range — the formula never sees the coordinates at all | to |
| 99 | 3-D references across sheets | `=SUM(Sheet1:Sheet3!A1)` | a *range of sheets* as one axis, alongside the usual row/column axes — three dimensions of addressing in one expression | across |
| 100 | Google Sheets `QUERY`/`FILTER` array formulas | `=QUERY(A1:D100,"select A,B where C>10")` | SQL-shaped predicate query layered on top of A1 ranges — same across-two-notations move as #52/#57 | across |

## L. Regex, text streams, line/offset addressing

| # | source | example | brief | scope |
|---|---|---|---|---|
| 101 | `sed` addresses | `sed '2,5s/foo/bar/'`, `sed '/START/,/END/d'` | addresses are **line numbers or regex matches**, and a *range* is spelled as two addresses joined by `,` — no separate range operator needed | into |
| 102 | `grep`/`ripgrep` match output | `file.txt:42:col_offset: match` | addressing as a **byproduct of search**, not a lookup — you don't write the address, the tool hands it to you after the fact | into |
| 103 | Regex capture groups + backreferences | `(\d+)-(\d+)` / `\1` | numbered (or named, `(?<year>\d+)`) sub-addresses *within a single match* — a path into the match's own internal structure | into |
| 104 | AWK field references | `$1`, `$NF`, `$(NF-1)` | fields are addressed **by position with live arithmetic** in the subscript itself — the address can be a computed expression, not just a literal | into |
| 105 | `diff`/patch hunk headers | `@@ -12,7 +15,6 @@` | addresses a **region across two versions simultaneously** (old-start,len / new-start,len) — inherently a two-document "across" notation | across |
| 106 | RFC 5147 (`text/plain` fragments) | `#char=100,200`, `#line=5,10` | standardized URL fragments for addressing *into* plain text — the too-obscure-to-be-famous cousin of #19 | across |

## M. Pointer, lens, and optics libraries (functional programming)

| # | source | example | brief | scope |
|---|---|---|---|---|
| 107 | JSON Pointer (RFC 6901) | `/a/b/1`, `~0`/`~1` escapes for `~`/`/` | the escaping rule itself is the interesting part — a separator that appears in data forces a **two-character escape table**, a UDON-relevant trap | into |
| 108 | JSON Patch (RFC 6902) | `{"op":"replace","path":"/a/b","value":5}` | separates **operation** from **address** from **payload** as three orthogonal fields — never fuses them into one string | into |
| 109 | Relative JSON Pointer | `2/a/b` (go up 2 levels, then descend) | leading integer = ascent count, exactly like Python's leading dots (#32) but spelled as a number instead of repeated punctuation | into |
| 110 | Haskell `lens` library | `view (_1 . _2 . at "k") record` | **lenses compose with plain function composition** (`.`) — "path" isn't a string at all, it's a first-class, typed, composable *value* | into |
| 111 | Scala/Kotlin/Clojure "optics" (Monocle, Arrow) | same idea as #110, different host language | ports the get/set-both-ways idea broadly — a path that knows how to *write back*, not just read, is the recurring theme across this whole family | into |
| 112 | Prisms & traversals (optics vocabulary) | a lens that may fail to focus (Prism), or focuses on 0-or-many (Traversal) | worth surfacing because it names exactly UDON's `at`/`all`/`Maybe`-address distinction as **three different types of address**, not three runtime cases of one type | into |
| 113 | XPath-as-lens comparison point | (not a citation, an observation) | XPath's `[1]`, optics' `_1`, JSONPath's `[0]` are the *same idea* independently reinvented at least four times in this survey — strong signal it's a load-bearing primitive worth naming once well | into |
| 114 | Elm `Json.Decode` field-path decoders | `field "user" (field "name" string)` | the "path" is expressed as **nested decoder combinators**, not a string at all — address and validation/typing fused into one artifact | into |
| 115 | Zippers (Huet's zipper) | a data structure, not a string notation — a cursor with an explicit "path back to the root" as its own value | makes the **path a live, steppable object** (up/down/left/right) rather than a static descriptor — arguably closest prior art to "an address you can walk interactively" | into |

## N. Configuration languages & infra-as-code paths

| # | source | example | brief | scope |
|---|---|---|---|---|
| 116 | YAML anchors & aliases | `base: &defaults {a: 1}`  /  `<<: *defaults` | not a path at all — a **named pointer** planted at define-time and dereferenced at use-time, entirely separate mechanism from positional addressing | to (in-doc) |
| 117 | Ansible variable dotted access + Jinja | `{{ item.address.city }}`, `hostvars['web1']['ip']` | two interchangeable syntaxes for the *same* address (dot vs bracket) coexisting in one templating language, chosen by whether the key is a valid identifier | into |
| 118 | Kubernetes JSONPath (`kubectl -o jsonpath`) | `{.items[*].metadata.name}` | JSONPath (#55) re-skinned with curly-brace wrapping as the CLI's own convention — a borrowed notation with a house style bolted on | into |
| 119 | Kustomize/Helm strategic-merge paths | `spec.template.spec.containers[0].image` | positional array indexing in a config-patch context, where "which container" is usually better expressed by name — a known pain point worth noting as a **counter-example** (positional access failing users) | into |
| 120 | Dhall / Nix attribute-path selection | `config.services.nginx.enable` | dotted attribute access over a **lazily-evaluated, typed configuration language** rather than plain data — the address can traverse functions, not just values | into |
| 121 | .env / dotenv key namespacing | `DATABASE_URL`, `AWS__S3__BUCKET` (double-underscore-as-hierarchy convention) | flat namespace faking hierarchy through a **naming convention** (like #89's Redis colons) because the format itself has no nesting at all | to |
| 122 | Windows Registry paths | `HKEY_LOCAL_MACHINE\Software\Vendor\App\Setting` | tree-shaped like a filesystem, but the **leaf is a typed value with its own name**, not a file — registry "key" vs "value" is a real semantic split worth noting against UDON's own key/value/child question | into |
| 123 | macOS `defaults`/plist key paths | `defaults read com.apple.finder AppleShowAllFiles` | reverse-DNS bundle-ID as root (same convention as #33/#45), then a flat key — shallow by design, unlike registry's arbitrary depth | to |

## O. DNS & network addressing

| # | source | example | brief | scope |
|---|---|---|---|---|
| 124 | DNS names | `www.example.com.` | **read right-to-left like LDAP (#84)**: most-general (root, the trailing dot) first — hierarchy direction is opposite to filesystem convention | to |
| 125 | DNS SRV/TXT record "paths" as service discovery | `_sip._tcp.example.com` | underscore-prefixed segments encode **service metadata inline in the name**, not as separate fields | to |
| 126 | CIDR notation | `192.168.1.0/24` | the `/`-suffix addresses a **range**, not a point — a whole different job (subnet membership) wearing a path-like separator | into (of address space) |
| 127 | MAC/OUI addressing | `00:1A:2B:3C:4D:5E` | flat, non-hierarchical, colon-separated — included as a useful **negative example**: looks path-shaped, carries zero tree semantics | to (flat identity) |

## P. Esoteric, historical, and cautionary systems

| # | source | example | brief | scope |
|---|---|---|---|---|
| 128 | Xanadu "tumbler" addressing (Ted Nelson; system credited to Mark Miller & Roger Gregory) | a **transfinite-decimal** address (`Literary Machines`, 1981) that locates a document/version/span, all at once, at unbounded precision | verified: tumblers use *transfinite calculus* — not a fixed number of segments but arbitrary-depth decimal insertion, so any span, at any granularity, in any version, gets an address without ever running out of room or renumbering neighbors. Conceived **bidirectional, versioned, royalty-tracking** links decades before URLs — the direct ideological ancestor of #19/#41/#52's "across" seam | across |
| 129 | HyTime (ISO/IEC 10744) | SGML-based hyperlinking/addressing standard predating XPointer | multiple independent **addressing architectures** (location ladders) coexisting in one standard — an early "collection of path forms," directly analogous to what this ideation is considering | across |
| 130 | Gopher menu paths | `selector-string` inside a Gopher item, resolved per-server | the "path" is an **opaque server-defined string** — the protocol deliberately does not standardize its shape, only its role | to |
| 131 | HyperCard "path" (card/stack references) | `card "Home" of stack "MyStack"` | addressing phrased as **English-like prose sentences**, not punctuation — an actual shipped precedent for prose-flavored addressing | to |
| 132 | COBOL `OCCURS`/table indexing with named indices | `MOVE X TO TABLE-ENTRY(WS-IDX)` | indices are **named, typed, and separately declared** from the table — addressing-as-a-managed-variable rather than an inline literal | into |
| 133 | APL "index origin" ambiguity (0 vs 1, configurable) | `⎕IO←0` changes what `A[1]` means globally | included as a cautionary tale: an **environment-global setting silently changes what every address in the program means** — worth avoiding on purpose | into |
| 134 | Smalltalk message-path chains | `anObject at: #key put: value` | addressing expressed as **keyword messages**, not punctuation at all — closest kin to Excel's method-chain style (#73) | into |
| 135 | INTERCAL / esolang addressing (as a genuine negative-space marker) | deliberately obtuse addressing as satire of C-family conventions | worth naming only as the boundary case: a reminder that "path syntax" is a design choice with a huge possibility space, most of which is bad on purpose | — |

## Q. Domain-specific notations (science, law, library science, music)

| # | source | example | brief | scope |
|---|---|---|---|---|
| 136 | SMILES (chemistry) | `CC(=O)Oc1ccccc1C(=O)O` (aspirin) | addresses **molecular structure** via a depth-first traversal string with ring-closure digits as backreferences — a graph serialized as a path notation | into |
| 137 | Genomic loci | `chr7:117,559,590-117,559,591`, HGVS `NM_000546.6:c.215C>G` | coordinate-range addressing on one system (chromosome:position), and a **completely different mutation-delta notation** (HGVS) for the same underlying object — two path languages for two audiences, real-world precedent for UDON's "collection, not one syntax" | to+into |
| 138 | Legal citation (Bluebook-style) | `42 U.S.C. § 1983`, `Roe v. Wade, 410 U.S. 113, 115 (1973)` | volume-source-section-pinpoint — a citation is simultaneously an **address (to the reporter volume/page) and a hierarchical descent (into a specific holding)** | across |
| 139 | Bible/scripture references | `John 3:16`, `1 Ne. 3:7` | book-chapter:verse — a three-level fixed hierarchy so ubiquitous its `:` convention likely shaped how programmers *expect* a "locator:sub-locator" split to read | into |
| 140 | Dewey Decimal / LC call numbers | `823.912 W365h` | encodes **classification** (a taxonomy position) and **shelf-location** (a physical address) in the same string — another real "across" precedent worth studying | across |
| 141 | Music: measure/beat addressing | `mm. 12–14, beat 3` (rehearsal marks: `[B]+4`) | two competing addressing systems in live use (absolute measure count vs. rehearsal-mark-plus-offset) for the *same* score — direct precedent for "identity anchor + relative offset" as a normal, expected combination | into |
| 142 | Chess notation (algebraic) | `Nf3`, `O-O`, `Qxe7+` | addresses a **board coordinate** but the notation is actually move-centric (piece + destination), not a pure location — the "address" only fully resolves given the position's history | into |
| 143 | ISO 8601 date/time as an addressing axis | `2026-07-23T14:00/P1D` (interval), `2026-W30` (week) | a **path through time**: year→month→day→hour is exactly a descent chain, and the standard even defines interval and repeat notations — directly relevant to the seed's own "time dimension" open question | into |

## R. AI/agent tooling & code-intelligence addressing (closest kin to UDON's own use case)

| # | source | example | brief | scope |
|---|---|---|---|---|
| 144 | LSP `textDocument/references` | returns a list of `{uri, range}` pairs | addressing as **output**, not input — the "path" is what the tool hands back after a semantic (not textual) resolution; `all()` in the seed doc maps directly onto this | to+into |
| 145 | tree-sitter queries (`.scm`) | `(function_item name: (identifier) @name)` | S-expression **pattern with named captures** over a concrete syntax tree — closest existing precedent to the seed's family (D) AST-search-and-capture idea | into |
| 146 | Language Server `workspace/symbol` fuzzy query | free-text query resolved to symbol locations | addressing **by approximate name match** across an entire project, not by structural path at all — a third mode beyond exact-path and predicate-filter | to |
| 147 | Semantic/vector-search "chunk IDs" | `doc-42#chunk-7` (convention varies by system) | address is **derived from a chunking policy the retriever chose**, not authored by a human — directly relevant to UDON's self-chunking claim in its own README | across |
| 148 | `git blame` line-range provenance | `git blame -L 40,60 file.rs` | addresses a **line range for the purpose of asking "who/when"**, not "what" — a path whose payload is history metadata, not content | into |
| 149 | Jupyter/notebook cell IDs | persistent per-cell UUID, independent of cell position/order | addresses cells by **stable identity survive-reorder**, a direct precedent for "identity, not position" (2c in the seed doc) already shipping in a widely-used tool | to |
| 150 | OpenTelemetry trace/span IDs + `traceparent` header | `00-<trace-id>-<span-id>-01` | addresses a **position within a distributed causal graph**, propagated across process/network boundaries — a "path" whose segments are IDs, not names, and whose structure is a tree discovered at runtime, not declared upfront | into |

## S. Wikis, hypertext, and cross-document reference

| # | source | example | brief | scope |
|---|---|---|---|---|
| 151 | Wikilinks | `[[Page Name#Section|display text]]` | **exactly** the seed doc's own §0 "across" example — page-locate plus in-page-descend plus a display override, all optional and composable | across |
| 152 | Obsidian block references | `[[Note#^block-id]]` | addresses a **specific paragraph by an author-assigned stable ID**, not a heading or position — closest wiki-world precedent to "identity survives a rewrite of the text around it" | across |
| 153 | MediaWiki transclusion | `{{Template:Infobox|param=value}}` | the "address" *is* an insertion point, and the content it pulls in is itself parametrized — transclusion is addressing-plus-substitution in one gesture | across |
| 154 | Zettelkasten/Luhmann ID chains | `21/3d7` (branch/insert notation, historical) | addresses a note by its **position in an ever-branching insertion sequence**, decided at creation time and never renumbered — an analog precedent for stable, append-friendly identity keys | to |
| 155 | Git-based wiki page paths + anchors combined (GitHub wikis, Docusaurus) | `docs/guide/setup.md#installing` | fs-path-to plus markdown-heading-into, both borrowed wholesale rather than co-designed — an example of the "seam" being solved by just gluing two existing notations together with `#` | across |

## T. Geographic, postal, and physical-world addressing

| # | source | example | brief | scope |
|---|---|---|---|---|
| 156 | Postal address | street → city → region → postal-code → country | hierarchical **in principle**, but real-world postal addresses are notoriously irregular and country-specific — a cautionary example against assuming any hierarchy is clean everywhere | to |
| 157 | Plus Codes (Google Open Location Code) | `8FVC9G8F+5W` | **no reference to any existing hierarchy at all** — a self-contained grid code, offered as a counter-model to every "descend a namespace" notation in this survey | to |
| 158 | what3words | `///filled.count.soap` | three arbitrary dictionary words map to a 3m×3m grid cell — addressing optimized entirely for **human memorability**, not structure or composability | to |
| 159 | Latitude/longitude | `40.7128° N, 74.0060° W` | two independent, unbounded-precision coordinates — no discrete "levels," addressing by **continuous** value rather than discrete descent | to |
| 160 | GeoJSON/Well-Known Text nested geometry | `MULTIPOLYGON(((...),(...)))` | addressing *shape*, not point — nesting here means "hole in a polygon" or "member of a collection," a structural relationship with no analog in this survey's other trees | into |

## U. Robotics, CAD, and 3-D scene graphs

| # | source | example | brief | scope |
|---|---|---|---|---|
| 161 | ROS topic/node namespaces | `/robot1/arm/joint_states` | fs-shaped `/`-hierarchy repurposed for **pub/sub channel naming**, not storage location at all | to |
| 162 | URDF/robot kinematic chains | `base_link → shoulder → elbow → wrist` (joint tree) | the "path" **is** a physical chain of rigid-body transforms — descending the tree literally means composing coordinate transforms, address and computation fused | into |
| 163 | USD (Pixar Universal Scene Description) prim paths | `/World/Characters/Robot/Arm/Hand` | fs-shaped scene-graph addressing with **layered composition** (references, overrides, variants) stacked on top of the plain path — worth studying for the "collection of forms over one tree" idea directly | to+into |
| 164 | X11 window hierarchy | root window → children, addressed by opaque XIDs, not names | a real GUI tree with **no human-readable path notation at all** — everything is numeric handles; included as a counter-example of a tree that never grew a path language | to (flat IDs only) |
| 165 | CSS `:nth-child`/DOM tree position as a "path" (XPath-adjacent) | already covered by #53; noted here for the "physical tree vs semantic tree" contrast with #162's kinematic chain | into |

## V. Games & virtual worlds

| # | source | example | brief | scope |
|---|---|---|---|---|
| 166 | Minecraft coordinates + dimension | `X: 120, Y: 64, Z: -35 (Overworld)` | absolute 3-axis coordinates **plus a separate discrete "dimension" selector** that isn't spatial at all — a hybrid of continuous and enumerated addressing in one conceptual "location" | to |
| 167 | Unity/Unreal scene-graph transform hierarchy | `Root/Player/Camera` (GameObject parenting) | same idea as #163 in a different ecosystem, reinvented independently — more evidence scene-graph path notation is a convergent, load-bearing idea | into |
| 168 | Save-file "slot" addressing (informal convention across many games) | `save3/chapter2/checkpoint-b` | ad hoc, per-game, almost never standardized — included as a reminder that most domains never got a *shared* path notation at all; UDON choosing one deliberately is the exception, not the norm | to |

## W. Formal / academic theory of paths and addressing

A second pass, aimed specifically at where the *theory* of addressing lives
rather than more notations in the wild. Two threads here land directly on
open questions in the seed doc, flagged where relevant; citations are given
per row since this is literature, not folklore.

| # | source | citation | brief | scope |
|---|---|---|---|---|
| 169 | Term-rewriting "positions" | Baader & Nipkow, *Term Rewriting and All That* (1998); standard TRS formalization — [overview](https://www.sciencedirect.com/topics/computer-science/term-rewriting-systems) | the formal ancestor of *every* tree-path notation in this survey: `Pos(t)` is defined inductively as `{ε} ∪ ⋃ᵢ i·Pos(tᵢ)` — a position is literally **a string of child-indices**, root is `ε` (the empty sequence), and `t\|ₚ` denotes "the subterm of `t` at position `p`." XPath's `[1]`, a lens's `_1`, a JSON Pointer's `/1` are all, formally, positions in this exact sense, independently reinvented | into |
| 170 | Occurrence vs. position | same TRS literature | a subtlety worth naming on its own: a **position** is *where*; an **occurrence** is "there exists a position `π` where `t\|π = s`" — i.e. occurrence is existential over positions. Several ordinary-language uses of "path" in this survey (e.g. "does X occur in the document") are really occurrence-questions wearing position-shaped syntax | into |
| 171 | Lens laws (get–put / put–get / put–put) | Foster, Greenwald, Moore, Pierce, Schmitt, "Combinators for Bidirectional Tree Transformations," POPL 2005 / *TOPLAS* 29(3), 2007 — [paper](https://www.cs.cornell.edu/~jnfoster/papers/lenses.pdf) | a lens is formally `(S, V, get: S→V, put: S×V→S)` obeying three equations: **GetPut** `put(s, get(s)) = s` (getting then putting back changes nothing), **PutGet** `get(put(s,v)) = v` (what you put is what you get back), and **PutPut** `put(put(s,v₁),v₂) = put(s,v₂)` (a later write completely supersedes an earlier one to the same place). **This is the seed doc's round-trip / edit-write-back requirement, already formalized with equations you can check a design against** — see Notes | across (the get/put pair spans read and write over one address) |
| 172 | Profunctor optics & the optics hierarchy | Pickering, Gibbons, Wu, "Profunctor Optics: Modular Data Accessors," *Programming Journal* 1(2) art. 7, 2017; Riley, "Categories of Optics," arXiv:1809.00738, 2018 — [paper](https://arxiv.org/pdf/1809.00738) | reformulates lenses (and prisms, traversals, etc.) as **polymorphic functions over profunctors**, which makes composition just ordinary function composition and — the useful part here — makes the *lattice of optics kinds* precise: **Lens** (exactly-one, always succeeds), **Prism** (zero-or-one, may fail to focus, e.g. a sum-type case), **Traversal** (zero-or-many). **This is the seed doc's `at`/`all`/partial-match distinction (2d/2e/2f), independently arrived at, stated as a typed hierarchy rather than a set of runtime error codes** — see Notes | into |
| 173 | Regular path queries (RPQ) & conjunctive RPQ (CRPQ) | Cruz, Mendelzon, Wood, "A Graphical Query Language Supporting Recursion," SIGMOD Record 1987; survey: Libkin et al., ["Querying Graphs"](https://homepages.inf.ed.ac.uk/libkin/papers/jacm-qgp.pdf) | the formal ancestor of SPARQL property paths (#86), Cypher `*1..3` (#90), and Wikidata's `wdt:P279*` (#94): an RPQ selects node-pairs `(x,y)` connected by *some* path whose edge-label sequence matches a regular expression; CRPQ conjoins several RPQ atoms and allows existentially-quantified intermediate nodes. Complexity result worth carrying: **evaluating even simple RPQs under *simple-path* semantics (no repeated nodes) is NP-complete** — "find a path matching this shape with no cycles" is not always cheap, a real cost to keep in mind if UDON's own path language ever grows a `+`/`*` depth operator | into |
| 174 | Conditional XPath / GXPath — navigational logic on trees and graphs | Marx, "Conditional XPath, the First Order Complete XPath Dialect," PODS 2004 — [paper](https://pages.di.unipi.it/ghelli/didattica/SSD/xpath/marx.conditional.pods04.pdf); Libkin/Martens/Vrgoc line of work generalizing XPath axes to graphs | shows plain navigational XPath (axes + `[]` predicates, no recursion) is **provably weaker than first-order logic** on trees — some tree properties simply cannot be expressed by descending and filtering, no matter how the predicates are combined. Conditional XPath adds a bounded "Until" axis `(child::n[F])+` to close the gap. Directly useful as a **ceiling check**: before UDON's relational selector (family A) claims to answer "any question a schema author could ask," this is the formal notion of what that would require and where plain descent-plus-predicate falls short | into |
| 175 | Separation logic — the heap as an addressing domain | Reynolds, "Separation Logic: A Logic for Shared Mutable Data Structures," LICS 2002 — [paper](https://www.cs.cmu.edu/~jcr/seplogic.pdf); O'Hearn et al. | a genuinely different addressing paradigm from everything else in this survey: the core assertion `e ↦ e'` means "the heap consists of **exactly one cell**, at address `e`, containing `e'`" — and the separating conjunction `P * Q` asserts `P` and `Q` hold over **disjoint** parts of the heap. There is no descent, no tree, no hierarchy at all — addressing is about *ownership and disjointness of a flat set of cells*, and the entire logic exists to let you reason locally ("the Frame Rule") about the part of the heap your code touches without describing the part it doesn't. See Notes for why this is worth carrying into a multi-writer, guarded-edit context like UDON's | to (flat cell identity, not hierarchical) |
| 176 | Naming and binding — the classical distributed-systems theory | Saltzer, "Naming and Binding of Objects," in *Operating Systems: An Advanced Course*, LNCS 60, 1978 — [PDF](https://web.mit.edu/Saltzer/www/publications/nbo/nbo.pdf) | the foundational treatment of **name resolution as a chain of context-relative bindings** rather than a single lookup: a name is only meaningful *relative to a context*, resolving a name can yield another name (requiring further resolution) rather than a value, and "the same name" can be bound differently in different contexts at the same time. This is the formal vocabulary behind why `~`, `⊤`/`¤`, and relative-vs-absolute paths (survey rows #1–#17) all behave the way they do — every anchor-kind choice in the seed doc's §2a is, in Saltzer's terms, a choice of *naming context* | to |
| 177 | Uniform naming across an entire OS — the Plan 9 thesis | Pike, Presotto, Thompson, Trickey, Winterbottom, "The Use of Name Spaces in Plan 9," *ACM SIGOPS OSR* 27(2), 1993 — [paper](https://9p.io/sys/doc/names.html) | the fully-realized version of survey row #8: argues (and ships) that **per-process, per-user mutable namespaces** — not a single global tree — should be the OS's only addressing primitive, with every resource (files, devices, network connections, other processes) mounted into whatever view a process needs. The theoretical payoff for UDON: it's a working existence proof that "one addressing grammar for everything" (the seed doc §0's resource-as-node hypothesis) doesn't require a single universal namespace, only a **uniform mounting/binding discipline** — namespaces can differ per-viewer while the addressing *grammar* stays one thing | to |
| 178 | Dexter hypertext reference model | Halasz & Schwartz, "The Dexter Hypertext Reference Model," *CACM* 37(2), 1994, pp. 30–39 — [ACM link](https://dl.acm.org/doi/10.1145/175235.175237) | a deliberately **layered** model (storage layer / anchoring layer / within-component layer) built explicitly so many different hypertext systems' addressing schemes could be compared and interchanged — its "composite" components can nest arbitrarily and links can point at other links, not just at content. The closest formal cousin to the seed doc's "coherent collection of path forms rather than one canonical syntax" (§0/§3): Dexter's whole reason to exist was standardizing *interoperability between different addressing schemes*, not picking one | across |
| 179 | Semistructured-data path expressions — Lorel/OEM and UnQL | Abiteboul, Quass, McHugh, Widom, Wiener, "The Lorel Query Language for Semistructured Data," *Int'l J. on Digital Libraries* 1(1), 1997; Buneman, Davidson, Hillebrand, Suciu, "A Query Language and Optimization Techniques for Unstructured Data," SIGMOD 1996 | both built specifically for data **without a known schema in advance** — Lorel's headline move is aggressive **coercion** (a path expression matches loosely typed/absent structure rather than erroring) so a query can be written before the author knows the exact shape; UnQL's graph model (cyclic, edge-labeled) generalizes trees outright. Directly relevant to the seed doc's 2b falsifier ("prose-heavy docs where keys are unnatural") — this is the literature that already lived through "the schema isn't reliably known when you write the path" and answered it with fuzzy/coercive matching rather than strict typing | into |
| 180 | Content-addressed / self-certifying naming theory | Merkle DAGs (per-node hash of payload + children's hashes) as used in IPFS — [spec](https://github.com/ipfs/specs/blob/main/MERKLE_DAG.md); Mazières & Kaashoek's *self-certifying* filesystem naming (SFS, 1999, cited via the self-certifying-namespace literature) | formalizes rows #27–#29/#79–#80 as a *naming theory*, not just a hash trick: a name is **self-certifying** when possessing the name alone (no separate trust authority, no DNS-like registry) lets you verify you got the right content — the address and the integrity check are the same string. Worth holding against the seed doc's staleness/freshness work (§2h): a content-hash *is* a formally-grounded freshness token, not just an engineering convenience | to |
| 181 | De Bruijn indices — nameless addressing of bound variables | de Bruijn, "Lambda Calculus Notation with Nameless Dummies...," *Indagationes Mathematicae* 75(5), 1972, pp. 381–392 | replaces a bound variable's *name* with a **number counting binders outward** to its own binder — makes α-equivalent terms syntactically identical, at the cost of every address being context-relative (renumber on any restructuring). The sharpest illustration in this whole survey of the **identity-vs-position tradeoff cutting the *other* way**: here positional addressing is chosen *specifically* to erase an identity (the variable's name) that would otherwise cause spurious inequality — worth holding as the counter-case to 2c's "identity almost always wins" lean | into |
| 182 | Path types / identity-as-path (homotopy type theory) | Martin-Löf's identity type, reinterpreted; Awodey, Warren, Voevodsky et al., *Homotopy Type Theory* (2013 book / HoTT project) | the deepest reframe in this pass: two proofs that `a = b` are literally called **paths** from `a` to `b`, and *composing two proofs of equality* is formally the same operation as *composing two paths* in topology (this is not a metaphor in the theory — it's a theorem, via the groupoid structure identity types carry). Offered as a genuine curiosity rather than a design lever: it suggests "path" as a word was always going to be this overloaded, because at the deepest formal level available, *equality itself* and *a route between two points* are the same mathematical object | — (a different sense of "path" entirely — worth naming, not importing) |

---

## Notes

Numbers below expand on rows where the one-line `brief` undersells the
distinctive mental model. Rows not listed here are adequately covered by
their table row alone.

**7 (VMS).** Baking a version number into the address itself means "the same
file" and "this exact revision of the file" are the *same kind of name*,
just with an optional suffix — closer to git's `file@rev` than to any
filesystem in common use today. Worth holding against UDON's own
content-hash/staleness discussion (§2h of the seed doc).

**8 (Plan 9).** The radical move isn't the syntax (it's just `/`-paths) —
it's the *policy*: absolutely everything, including running processes and
network connections, is exposed as something mountable into the namespace.
"Path" stops being a filesystem feature and becomes the *only* addressing
primitive the OS has. If UdOn's resource-as-node question (§0 of the seed
doc) resolves toward "everything is one tree," Plan 9 is the fully-realized
version of that bet and worth reading about directly.

**23/78 (`!` and `:` as boundary markers).** Two completely unrelated
ecosystems (JAR URLs, git revision syntax) independently reached for a
single reserved character to mark "everything after this point is a
different addressing grammar." That convergence is itself a data point:
composing two path-languages seems to want exactly one boundary glyph, not
a whole sub-grammar.

**32/109 (leading dots vs leading integer for ascent).** Python spells "go
up two levels" as `..` (repeated punctuation, unbounded by construction);
Relative JSON Pointer spells the same idea as a leading `2` (a count,
bounded and directly reads as a number). Two solutions to the identical
problem, worth comparing side by side rather than defaulting to whichever
one is more familiar.

**55/56/57 (JSONPath / jq / yq family).** These three sit on a spectrum from
"a path syntax with query-ish extras" (JSONPath) to "a query language whose
central construct happens to look like a path" (jq) to "jq's model plus
multi-document plus fs-glob-as-input" (yq). The jq end is the most relevant
provocation for UDON: it never treats "select a place" and "transform what's
there" as different operations syntactically, which is very close to the
seed doc's family (D) AST-search/transform idea.

**70 (APL/J).** Flagged as recall-not-verified on the exact bracket/semicolon
punctuation, but the *idea* — one addressing operator whose arity scales
automatically with the array's rank, rather than nesting brackets once per
dimension — is worth carrying regardless of the precise syntax; it's a
genuinely different way to think about "how many `[…]` do I need" than any
C-family language offers.

**84/124 (LDAP DN and DNS both read right-to-left).** Both are
*naming-authority-first* hierarchies — you name the broadest scope first,
narrowest last — which is the mirror image of every filesystem-style
notation in this survey (broadest first *when read left to right*, i.e.
same direction, but LDAP/DNS put the *narrowest* thing first in the string
and ascend). Worth being deliberate about which reading direction UDON's
own root-anchored forms (`⊤`, `¤`) commit to, since both conventions have
large, successful precedent.

**107 (JSON Pointer escaping).** `~0` for literal `~` and `~1` for literal
`/` is a real, shipped answer to exactly the "does the separator collide
with data" problem the seed doc flags for UDON's own `/` (§2a, "`/`
collision-or-rhyme"). Worth reading the RFC section directly before UDON
settles its own escaping story, if any.

**115 (Zippers).** The one entry in this survey where the "path" is not a
string or a query at all but a *data structure you carry around and step*.
If UDON ever wants an interactive/skeleton-navigation mode (the seed doc's
2c "an address you can walk"), Huet's zipper is the classical name for
exactly that shape of thing, independent of any concrete syntax.

**128/129 (Xanadu, HyTime).** Both predate the web and both explicitly
designed for *bidirectional*, *versioned*, and in HyTime's case *plural*
addressing architectures rather than committing to one. HyTime in
particular shipped "multiple coexisting addressing schemes in one
standard" as a deliberate design, which is close kin to the seed doc's own
"a coherent collection of path forms" stance — worth reading as prior art
for that exact framing, not just for syntax ideas.

**137 (genomic loci).** The two notations for the same object (positional
`chr:start-end` vs. delta-based HGVS `c.215C>G`) exist because they serve
different questions — "where is it" vs. "what changed relative to a
reference." That's a clean real-world case of "one referent, two
addressing paradigms, both alive in production," directly bearing on the
seed doc's "collection, not one syntax" framing.

**143 (ISO 8601 as address).** Worth flagging because the seed doc's §5
"orthogonal/open" list names "paths with a time dimension" as an unexplored
slot — ISO 8601 already demonstrates that a **descent chain and a duration/
repeat notation can share one small grammar**, which might transfer
directly if UDON ever wants time-addressed content (e.g. a log or journal
document).

**147/149 (chunk IDs, notebook cell IDs).** Both are shipped precedent for
exactly the "stable identity that survives structural change" property the
seed doc names as the single word tying together everything paths need to
do (§1, "stability"). Neither is exotic — they're both in daily production
use — which is a point in favor of treating identity-stability as the
*obvious* baseline requirement rather than an ambitious stretch goal.

**82/91a–91e (the relational/declarative paradigm as a whole).** Worth
calling out as a group because it's a genuinely different *kind* of
addressing than everything else in this survey, not just another syntax
variant. Every tree/graph notation above (XPath, jq, filesystem paths, lens
composition, wikilinks…) shares one assumption: you **walk** to a place —
descend, follow a pointer, step through a hierarchy — and the address
*describes the walk*. The relational family inverts that: you **describe a
predicate** (`WHERE city = 'Provo'`), and the address is *whatever set of
things happens to satisfy it* — there is no walk, no single "place," and
the same query can match zero, one, or a thousand rows with no special
casing between those outcomes. Joins compound this: two things relate not
because one *contains* the other (the assumption baked into `/`, `.`, `::`,
`|>` throughout this whole survey) but because they **share a value** —
`orders.cust_id = customers.id` is a relationship the schema author
declares, invisible in either table's own address. CODASYL (#91e) is the
useful foil: it's the *pointer-walking* way of doing what relational
algebra does declaratively, and the field moved away from it on purpose —
worth reading as a cautionary tale if UDON's own path design ever drifts
toward "the address encodes exactly how to physically get there." LINQ
(#91d) and Datalog/Prolog (#91/#91c) both show the predicate-based model
surviving transplantation into very different host contexts (a
general-purpose OO language; a logic-programming solver), which suggests
the paradigm is genuinely load-bearing rather than SQL-specific. Directly
relevant to the seed doc's own §2f "predicates beyond traits+keys" open
item (attr-value filters wanted ~4× in one scenario day) — that's exactly
the relational mental model knocking on UDON's door in miniature, and this
family is the deep well to draw from if that pressure grows rather than
stays a "maybe a second-class filter."

**163 (USD prim paths).** Possibly the single most relevant precedent in
this whole survey for the seed doc's family-(E)/family-(A) composition
question: USD explicitly layers *composition* (references, variants,
overrides — different "documents" contributing to one addressed prim) on
top of a plain hierarchical path, and the tooling around it has had over a
decade of production hardening at Pixar/Nvidia/etc. Worth a deeper look if
anyone spikes the "resource-as-node, one grammar at every altitude" bet
from §0 of the seed doc.

**171 (lens laws) — direct hit on the seed doc's round-trip requirement.**
The seed doc's §1 table names "round-trip / span-splice" as its own area
with "a per-node byte-span map" as the concrete ask, and §2h names
re-resolve-at-write-time as a live requirement — but nowhere does the seed
doc state a *checkable equation* for "editing through an address behaves
correctly." GetPut/PutGet/PutPut are exactly that: three equations a
concrete UDON path implementation (whatever family ends up doing writes)
could be tested against directly, today, independent of syntax. Worth
being blunt about the gap this exposes: PutPut in particular
("a later write to the same address completely supersedes an earlier one,
nothing in between leaks through") is a genuine, non-obvious design
commitment — it says an address does *not* accumulate a sequence of edits,
it names a slot whose entire history collapses to "last write wins" —
and the seed doc hasn't yet said whether that's the intended semantics for
UDON's guarded edit (2i touches wire/sugar questions but not this).
Recommending this get read as primary source, not just cited, before any
write-path prototype ships.

**172 (profunctor optics hierarchy) — the seed doc's 2d/2e cardinality
question, already named as a type lattice.** The seed doc's `at`
(exactly-one-or-error) / `all` (explicit plural) split, plus the open
"stacked-attribute … error-if-plural?" question in 2e, is *precisely* the
Lens/Prism/Traversal distinction — except the optics literature treats it
as three different **types**, not one type with three runtime failure
modes layered on top. That reframe might be worth carrying into the
design conversation directly: instead of "one address type, with
`PathNotFound`/`PathNotUnique` as error variants" (2d's current framing),
the alternative is "the *shape of the query itself* determines which of
three address-kinds you get back, known before resolution, not after."
Whether that's better for UDON is a real design question, not a foregone
conclusion — optics gets it from a statically-typed host language (Haskell)
UDON doesn't have — but the vocabulary (Lens vs. Prism vs. Traversal) is
worth having on hand as a naming source regardless of which way the
mutation-vs-type-safety tradeoff falls.

**175 (separation logic) — a genuinely different formal model for the
multi-writer problem.** The seed doc's §2h ("stability & freshness,
multi-agent reality") is wrestling with a problem separation logic was
built to solve formally: *how do you reason locally about the part of a
shared mutable structure your operation touches, without describing (or
being invalidated by) everything else?* The Frame Rule — "if a piece of
code is correct for a small heaplet, it's still correct when that heaplet
sits inside a larger heap it doesn't touch" — is the formal shape of
"staleness scoped to the addressed subtree, not file-level" (2h, already
evidenced from the demand corpus independently). This is offered as a
different *kind* of prior art than everything else in this survey: not a
notation to borrow syntax from, but a proof technique that names the
exact property ("disjointness of concurrent writers' footprints") the
seed doc is reaching for empirically. Worth a closer read if the guarded-
edit concurrency story ever needs to be stated as a correctness argument
rather than a set of scenarios.

**176/177 (Saltzer; Plan 9 paper) — the vocabulary for the seed doc's own
open anchor-kind question.** Saltzer's framing — a name only means
something *relative to a context*, and resolving a name can hand back
another name requiring further resolution — is the precise formal
language for what the seed doc's §2a is already doing informally (relative
/ absolute / home / document-root / project-root as five different
*contexts*, not five flavors of the same thing). The Plan 9 paper is the
fully-worked *systems* answer: rather than one global root, every viewer
(process) can be handed its own namespace, built by mounting/binding
resources into whatever view it needs — worth reading directly if the
seed doc's §0 "resource-as-node, one grammar at every altitude" bet gets
spiked, since Plan 9 is the closest real, shipped, decades-hardened system
that took exactly that bet and shows what has to be true for it to work
(a uniform bind/mount discipline, not a single universal tree).

**179 (Lorel/UnQL) — direct prior art for the seed doc's own falsifier.**
Section 2b of the seed doc names its own weak point: "stress relational-
first against … prose-heavy docs where keys are unnatural." Lorel is
built for exactly that condition (semistructured data where the schema —
UDON's equivalent would be "which attributes/traits a given node
actually has" — isn't reliably knowable in advance) and its answer is
**coercion**: a path expression that would be a type error or a hard
miss in a strictly-typed query language instead matches loosely and
returns something. That's a concrete alternative worth holding next to
UDON's own error-loudly stance (2d, "silently empty leaves the agent
unable to tell absent from wrong-path") — Lorel picked permissiveness
where UDON's demand evidence is currently leaning toward strictness, and
that's a real, load-bearing tradeoff with prior art on both sides now
nameable.

---

## A few observations that surprised me while ranging around

These aren't rows — they're patterns that showed up repeatedly across
unrelated domains, offered because the brief asked for surprises, not just
coverage:

- **The identity-vs-position tension (seed doc §2c) is not new or UDON-
  specific** — it shows up explicitly as a *named, first-class type
  distinction* in the optics/lens literature (Lens vs. Prism vs. Traversal,
  #110–112), and implicitly everywhere else (git pathspec magic, R1C1 vs
  A1, Jupyter cell IDs). Every mature system in this survey eventually grew
  a way to say "I mean the *thing*, not the *slot*" — it's a near-universal
  pressure, not a UDON-only design worry.
- **Right-to-left hierarchy reading (LDAP, DNS) is a real, successful
  alternative** to the left-to-right convention every filesystem and
  programming-language notation in this survey uses — worth at least
  naming as a considered-and-rejected option rather than never considering
  it.
- **"Across" (seed doc §0) keeps getting solved the same lazy-but-effective
  way**: pick one reserved glyph (`#`, `!`, `:`) as a hard boundary and let
  two *otherwise-unrelated* grammars sit on either side of it, rather than
  designing one unified grammar that spans both. URLs+fragments, JAR
  URLs, git revision:path, SQL `db.schema`, Excel sheet references — this
  is by far the most common "across" solution in the entire survey, more
  common than the seed-dissolves-the-seam bet the doc is exploring. Worth
  weighing as the cheap/proven default against the more ambitious unified
  reading.
- **Several domains ship *multiple, deliberately different* addressing
  notations for the same underlying referent** (genomics #137, music
  #141, USD's layered composition #163, HyTime #129) — none of them
  apologize for it or treat it as a temporary state pending unification.
  That's direct, mature, shipped support for the seed doc's "coherent
  collection, not one canonical syntax" framing (§0/§3), from domains that
  aren't UDON's own tradition and didn't converge on it by copying each
  other.
- **The rarest thing in this entire survey turned out to be a genuine
  *native* "across" notation** (one grammar, no boundary glyph, spanning
  resource-location and in-resource-descent) — almost nothing here truly
  has it. URDF's kinematic chain (#162) and Plan 9 (#8) come closest, and
  both get there by making the "outside" and "inside" the *same substrate*
  (physical transforms; a uniform OS namespace) rather than by clever
  syntax. That's a strong signal for the seed doc's own §0 "resource-as-
  node" hypothesis: if it's going to work, it probably has to come from
  collapsing the substrate distinction, not from a smarter separator
  character.
- **The theory pass (family W) converged on the same handful of open
  questions the wild-notation pass did, from a completely different
  direction** — that convergence is itself the finding, more than any
  single citation. The get/put/put-put lens laws (#171) *are* the
  round-trip requirement (§1 of the seed doc); the Lens/Prism/Traversal
  type lattice (#172) *is* the `at`/`all`/partial-match question (§2d–e);
  Saltzer's context-relative naming (#176) *is* the anchor-kind menu
  (§2a); the separation-logic Frame Rule (#175) *is* the "staleness scoped
  to the addressed subtree" requirement (§2h). None of the theory was
  built with UDON in mind, obviously — which makes it reasonably strong
  evidence that these particular open questions are load-bearing and
  general, not artifacts of how the seed doc happened to frame them.
- **One genuine surprise, not called for by anything in the brief**: the
  formal notion of "path" nearest the *bottom* of the theory stack
  (homotopy type theory's identity-types-as-paths, #182) has essentially
  nothing to do with addressing at all — it's about what it *means* for
  two things to be equal. It's included mostly as an intellectual
  curiosity and a caution: "path" is not merely an overloaded English
  word by accident of history; even inside pure mathematics it independently
  denotes two unrelated ideas (a route through a space of *proofs*, vs. a
  route through a space of *data*) that only rhyme metaphorically. Worth
  keeping in mind if the UDON design conversation ever reaches for "path"
  as if the word itself carries settled meaning — it doesn't, even in the
  most formal settings available.

---

*Survey compiled 2026-07-23 as ideation fuel, not evaluation, in two
passes: broad recall of addressing notations "in the wild" (families A–V),
then a web-research pass into the formal/academic theory of addressing
(family W), the latter carrying per-row citations since it draws on
literature rather than general recall. Nothing here argues for or against
any UDON design; every row is offered as raw material for the designers
named in the brief to react against, borrow from, or consciously reject.*
