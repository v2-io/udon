---
source: ~/src/_ref/_arch/sar2/experiment/haiku-run-2025-11-16-n10/prompt_sar.txt (lines 1-16) — the actual in-context cheat-sheet handed to a model to teach it a brand-new notation before asking it to read code in it
gathered: 2026-07-21
status: gathered (verbatim excerpt — the 14-point cheat-sheet head only; full prompt is 591 lines = cheat-sheet + 761-line SAR game engine + 20 comprehension questions, not copied)
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/sar2/experiment/haiku-run-2025-11-16-n10/prompt_sar.txt:1-16
  - (identical cheat-sheet also at results/*/prompt_sar.txt across all model runs)
source_commit: (non-git) source_mtime 2025-11-16
categories: [agent-onboarding, cheat-sheet, in-context-notation-teaching, prompt-design, agent-ux, tier2-shipped-practice]
why_included: >
  A concrete artifact of HOW you teach an agent a notation it has never seen, inline,
  in a single prompt: 14 numbered rules, each a one-line "X instead of Y → concrete
  before/after" mapping, ordered structural-first (indentation, atoms, identifiers)
  → semantic (guards, error propagation, comprehensions) → cosmetic (alignment last).
  This is the working shape of UDON's agent-onboarding / cheat-sheet lane
  (ux/TODO-AGENT-UX.md): the empirical harness literally measured whether a model,
  given ONLY this teaching card, could then read and answer questions about
  non-trivial code in the notation — i.e. it tests the cheat-sheet's sufficiency,
  not just its existence. Note the terse contrastive format ("A instead of B →
  example") as a reusable template for any UDON quick-reference aimed at a model's
  first contact. For the harness consumer: evidence that a good notation ships with
  a compact, contrast-anchored teaching card, and that its adequacy is testable.
---

> **Provenance note.** This 14-point block is the verbatim head of the SAR-variant
> prompt. In the experiment the same document continues with the full 761-line SAR
> game engine (lines ~17-550) and 20 comprehension questions (lines ~551-591). Only
> the teaching card is copied here — it is the transferable artifact; the code+questions
> are the experiment payload (design described in sar2-experiment-README-GAME-ENGINE.md).

```text
Explanation of Sar vs Elixir:
1. Indentation-based: Blocks use indentation instead of do/end keywords → No do, end, or explicit delimiters needed.
2. Atoms: Single-quote prefix instead of colon → 'ok vs :ok
3. Identifiers: Kebab-case instead of snake_case → user-name vs user_name
4. Maps: Curlies with quote-colon instead of percent-curlies → {'ok: "hi"} vs %{ok: "hi"}
5. Function bodies: Colon starts body → fn add(a b): a + b vs def add(a, b) do a + b end
6. Guards: Use | prefix (guard-rails) for each guard condition, AND by default → fn foo(x) | x > 0 | x < 10: vs def foo(x) when x > 0 and x < 10 do
7. Type predicates: atom?(x), int?(x), str?(x), tuple?(x), map?(x), list?(x), nil?(x) → Type checks in guards
8. Error propagation: Use ! to return early if nil → attacker = get-entity(state id)! returns nil from function if get-entity returns nil
9. Nil chaining: Use ?. for safe property access → entity?.stats?.strength results in nil if any part is nil
10. List comprehensions: Erlang-style with pipes → [x*2 : x <- list | x > 0] generates doubled values for positive numbers
11. Where clauses: Main logic first, helpers after where → fn foo(x): result where result = complex-calculation(x)
12. Lists/Tuples: Whitespace-delimited → [1 2 3] and {'ok value}. Use (...) for expressions → [1 2 (n > 3 ? 0 : n)]
13. Pipes: Keep the pipe operator → x |> foo |> bar (same in both)
14. Alignment: Optional vertical alignment → Function clauses, patterns, and guards can align into visual columns
```
