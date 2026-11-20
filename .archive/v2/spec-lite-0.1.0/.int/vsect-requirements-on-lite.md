# vsect's requirements on lite: input for the pre-design questions

*For the udon team, from the spec-lite SOP work (2026-09-30). These are one customer's requirements, weighed like anyone's input. They are not decisions. Everything written from the SOP side is example, proposed or template; lite's own decisions belong to the udon team.*

## Why vsect has requirements at all

The planned pipeline is spec-lite → a lite parser → vsect → aat-refactored. Later, spec-lite 0.1.1 is to be written *in* lite and managed *by* vsect. That makes the spec corpus, and vsect behind it, lite's first real customer. Each item below names the pre-design question it bears on.

The most binding are items 1 (fences, question 11) and 4 (source spans in the tree, questions 60 and 13).

## The requirements

*Carried verbatim from the "What vsect wants from lite" section of `sop/influx/proposed-verisectorium.md`, a fork's reading, not yet checked by anyone else.*

1. **Fences must be robust.** The spec corpus is full of udon examples, including reserved syntax (`!if`, `@{…}`) in cases and explanations. Once the spec is written in lite, those examples can live only in fences, because `!:kind:` is reserved (11) and `<…>` closes at the first `>` (07; audit 2026-09-01). Fence content must never be scanned for reserved syntax, and a fence must be able to hold a fence (11 Q3). This is the most binding requirement I found.
2. **Status has no spelling in lite, which is right.** The RC1 udon spike (`firmatum/verisectorium/theory/influx/segments-model-rc1/lang/rc1-in-udon.ud`) made each status cell a `!` generator. Lite reserves `!`, so under lite, projections live only in vsect's output and never in files. That lands exactly where RC1 wants it: hand-set status is inexpressible. Nothing is lost; the spike's spelling waits for full UDON.
3. **Edges are plain names.** `@record[x]` is reserved, so edges are written like `per: [implied-root]` and vsect resolves them. Upgrading them to `@` later is a migration, and the forward contract guarantees the lite spelling keeps its meaning.
4. **Source spans in the tree** (60, 13, STEWARD "layers of the tree"). vsect's `revise` has to tell which named spans changed. It needs line, column, and span on every node as `meta`, even if round-trip of ornament stays optional. That is a concrete vote for specifying "content + meta" rather than leaving it optional.
5. **Append-safety** (68). ADR logs, event trails, and question logs are appended by agents without reading. vsect wants 68's option A, or at least B.
6. **Duplicate keys surface, never merge** (54). Two records with one slug is a `collide` in the addressing theory's terms; vsect needs both kept and the collision visible.
7. **First-line greppability** (68). `grep '^|decision\['` should find every record with its identity and key attributes on one line (77, 74).
8. **`@` inside ordinary values** (09 Q1). Strings like `parser@0.10.01` and email addresses put `@` mid-token. Lite should say plainly whether that is reserved.
9. **Stacked vs list** (65, 83, K15). vsect doesn't care which spelling wins, only that the tree says whether `:depends a :depends b` and `:depends [a b]` are the same.

## Working notes

- Where this came from: `sop/influx/proposed-verisectorium.md`, "What vsect wants from lite". If the two disagree, that section is the source, so update this note from it.
- Only questions 01, 04, 06, 07, 09, 11, 12, 13, 54, 60, 68, 84 and 86 were read whole when these requirements were written. The others were known from their titles only.
