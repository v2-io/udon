# Spike: session-vault

Full session transcripts for **retrieval** (find the place, re-read the life).  
Not a summary/rubric system. Not a substitute for DECISIONS/SPEC.

## Layout

```text
raw/grok/     Grok native exports (grok export <id>)
raw/claude/   Claude JSONL → markdown extracts (+ INVENTORY.md)
extract_claude_jsonl.py
NOTES.md      early format notes
```

Canonical vault is **in-repo under this spike**.  
A mirror under `~/.grok/memory/udon-4fdadfea/sessions/vault-{grok,claude}-*` exists so experimental-memory **search can index** the same prose (sync-on-search). Re-copy after adding exports:

```bash
# after new grok export
for f in v2-spec/spikes/session-vault/raw/grok/*.md; do
  base=$(basename "$f" .md)
  { echo "<!-- vault: $f -->"; echo; cat "$f"; } \
    > ~/.grok/memory/udon-4fdadfea/sessions/vault-grok-${base}.md
done
# after claude extract
python3 v2-spec/spikes/session-vault/extract_claude_jsonl.py
# then same pattern for raw/claude/<id8>-*.md → vault-claude-*
# poke: any memory_search in a memory-enabled session reindexes dirty .md
```

## Reproduce

```bash
# Grok
grok export <SESSION_ID> v2-spec/spikes/session-vault/raw/grok/<id8>-slug.md

# Claude (all udon project jsonl)
python3 v2-spec/spikes/session-vault/extract_claude_jsonl.py
python3 v2-spec/spikes/session-vault/extract_claude_jsonl.py --force
```

## Inventory

See `raw/claude/INVENTORY.md` and `raw/grok/INVENTORY.md`.
