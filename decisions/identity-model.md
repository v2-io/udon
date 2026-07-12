# The Identity Model — model (C), ratification-ready

Consolidates every key/trait/identity decision into one place, and drafts
the piece that was still missing: the **recommended host-view API**. Feeds
the FULL-SPEC edit. Status per section marked. (Full history: DECIDED.md.)

## 1. Substrate — spec-forced (authority 1)

The element model is minimal: **`element = name + ordered attributes +
children`.** There are *no* separate identity/traits/suffix fields — those
are **views**, not model. (This is what makes model (C) (C), and it's the
sentence whose absence let tree.rs's convenience fields get mistaken for the
model in the first place.)

**Sugar → specially-designated attributes (total desugaring, an invariant):**

*Terminology (per D1b-partial): `$key`/`$traits`/`$?`… are **specially-
designated**, NOT reserved — any `$`-name is a legal ordinary attribute; the
sugar simply targets these particular names. "Reserved" is the wrong word
because nothing is fenced off.*

| Sugar | Desugars to | Notes |
|---|---|---|
| `\|el[k]` | `\|el :'$key' k` | key value |
| `\|el.a.b` | `\|el :'$traits' a :'$traits' b` | stacked, order-preserved (D-ATTR-1) |
| `\|el?` (`!`/`*`/`+`) | `\|el :'$?' true` | suffix flags |
| `\|el[a] :'$key' b` | keys stack → `[a, b]` | multi-key aliases; sugar stays single-bracket, extra keys via longhand |

- **`$`-names are ordinary names** (D1b-partial): no reserved namespace, no
  proscription — the sugar merely *pairs* with `$key`/`$traits`/`$?`.
  Quoting friction (`:'$key'`) + convention deter collisions.
- **Stacking is uniform** (D-ATTR-1): `$key`/`$traits`/`$?` stack like any
  attribute; order preserved; the event stream (each `Attr` in order) is the
  truth.
- **`\|` defines, `@` refers** (D1a): a `\|el[k]` is always a *definition*.
- **Type-scoped uniqueness**: `(element-name, $key)` unique per document;
  duplicate definition → **Document-layer error** by default, policy-
  configurable (D-ATTR-3: `error|allow-if-identical|first-wins|last-wins|
  keep-all` + `warn`). Event/streaming layer never checks (stays stateless).

**Trait designation: `$traits`** (RATIFIED — Joseph). Each `.t` adds a value
to the stacked `$traits`. **The `traits` view is *always a list*** — `[]`,
`["a"]`, `["a","b"]` — even for a single trait (app-dev simplicity; matches
udon-ast's "traits always an array"). This is the *specific, ratified* answer
for traits to the general question below.

*(Impl nuance, general case — the attrs() API surface call: for an ordinary
stacked attribute, does a **single** value present as a scalar or a
one-element list? `:x v` → `v` or `["v"]`? Traits is pinned always-list;
the general rule stays a host/impl decision — likely `.attr` scalar-or-last,
`.attr_all` list.)*

## 2. Recommended host views — authority 3 (recommended, NOT forced)

Like Markdown/YAML/Liquid parsers, each host picks its own idiom — but the
spec **recommends** a default shape so switching hosts feels familiar. Two
views, both derivable from the substrate; a host may expose one, both, or
its own:

**View A — flat/raw: `all_attributes`** *(chosen default name)*
- Every attribute in document order, **including** the specially-designated `$`-set.
- The round-trip / tooling / "I want exactly what's there" view.
- *(candidates were `bare_`/`all_`/`full_attributes`; `all_attributes` is
  clearest — "bare" collides with bare-value/unquoted, "full" is vague.)*

**View B — distinct (the ergonomic default):** `key` · `traits` ·
`attributes`
- `key` → value(s) of `$key` (scalar in the common single-key case; the
  ordered list when aliased).
- `traits` → values of `$traits`, **always a list** (`[]`/`["a"]`/`["a","b"]`; ratified).
- `attributes` → the **non-designated** attributes only (i.e. not the
  sugar-targeted `$`-names).
- suffixes → surfaced as the host prefers (booleans/flags off `$?` etc.).

Precedent: this is the DOM split (`.attributes` all-vs `.id`/`.classList`
distinct), made explicit and clean — `all_attributes` = raw everything,
`attributes` = user attrs, `key`/`traits` = the specially-designated ones named.

## 3. Parser / host decisions (the knobs to expose) — authority 2 + 3

The spec forces the *menus*; the parser/host pick within them:

| Knob | Owner | Menu / default |
|---|---|---|
| **Dereference `@`-refs?** | 2 parser flag + 3 host default | never (events) / opt-in (Document); streaming default never, AST default available (D-ATTR-2) |
| **Duplicate `(type,key)` policy** | 1 spec menu + 2 parser knob | `error` (default) `\|allow-if-identical\|first-wins\|last-wins\|keep-all`, `+warn` (D-ATTR-3) |
| **View exposure + names** | 3 host | recommend §2 defaults; host may rename/alias per idiom |
| **key multiplicity surface** | 3 host | multi-key permitted (stacking); a `first_key` convenience is optional |
| **Designated-attr hiding in `attributes`** | 3 host | recommend yes (that's what makes View B "distinct") |

## 4. Schema decisions — authority 4

Constraint/proscription only (never core): cardinality (single vs multi
`$key`), type restriction (e.g. no array-valued `$key`), required/optional,
element vocabularies, validation. *"Disallow array-valued `$key`" is a
schema rule; core happily stacks and list-types any attribute" (D-AUTH-1).*

## 5. What ratifying this closes

One "ratify identity-model.md" collapses: the (C) model + total-desugaring
invariant, wire names (`$key`/`$traits`/`$?`), D1c suffixes, multi-key
aliases, the key-scope enforcement layer, and the view/API recommendation.
**Nothing is genuinely open** beyond that one ratification. The
single-stacked-value scalar-vs-list surface (§1) is *not* deferred — it is
**assigned to the host** (authority 3) with a recommended default; assigning
to an authority *is* closing it, spec-side. No canonical-form question
exists (UDON mandates none; a `udon fmt` is optional and offers a display
preference, never a required form). Then the identity spec-edit (~1 page) and
the U4 impl (typed-key fix + the `Attr("id")`→`$key` event correction + view
accessors) are executable.
