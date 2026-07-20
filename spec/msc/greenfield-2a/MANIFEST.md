# greenfield-2a — clean-room materials

A clean-room for deriving UDON's parser output (the event stream) from the
**language alone**. Everything here is *input*: the language spec with all
event/wire prescription deliberately removed, plus a broad corpus of udon
snippets. Nothing here states what events a parser should emit — that is what a
reader derives.

## Layout

- **`spec/`** — the language specification, **scrubbed of the event/wire layer**.
  Syntax and semantics (what each construct *means*, and what *behavior* happens
  on malformed input — "a warning is issued if X is unclosed", "an unclosed
  identity key yields a `$partial-key`") are intact; event names, warning-code
  names, emission ordering, wire-encoding sections, and the event-emitting parts
  of the non-normative implementation sketches are gone. Live decision-status is
  kept ("deliberately undefined", "provisional", "interim", "normative", "needs a
  ruling"); dated ratification breadcrumbs and provenance asides are removed. Two
  genuinely-redundant sections were converged. `MARKDOWN.md` and
  `CORE-supplement.md` needed no scrub.

- **`snippets/from-corpus/`** — udon snippets an earlier spec-only pass generated,
  organized by its own topic headings. Its derived event answers were removed;
  only the udon (and the topic headings) remain.

- **`snippets/from-fixtures/`** — udon inputs from the reference test corpus
  (v0.9 / v0.8 / exploratory / _wip), one file per source group. Event
  assertions, descriptions, and behavior-hinting ids were stripped; ids are
  opaque, de-leaked labels for later correlation only. (The pre-reboot
  `legacy-pre-0.8` group is excluded — it uses retired syntax.)

- **`snippets/from-spec/`** — the udon examples embedded in the scrubbed `spec/`
  files, lifted out for convenience.

## Provenance / integrity

All snippet sets were verified free of event/warning-code vocabulary. The source
specs (`spec/…`) and the earlier pass's working directory (`spec/msc/greenfield/`)
were not modified in producing this clean-room.
