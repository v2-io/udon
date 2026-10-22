# Types and notations: ideation, 2026-10-22

*Running notes from the session `017CGtyM` brainstorm with Joseph. Pure ideation: nothing here is a lean, a decision or a proposed spelling unless it says so, and every spelling below is illustrative. Joseph's words are quoted; everything else is the agent's. His whole messages are in `STEWARD-VERBATIM.md`. Background: `old-numeric-typing.md` (the old line's standard set).*

## His scope, as stated

> **Primary concerns**: slot-type, literal-notation-hint, units (= seem to be a bit of both slot-type & literal-hint & coercion), algebraic-names (domain-centric slot-type mapping), "standard set" (described below).
>
> **Potentially related / overlapping concerns**: extensions (including type extensions (including both generic and host-specific)), namespacing/hierarchy, stackable traits, cardinality/ordinality/arity..., schemas, enforcement, coercion, sigils, (obviously other udon conventions/spellings-- block-level vs embed, etc.)

"Algebraic names", in his words: "designating `port` as one of u16 | standard-ports, with standard-ports designated as {'smtp','ssh','http',...} (not proposing a spelling-- just the concept I had in mind). At the very least, type aliases."

## Distinctions to keep apart (his)

1. **Quoted vs unquoted** (Lisp's quote): keep a reference or a value as itself, or resolve it.
2. **"*this is what the slot is* vs *this is what my literal represents*."**
3. **A dialect is neither of those.** "<dt:...> glosses over it historically when discussing because it's... well, neither-- it's a dialect-- a type namespace with its parser-- in this case with the actual literal notation mapping to a given type (timestamp, timestamp-w-zip, datespan, ...)."
4. **"how it's literally written here" vs "how it's read and what processing is available to the API ingesting & processing it automatically without extra work"**, and "possibly also implying a "normalized/unified way of reading it when re-emitted"".

His imaginings: `:when:iso8601 <dt: 2026 PDT>`, `:when:dt(YY-MM-DD)<27-03-05>`.

## The agent's map so far

Per value, five things that can each be stated or left unstated:

| | Question | Example |
|---|---|---|
| R | the spelling, as written | `27-03-05` |
| N | the notation that reads it (dialect, format, parameters) | `dt`, `YY-MM-DD` |
| T | what the literal represents | a date, 2027-03-05 |
| S | what the slot accepts | `port` = u16 \| standard-port |
| C | how it is written back, canonically | `2027-03-05` |

N maps R to T; T must fit S (or be coerced to it); C is N's canonical spelling of T. Where N and S are declared is its own axis: on the literal, on the slot (the attribute name), in a document header, in an external schema; most specific wins, as locales and CSS cascade.
