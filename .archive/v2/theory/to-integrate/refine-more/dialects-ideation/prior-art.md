# Prior art for UDON's dialect architecture

> **Provenance.** Comparative survey commissioned for the dialects ideation seed
> ([README.md](README.md)), 2026-07-28, by an agent briefed on the carve-outs and the
> envelope boundary but **not** on this seed's own reading — so its §0 split is
> independent arrival, not agreement with a frame it was handed. Web-sourced
> throughout, citations inline. Register: *evidenced* where cited, and the closing
> section is explicitly the surveying agent's own voice and judgment, carried forward
> unflattened at its request. Not law; not a decision; not a substitute for reading the
> cited sources at the point you rely on one.

Grounded against `v2/current-0.9.1-spec/CORE.md` §1.1 and §11.6, and
`CARVEOUTS.md`'s `DIALECT-DEF` / `ENV-ROUTE` / `ML` entries, as of 2026-07-28.

## 0. The one framing challenge worth leading with

**DIALECT-DEF, as currently written, bundles two questions that every system
below keeps separate — and every system that tried to unify them paid for
it.** CARVEOUTS already senses this ("logged as a unification pressure to
*check against the map*, not to unify early") but I'd go further: I think
the two are not just separable, they are *categorically different kinds of
thing*, and the "power envelope" conversation only applies to one of them.

- **Closed-grammar dialects** — `temporal`, `path`, the rational/complex
  spelling for `RC-SPELL` — are parsers for a fixed literal syntax with a
  projection to a native value. They need no evaluation, no host callbacks,
  no "what names does this need" question. Their artifact story is a
  compiled grammar (tree-sitter's model, below) — versioned, distributed,
  and *verified by testing against fixtures*, the same way `core/` verifies
  the parser against CORE.
- **Computational/templating dialects** — the thing that gives `!if` and
  `!{…}` meaning — are where "digestible Turing-ish subset" actually bites,
  because these need variable binding, host callbacks (filters/helpers), and
  some notion of scope.

No system I found gives these two the same definition/verification/
distribution treatment. tree-sitter's own grammar-vs-injection split is
literally this same seam (§3). If DIALECT-DEF stays singular, I'd flag that
as the highest-leverage split to make explicit before spiking either half —
whatever the timespec in-vivo probe (ENV-ROUTE) teaches you about routing a
closed grammar will likely tell you close to nothing about routing a
computational one, and vice versa.

## 1. Rebol/Red `parse` — the closest ancestor, and why it's a cautionary
   tale for a reason CARVEOUTS hasn't quite named yet

Rebol's own definition of "dialect" is disarmingly thin: *any loadable
expression is a dialect* — a dialect is just a `block!` of Rebol values that
some function chooses to interpret with its own grammar of meaning, reusing
Rebol's lexer but not its evaluator. `parse` itself is the flagship
dialect — a PEG-family (specifically TDPL-lineage) grammar-matching
mini-language, invoked as `parse <input> <rules>` where `<rules>` is
Rebol data, not a string.
([REBOL 3 Concepts: Parsing](http://www.rebol.com/r3/docs/concepts/parsing-dialects.html);
[Wikibooks — Dialects](https://en.wikibooks.org/wiki/Rebol_Programming/Language_Features/Dialects);
[hostilefork — Why Rebol, Red, and Parse are Cool](http://blog.hostilefork.com/why-rebol-red-parse-cool/))

**The load-bearing fact for you:** Rebol never solved DIALECT-DEF *at all* —
it dissolved the question by making "dialect" ≡ "program the host evaluator
happens to interpret differently." There is no artifact boundary, no
compilation step, no independent versioning, no registry, no declared
binding at the document level. A dialect is exactly as trustworthy, as
inspectable, and as dangerous as arbitrary code, because it *is* arbitrary
code — `parse` rules can invoke arbitrary Rebol expressions mid-match, so
whatever "sub-Turing → statically interrogable" hope existed for PEG-style
matching evaporates the moment a rule can call out to the full language.
This is, I'd argue, the actual mechanism behind Rebol's "obscure /
write-only" reputation — not merely unfamiliar syntax, but that *there is no
fixed vocabulary of keywords at all* (Rebol is proud of having none), so
reading any block of code requires first knowing *which dialect's meaning*
is currently active for each word, and that's a fact you can only get from
context or documentation, never from the grammar. My web search for an
explicit "fragmentation" postmortem came up empty — the failure isn't
narrated as such anywhere I found; it shows up instead as every "Rebol is
cool but l don't get it" piece implicitly describing this exact confusion
(e.g. the [Hacker News thread](https://news.ycombinator.com/item?id=14795020)
on trying to learn the PARSE dialect). I'd treat the *absence* of a written
postmortem as itself informative: nobody thought "the dialect story" was
the failure at the time, they diagnosed obscure syntax — but the obscurity
and the missing artifact boundary are the same root cause, one level down.

**What to carry forward, named as Rebol's own unlearned lesson:** "dialect =
whatever the host chooses to interpret specially" is exactly the design
UDON's envelope already refuses at the syntax layer (`<…>` is a real,
independently-parseable boundary, unlike Rebol's undelimited blocks). The
open question DIALECT-DEF names is whether UDON will make the same mistake
one layer *up* — treating a dialect's *implementation* as just "a function
someone loaded," with no compiled/versioned/verified artifact story either.

## 2. Liquid — the isolation model Joseph is implicitly gesturing at, with
   its actual boundary list

Liquid (Shopify) is deliberately **not** Turing-complete, and its own
maintainers describe why in operational terms, not theoretical ones: no
arbitrary code execution, no filesystem access, no unbounded loops, because
themes from thousands of merchants share one process pool.
([Shopify/liquid README](https://github.com/shopify/liquid))

The concrete boundary — the actual shape of "Liquid's appeal" if you want to
cite specifics rather than gesture at them:

- **No recursion**, no user-defined functions in the classical sense.
- **Bounded iteration only**: `{% for %}` iterates an existing collection,
  with `limit`/`offset`; there is no `while`, no way to loop without a
  pre-existing finite collection to walk.
- **Filters are the only extension point**, and they're host-registered pure
  functions (`{{ x | upcase }}`) — the guest never defines new ones, it only
  invokes what the host exposed.
- **`Environment`** is Liquid's own name for a scoped registry of which tags
  and filters are active in a given render context — i.e. Liquid already has
  a live instance of "which dialect-equivalents are loaded, and in what
  scope" as a first-class object, not a global.

The honest failure mode on the *other* side, which is what makes this a
genuinely two-sided lesson rather than an endorsement: theme developers
routinely reach for `{% capture %}`/`{% assign %}` chains to fake local
variables and control flow Liquid doesn't have, producing exactly the kind
of contorted, hard-to-read guest code that "no logic" was supposed to
prevent. I didn't find a rigorously documented anecdote of this (it's folk
knowledge in the Shopify theme-dev community rather than a written
postmortem), so treat it as directionally true rather than sourced — but the
Mustache case below has the equivalent critique written down explicitly.

## 3. Mustache — "logic-less" taken further, and the written critique of
   what happens when a guest is given too little

Mustache's own manifesto: no `if`, no `else`, no loops — only tags, some of
which are replaced by a value, some suppress a block, some repeat it. All
decision-making lives in the host view object, never the template.
([mustache(5) man page](http://mustache.github.io/mustache.5.html))

The interesting document here is **not** Mustache's own philosophy, it's
Alexei Boronine's ["Cult of Logic-Less
Templates"](https://www.boronine.com/2012/09/07/Cult-Of-Logic-less-Templates/),
which is exactly the too-little-power failure mode written down: pushing
*all* decision logic to the host doesn't eliminate the logic, it just moves
it — often into ad-hoc "presenter" objects that end up reinventing template
logic in a second language, and it makes trivial per-document tweaks (a
conditional label, a pluralization) require a code change and redeploy
rather than a document edit. This is directly relevant to UDON's stated
customers: if the templating/dynamics tier is made *too* weak, the
"digestible power" goal inverts — authors escape into the host language
instead, which is worse for UDON's stated pitch (documents that carry their
own logic) than a bounded-but-real `!if`/`!{…}` would be.

## 4. Static interrogability — the actual state of the art, and I think it
   disproves the "sub-Turing ⇒ interrogable" hypothesis as stated

This is the part I'd push hardest on, because you flagged it as an
untested hypothesis and I think the evidence points somewhere more precise
and more useful than either "yes" or "no."

**Jinja2 already does "what names does this template need"** — on a
Turing-complete language. `jinja2.meta.find_undeclared_variables` walks the
compiled AST and returns the free variables a template will read at
render time, by (ab)using the code generator itself as a static analyzer
via a `TrackingCodeGenerator`.
([source](https://tedboy.github.io/jinja2/_modules/jinja2/meta.html);
[Traffine writeup](https://io.traffine.com/en/articles/jinja-find-undeclared-variables))
Critically, it is a **sound over-approximation, not an exact answer**: it
returns the union of variables referenced across *all* branches, whether or
not a given render path would actually touch them, and it has documented
gaps — e.g. it currently mis-handles the `{{ x | default(...) }}` filter,
reporting `x` as required even when a default makes it optional
([pallets/jinja#1034](https://github.com/pallets/jinja/issues/1034),
[#1314](https://github.com/pallets/jinja/issues/1314)).

That's the finding: **"what free names does this need" is a question you
can answer approximately on a Turing-complete language via conservative
static analysis — you don't need to give up Turing-completeness to get a
useful (if imprecise) answer.** What sub-Turing languages actually buy you
is a *different, stronger* guarantee — not "this specific question is
answerable" but "this whole *class* of question is decidable, exactly, for
every program in the language, with a proof." The general theory backs this
up directly: a calculus that's Turing-complete untyped can often be
statically typed at the cost of Turing-completeness, and doing so yields
*precise* result types without needing runtime information — but a
strongly-normalizing (terminating-by-construction) type system either has
very limited expressiveness or very expensive type-checking. There is a
real trade curve here, not a cliff.

The concrete sub-Turing examples, each choosing a different point and for a
different reason (none of them primarily "so we can list free variables" —
that's worth noting, it's not the headline benefit anyone advertises):

- **CUE** — no loops, guarantees every program terminates on every input;
  the design lineage is explicitly linguistic (config-as-massive-grammar),
  and the payoff named is analyzability/composability of *constraints*
  (unification), not variable-extraction. ([Increment —
  "It doesn't have to be Turing complete to be
  useful"](https://increment.com/programming-languages/turing-incomplete-advantages/);
  [How CUE Wins](https://blog.cedriccharly.com/post/20210523-how-cue-wins/))
- **Starlark** (Bazel) — explicitly goes "the extra mile to be
  non-Turing-complete": no recursion (bounded stack), no file/network/clock
  access (hermeticity), determinism as the headline goal — because build
  systems need reproducibility and safe parallel evaluation, not because
  they need to answer "what does this rule read." ([Starlark spec on
  GitHub](https://github.com/bazelbuild/starlark);
  [Wikipedia](https://en.wikipedia.org/wiki/Starlark))
- **Dhall** — total (non-Turing-complete, provably terminating), but its
  headline safety story is actually about **imports**, not evaluation power:
  a `sha256:…` semantic-integrity hash pins an import to its *normal form*,
  so any tampering — even transitive — is rejected at resolution time, and
  behavior-preserving refactors (whitespace, comments) don't break the hash.
  ([dhall-lang imports.md](https://github.com/dhall-lang/dhall-lang/blob/master/standard/imports.md);
  [Safety
  Guarantees](https://docs.dhall-lang.org/discussions/Safety-guarantees.html);
  [Haskell for all — Semantic integrity
  checks](https://www.haskellforall.com/2017/11/semantic-integrity-checks-are-next.html))
  This is the single most directly reusable idea in this whole survey for
  UDON's *verification* question (below) — a dialect artifact could be
  content-addressed by the hash of its normalized grammar/semantics, giving
  a document a way to pin "the `temporal@1` I mean is exactly this one," not
  merely a name that could resolve to something different tomorrow.

**My honest read, to carry forward under my own name rather than flattened
into "the research says":** I think the useful reframe is not "is sub-Turing
required for interrogability" but **"which specific static questions do you
actually want decidable, and for those, is a bounded fragment of the
computational dialect cheap to carve out — while leaving the rest as
sound-but-approximate, Jinja2-style?"** E.g. "what top-level names does this
`!{…}` block read" might be answerable exactly and cheaply even inside a
fairly rich dynamics tier, the same way Jinja2 gets it approximately for
free from its compiler; while "does this `!if` chain always terminate" is
the harder guarantee that actually costs you Turing-completeness. Those
don't have to be bought with the same currency.

## 5. tree-sitter — the cleanest existing separation of grammar-as-artifact
   from routing-as-declaration, and I think its shape maps almost directly
   onto UDON's gap

This is the strongest single analog I found for the *artifact* half of
DIALECT-DEF, precisely because tree-sitter had to solve exactly your
three-part problem (define, distribute, route) for an unrelated reason
(editor tooling) and ended up with a clean three-layer answer:

1. **Definition**: a grammar is written once (`grammar.js`), compiled ahead
   of time by `tree-sitter generate` into a versioned parser (C source, then
   a shared library) — the compiled artifact *is* the distributable unit,
   carrying an ABI version, not the grammar source.
2. **Distribution**: compiled grammars are packaged and versioned like any
   other dependency (npm/crates/etc.), independent of any host editor.
3. **Routing**: which region of a *host* document gets handed to which
   *guest* grammar is a **separate artifact entirely** — an `injections.scm`
   query file, owned by the integration (the editor/tool), not by either
   grammar. It pattern-matches host-tree nodes (e.g. a fenced code block's
   info-string) to a target language name.
   ([tree-sitter injections
   docs](https://tree-sitter.github.io/tree-sitter/3-syntax-highlighting.html);
   [example injections-ejs.scm](https://github.com/tree-sitter/tree-sitter-embedded-template/blob/master/queries/injections-ejs.scm);
   [Topiary — Formatting
   Forests](https://www.tweag.io/blog/2026-07-09-topiary-formatting-forests/)
   — Topiary literally runs the host parse, extracts injected spans by this
   mechanism, hands each to its own grammar's formatter, and stitches
   results back, which is close kin to what nested-envelope ("ENV-ROUTE")
   routing in UDON would need to do.)

The genuinely useful negative finding, which I think is worth putting in
front of Joseph as-is: **this mechanism is explicitly still incomplete
industry-wide**, even after a decade of tree-sitter's own maturity — an open
Zed issue asks for *real* language-server intelligence (not just
highlighting) inside injected regions
([zed-industries/zed#60172](https://github.com/zed-industries/zed/issues/60172)),
and a parallel effort ("LSPVirtualDocuments") exists specifically because
LSP's own designers never gave embedded-language routing (Razor's HTML+C#,
JSX's HTML-in-JS) a first-class protocol answer — "virtual text documents
drive nearly every embedded-language interaction but aren't well defined in
the LSP landscape."
([NTaylorMullen/LSPVirtualDocuments](https://github.com/NTaylorMullen/LSPVirtualDocuments/blob/master/Documents/EmbeddedLanguageLSPExpansion.md))
So ENV-ROUTE isn't UDON lagging behind a solved problem — it's an
open problem in the wider industry, and whatever UDON's `temporal`/timespec
in-vivo probe turns up could plausibly be citable prior art in its own
right, not just an internal implementation detail.

## 6. Racket `#lang` — the alternative pole: routing *is* definition,
   because the reader and the module system are unified

Where tree-sitter deliberately separates "what parses this" from "where does
this apply," Racket collapses them: the `#lang <name>` line at the top of a
file is simultaneously the routing declaration and (via the module
resolver + package system's `info.rkt`) the pointer to the module that
implements the reader. There's no separate registry step — the language name
resolves through the same module-path namespace as any other Racket
require. Because the reader, the macro-expander stage, and even core forms
like `#%app`/`#%top` are all individually overridable, a `#lang` can range
from "basically Racket with new syntax" all the way to "a wholly different
paradigm" (Typed Racket, Datalog-flavored languages, Scribble's prose-first
mode) while still composing inside one file/module ecosystem.
([Racket Guide — Reader
Extensions](https://docs.racket-lang.org/guide/hash-reader.html);
[Racket Guide — Module
Languages](https://docs.racket-lang.org/guide/module-languages.html);
[Culpepper et al., "From Macros to
DSLs"](https://www2.ccs.neu.edu/racket/pubs/snapl19-cffk.pdf))

For UDON, I think this is the strongest precedent for the specific claim in
CORE §11.6 that "dynamics belongs to a host dialect" — Racket has already
proven, at production scale, that a guest language's control-flow forms
(what `if`/`for`-equivalents even *mean*) can be legitimately owned by
something other than the base reader, with real hygiene guarantees around
how guest syntax borrows host lexical scope (`syntax/parse`, macro hygiene)
— so "the templating tier's semantics are a dialect's to define" isn't a
novel risk, it's a well-trodden design with known solved sub-problems
(hygiene, phase separation) UDON could borrow vocabulary from even without
adopting Racket's macro machinery.

The trade-off, named honestly: Racket's routing works *because* it assumes
a single, already-unified module-path/package namespace behind every
`#lang` name. UDON's label ladder (`<content>` → `<type:content>` →
`<dialect:type:content>`) is a much smaller, document-embedded version of
the same idea, but doesn't (yet) have Racket's equivalent of "a `#lang` name
always resolves via one canonical mechanism" — which is exactly what
DIALECT-DEF's "default active set for unlabelled dispatch" question is
asking for.

## 7. XML namespaces + schema resolution — the closest "same problem,
   arguably not solved well" cautionary case, and I think it's more useful
   as a *routing* anti-pattern than a naming one

The oft-repeated "namespace hell" isn't really about the URIs themselves —
it's that an XML namespace URI is an **opaque identifier that need not
resolve to anything**, and *schema location* (where to actually go find the
grammar for that namespace) is a second, independent, late-bound,
best-effort mechanism (`schemaLocation` hints, XML catalogs) that different
tools honor inconsistently. Concretely: multiple `<xs:import>`s can name the
*same* namespace with *different* `schemaLocation`s, and per the spec only
the first is guaranteed to be processed — a real, still-open source of
validation bugs.
([IBM support note on this exact
failure](https://www.ibm.com/support/pages/resolution-validation-error-when-schema-specifies-multiple-imports-different-schemalocation-and-same-namespace);
[w3.org bug
22278](https://www.w3.org/Bugs/Public/show_bug.cgi?id=22278) discusses the
"late binding" ambiguity directly.)

The lesson I'd carry forward: **identity and resolution are two different
jobs, and XML's failure mode is treating "the namespace URI" as if it
answers both** — it names the vocabulary but promises nothing about how to
actually fetch its definition, so every tool grew its own out-of-band
catalog mechanism, and none of them agree. UDON's `<dialect:…>` label
already does better structurally (the label is in-document, not a URI
pointing off into the world) — but DIALECT-DEF's "default active set... is
a host choice" is functionally the same kind of open resolution question
XML catalogs exist to patch over, just one level earlier (which dialects
are even loaded, rather than where a loaded one's schema lives). Worth
deciding deliberately rather than letting it accrete the way XML catalogs
did.

## 8. MIME media types (RFC 6838) — the layered-typing precedent closest in
   *shape* to UDON's label ladder, and a genuinely useful vocabulary

RFC 6838 formalizes exactly UDON's "least to most specific" ladder, just in
one dimension rather than two:

- **Registration trees** distinguish standard (no prefix) / vendor (`vnd.`)
  / personal (`prs.`) / historically unregistered (`x.`) namespaces for
  *who* gets to mint a type name — itself a small, working precedent for
  "who may register a dialect name" that UDON hasn't addressed at all yet.
- **Structured syntax suffixes** (`+json`, `+xml`) let a type say "my
  specific semantics are X, but I am generically processable as JSON" —
  which is close kin to UDON's `type:` vs `dialect:` split (type ~ which
  *generic structural grammar* applies; dialect ~ who assigns *meaning*
  within it).
  ([RFC 6838](https://www.rfc-editor.org/rfc/rfc6838.txt);
  [IANA structured-suffix
  registry](https://www.iana.org/assignments/media-type-structured-suffix/media-type-structured-suffix.xml))

The failure mode worth naming here is the one UDON has *already* explicitly
designed against, which is nice independent validation rather than a new
finding: MIME's practical routing mechanism was never purely the declared
label — browsers layered **content sniffing** on top (guessing type from
bytes when the declared `Content-Type` seemed untrustworthy), and MIME
sniffing has an entire security-vulnerability literature of its own (sniff
an uploaded image as HTML/script and you have stored XSS). CORE's
"unlabelled dispatch... no sniffing race" ruling (§11.6) is, in effect, a
direct rejection of the exact failure mode MIME's own ecosystem had to
retrofit browser-vendor-specific sniffing-algorithm specs to contain. That's
worth stating in the seed as *validated prior art for a decision UDON
already made*, not just a caution for the open ones.

## 9. Emacs major-mode routing — the "you'll want more than one routing
   signal, in an explicit precedence order" precedent

Emacs doesn't route a buffer to a mode by one mechanism — it tries, in
order: an in-file `-*- mode: … -*-` cookie, a `Local Variables` footer, a
`#!` shebang line (via `interpreter-mode-alist`), magic byte-content
sniffing (`magic-mode-alist`), and only last, filename pattern matching
(`auto-mode-alist`) — first match wins, full stop.
([GNU Emacs Lisp Reference — Auto Major
Mode](https://www.gnu.org/software/emacs/manual/html_node/elisp/Auto-Major-Mode.html);
[EmacsWiki —
AutoModeAlist](https://www.emacswiki.org/emacs/AutoModeAlist))

This is a small but concrete data point against solving ENV-ROUTE with a
single mechanism: forty-plus years of one of the most heavily-used
routing systems in software has settled on *several* independent signals
with an explicit, documented precedence order, not one canonical answer.
UDON already has an echo of this shape (declared dialects in order, first
claim wins) for the *unlabelled* case — Emacs's list suggests the labelled
cases (`<type:…>`, `<dialect:type:…>`) may eventually want their own place
in an explicit precedence list too, rather than being handled as
exceptions to the unlabelled rule.

## Answering your explicit uncertainties directly

**"Is definition vs. invocation/routing one question or two?"** Two, and I
think more confidently two than you were assuming — tree-sitter separates
them cleanly and it's a real strength of that design (§5); XML conflates
them in the identity URI and that conflation is a large part of why
"namespace hell" is a real phrase (§7). Racket is the interesting exception
that *unifies* them on purpose (§6) — but only by assuming a single global
module-path namespace already exists, which is a precondition UDON doesn't
have and might not want.

**"Has anyone made a declarative grammar artifact that's both statically
interrogable and expressive enough to be worth using?"** The honest answer
from this survey is: the ones that are cleanly, exactly interrogable (CUE,
Starlark, Dhall) bought that by giving up general recursion/Turing-
completeness, and none of them advertise "we can enumerate what names a
program needs" as the payoff — their exact guarantees are termination,
hermeticity, and import integrity respectively. The systems that *do*
answer "what names does this need" (Jinja2) do it approximately, on a
Turing-complete language, via conservative static analysis with known
gaps. I don't think anyone has cleanly demonstrated "exact interrogability
of exactly this question, at full expressiveness" — which suggests it may
be genuinely open territory rather than a solved-elsewhere problem you
just haven't found yet (§4).

**"What are the actual observed failure modes, too much / too little
power?"** Too much, un-artifacted: Rebol, where "dialect" dissolves into
"arbitrary code the host happens to interpret differently," with no
compiled/versioned/verified boundary at all (§1) — this is the one I'd
weight most heavily, because it's the closest ancestor and the failure is
structural, not cosmetic. Too little: Mustache, documented explicitly as
pushing the same decisions into a second language/deploy cycle rather than
eliminating them (§3). The genuinely useful middle example, battle-tested at
scale, is Liquid (§2) — bounded iteration over existing data, no recursion,
no user-defined functions, filters as the only host-granted extension
point — which is about as concrete as "digestible power envelope" gets
without reading Liquid's own source.

## What I'd flag to Joseph directly, in my own voice

I think the single highest-leverage move available to the ideation seed is
the §0 split — treating "artifact story for a closed grammar" (temporal,
path) and "artifact story for a computational dialect" (dynamics) as two
separate design tracks with two separate verification stories, rather than
one DIALECT-DEF. Every clean precedent I found (tree-sitter's grammar vs.
injection-query split most of all) lives on exactly that seam, and every
messy one (Rebol, XML) is messy partly *because* it didn't make that split.
I'd also actively push back gently on my own hypothesis-testing here: I
don't think I disproved "sub-Turing enables interrogability" so much as
found that it's the wrong granularity — the real lever is *which specific
question* you want decidable, and Jinja2's `find_undeclared_variables`
is concrete proof you can get a useful, sound, if imprecise, answer to
"what names does this need" without leaving Turing-completeness at all. If
that's the property you actually want out of the dynamics tier, it might be
cheaper than the power-envelope conversation assumes.

## Sources (carried forward with attribution)

- Rebol/Red parse: [rebol.com r3 concepts](http://www.rebol.com/r3/docs/concepts/parsing-dialects.html), [Wikibooks](https://en.wikibooks.org/wiki/Rebol_Programming/Language_Features/Dialects), [hostilefork blog](http://blog.hostilefork.com/why-rebol-red-parse-cool/), [HN thread](https://news.ycombinator.com/item?id=14795020)
- Liquid: [Shopify/liquid README](https://github.com/shopify/liquid)
- Mustache: [mustache(5)](http://mustache.github.io/mustache.5.html), [Boronine — Cult of Logic-Less Templates](https://www.boronine.com/2012/09/07/Cult-Of-Logic-less-Templates/)
- Jinja2 introspection: [jinja2.meta source](https://tedboy.github.io/jinja2/_modules/jinja2/meta.html), [Traffine writeup](https://io.traffine.com/en/articles/jinja-find-undeclared-variables), [pallets/jinja#1034](https://github.com/pallets/jinja/issues/1034), [#1314](https://github.com/pallets/jinja/issues/1314)
- CUE: [Increment](https://increment.com/programming-languages/turing-incomplete-advantages/), [How CUE Wins](https://blog.cedriccharly.com/post/20210523-how-cue-wins/)
- Starlark: [spec](https://github.com/bazelbuild/starlark), [Wikipedia](https://en.wikipedia.org/wiki/Starlark)
- Dhall: [imports.md](https://github.com/dhall-lang/dhall-lang/blob/master/standard/imports.md), [Safety Guarantees](https://docs.dhall-lang.org/discussions/Safety-guarantees.html), [Haskell for all](https://www.haskellforall.com/2017/11/semantic-integrity-checks-are-next.html)
- tree-sitter injections: [syntax-highlighting docs](https://tree-sitter.github.io/tree-sitter/3-syntax-highlighting.html), [injections-ejs.scm example](https://github.com/tree-sitter/tree-sitter-embedded-template/blob/master/queries/injections-ejs.scm), [Topiary blog](https://www.tweag.io/blog/2026-07-09-topiary-formatting-forests/), [zed#60172](https://github.com/zed-industries/zed/issues/60172), [LSPVirtualDocuments](https://github.com/NTaylorMullen/LSPVirtualDocuments/blob/master/Documents/EmbeddedLanguageLSPExpansion.md)
- Racket #lang: [Reader Extensions guide](https://docs.racket-lang.org/guide/hash-reader.html), [Module Languages guide](https://docs.racket-lang.org/guide/module-languages.html), [Culpepper et al. SNAPL'19](https://www2.ccs.neu.edu/racket/pubs/snapl19-cffk.pdf)
- XML namespaces: [IBM support note](https://www.ibm.com/support/pages/resolution-validation-error-when-schema-specifies-multiple-imports-different-schemalocation-and-same-namespace), [w3.org bug 22278](https://www.w3.org/Bugs/Public/show_bug.cgi?id=22278)
- MIME/RFC 6838: [RFC text](https://www.rfc-editor.org/rfc/rfc6838.txt), [IANA structured-suffix registry](https://www.iana.org/assignments/media-type-structured-suffix/media-type-structured-suffix.xml)
- Emacs mode routing: [GNU Emacs Lisp Reference — Auto Major Mode](https://www.gnu.org/software/emacs/manual/html_node/elisp/Auto-Major-Mode.html), [EmacsWiki AutoModeAlist](https://www.emacswiki.org/emacs/AutoModeAlist)

## Not chased, flagged as possibly worth a second pass

I did not get to Datalog/Rego (Open Policy Agent's own literature on
static-analyzability of policy dialects is probably relevant to the
"digestible power" question and I'd bet has a written failure-mode story),
Nix's derivation-purity model beyond a shallow pass (its actual
verification/hashing story for derivations might be a second Dhall-like
data point), or CUE's *unification* semantics in enough depth to say
whether it has anything like a "what fields does this need" query
(plausible, given its constraint-solving nature, but I didn't verify). If
useful I'm glad to go a layer deeper on any of these, or on Open Policy
Agent specifically, which I suspect is the best-remaining unchecked lead.
