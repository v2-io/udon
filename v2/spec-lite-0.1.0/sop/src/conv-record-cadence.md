---
kind: convention
awaiting-second: true
awaiting-decision: false
needs-work: false
per: [working-notes-and-frozen, notes-disposition-at-freeze, fixture-file-shape]
depends: [def:record-kinds, def:sop-kinds, conv:working-notes]
---

# Section order per kind

*What a conforming record of each kind contains, in order. ∂(doc-state) `conforms` checks against this.*

## Statement

**Every Markdown record except a decision** (which follows `adr/TEMPLATE.md`, where the title is the summary): frontmatter (`kind:`, the three ⟦flags⟧, then the fields the kind uses), then a title and a one-line italic summary. If the record has working notes, `## Working notes` is the last section ([[decision:working-notes-and-frozen]]).

**Optional body sections, any kind:** **Why**, **Sources**, **Cautions**, **Regression guards**. A working note that is *kept* when it is dispositioned moves into one of these ([[decision:notes-disposition-at-freeze]]). They sit after the kind's own sections and before Working notes, except where a kind already names one (a directive's or convention's Why).

**In between, per kind:**

| Kind | Sections, in order |
|---|---|
| rule (spec) | Statement (numbered clauses, RFC 2119 capitals) · Grounds · Epistemic status · optional Explanation, marked as teaching. Open parts and open questions go in Working notes ([[decision:open-questions-in-working-notes]]). |
| objective, principle (spec) | Statement · Grounds · What discharges it (objective) or How it is used (principle) · Epistemic status |
| property (spec) | Claim · Derivation · Epistemic status |
| explanation (spec) | the teaching prose; `narrates:` in frontmatter |
| definition (both stores) | Terms · Invariants · optional Examples |
| decision (both stores) | per `adr/TEMPLATE.md` |
| directive (SOP) | Statement · Why. Its moment is stated once, in frontmatter (`when:`), where a harness or linter can read it. |
| convention (SOP) | Statement · How a violation shows · Why |
| reference (SOP) | the facts, with `source:` in frontmatter |
| fixture (spec) | one YAML mapping: `kind`, the three flags, `depends`, `notes`, then `cases:`, each case with a stable `id`; a case's kept reason in `why:`, its working notes in `notes:` ([[decision:fixture-file-shape]]) |

**Normative words:**

- In the spec store, RFC 2119 capitals (MUST, SHOULD, MAY) appear only in a rule's or objective's Statement.
- In the SOP store, directives and conventions state their practice in plain words, without the RFC capitals. Those capitals are kept for lite's own normative text.

## How a violation shows

A record missing a section its kind requires; sections out of order; RFC capitals outside a spec rule's or objective's Statement.

## Why

- The cadence for spec rules comes from the first proposal (`sop/influx/proposed-verisectorium.md`, "Cadence of a rule file"), as do the spec store's normative-words rule and the per-kind sections.
- The SOP kinds' sections are this record's proposal. Each kind's check section is named after what it fails by: `when:` for a directive, How a violation shows for a convention (see [[def:sop-kinds]]).

## Working notes

- **Standing (Joseph, 2026-09-30):** this section order stays "proposed, or even exploratory". No decision adopts it yet, so it is a working convention, not a ratified one.
- The linter will need this per kind as data in `.vsect/kinds.yaml`. Required fields are there now (`requires:`, in both stores); required sections are not. Move them there once the linter exists, and keep this record as the explanation.
