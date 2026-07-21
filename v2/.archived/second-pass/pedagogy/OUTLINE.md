# Pedagogy outline (non-normative)

**Status:** outline only (**P4**). Not the legal contract.

## Disclosure ladder

1. **Prose holds together** — plain text is valid UDON; tables/Markdown-ish text survive because of commit-to-text.
2. **Name things** — `|element`, indent nesting, `:key value`. Heuristic: *whose name is it?*
3. **Point and classify** — `[key]`, `.trait`, flags `:done?`.
4. **Structure in sentences** — `|{…}`; braces = text, no braces = node value.
5. **Types without Norway** — bare is small/frozen; smart stuff in `<…>`.
6. **Dynamics & verbatim** — `!if` / `!{{x}}` / `!:lang:` (host meaning).

## Mental models

- Columns are the syntax.
- A line starts open and commits.
- `\` = “the rest is text” (position).
- Repeat a key to say it twice (stacking).
- When it looks wrong, content was kept (warnings).

## Idiom over allowance

| Need | Teach | Not |
|------|-------|-----|
| emphasis in prose | Markdown (when Layer-1 exists) | `\|{em}` for simple cases |
| code blocks | `!:lang:` | fences (unless byte-exact) |
| multi-value one key | stack the key | trailing text after a value |
| map-valued attr | named node carrier | attribute-under-attribute |
| element as value | `:x \|node` | braces |

Full tour → later; this outline is enough for agents writing examples.
