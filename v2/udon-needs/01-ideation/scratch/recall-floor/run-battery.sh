#!/usr/bin/env bash
# Recall-floor battery: a broad lexical net over the estate + adjacent roots.
# Goal: recall over precision. A relevant file that matches NO query is the
# failure this guards against. Run from anywhere; writes into ./hits/.
# Reproducible: re-running regenerates every hits-*.txt.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HITS="$HERE/hits"
mkdir -p "$HITS"

ROOTS=( "$HOME/src" "$HOME/vaults" "$HOME/src-ext" )

# --- Exclusion patterns (mechanically-obvious noise only) -------------------
# rg: glob excludes. find: -prune on dir names. Logged verbatim in BATTERY.md.
RG_EXCLUDES=(
  --glob '!**/.git/**'
  --glob '!**/node_modules/**'
  --glob '!**/target/**'
  --glob '!**/deps/**'
  --glob '!**/.venv/**'
  --glob '!**/venv/**'
  --glob '!**/__pycache__/**'
  --glob '!**/.mypy_cache/**'
  --glob '!**/dist/**'
  --glob '!**/build/**'
)
# rg flags: -l list files, -i case-insensitive, --no-ignore (do NOT respect
# .gitignore — gitignored files can be exactly the un-accounted-for ones),
# --hidden (search dotfiles/dirs; .git re-excluded above), -F fixed strings
# passed per-query. rg auto-skips binary.
RG_BASE=( rg -li --no-ignore --hidden "${RG_EXCLUDES[@]}" )

# find prune expression (dir basenames)
FIND_PRUNE=( -type d \( -name .git -o -name node_modules -o -name target -o -name deps -o -name .venv -o -name venv -o -name __pycache__ -o -name .mypy_cache -o -name dist -o -name build \) -prune -o )

# --- Filename queries (find -iname) -----------------------------------------
# slug|glob-pattern
FN_QUERIES=(
  "tool|*tool*"
  "agent|*agent*"
  "instrumenta|*instrumenta*"
  "praxes|*praxes*"
  "praxis|*praxis*"
  "tooling|*tooling*"
  "cli|*cli*"
  "harness|*harness*"
  "operata|*operata*"
  "agentic|*agentic*"
  "affordance|*affordance*"
  "cheat|*cheat*"
  "scaffold|*scaffold*"
  "needs|*needs*"
  "demand|*demand*"
  "guardrail|*guardrail*"
  "prompt|*prompt*"
)

# --- Content queries (rg -li, fixed strings) --------------------------------
# slug|literal
CT_QUERIES=(
  "principled-tool|principled tool"
  "for-agents|for agents"
  "agent-facing|agent-facing"
  "tool-use|tool-use"
  "agentic|agentic"
  "crystallized|crystallized"
  "instrumenta|instrumenta"
  "quick-tool|quick-tool"
  "agentic-tooling|agentic tooling"
  "tools-for-agents|tools for agents"
  "tool-for-agents|tool for agents"
  "agent-tool|agent tool"
  "agent-facing-tool|agent-facing tool"
  "harness-facing|harness-facing"
  "edit-representation|edit representation"
  "edit-tool|edit tool"
  "tool-schema|tool schema"
  "tool-definition|tool definition"
  "tool-calling|tool calling"
  "affordance|affordance"
  "guardrail|guardrail"
  "cross-tier|cross-tier"
  "memory-system|memory system"
  "context-system|context system"
  "context-engineering|context engineering"
  "feedback-loop|feedback loop"
  "agent-loop|agent loop"
  "demand-side|demand-side"
  "demand-first|demand-first"
  "praxes|praxes"
  "operata|operata"
  "orchestrator-worker|orchestrator-worker"
  "multi-agent|multi-agent"
  "agents-need|agents need"
  "what-agents-need|what agents need"
  "mcp-tool|mcp tool"
  "tool-suite|tool suite"
  "self-chunking|self-chunking"
  "meta-tool|meta-tool"
  "propose-apply|propose-apply"
  "patch-tool|patch tool"
  "diff-tool|diff tool"
)

echo "### FILENAME QUERIES ###"
for q in "${FN_QUERIES[@]}"; do
  slug="${q%%|*}"; pat="${q#*|}"
  out="$HITS/hits-fn-${slug}.txt"
  : > "$out"
  for r in "${ROOTS[@]}"; do
    find "$r" "${FIND_PRUNE[@]}" -type f -iname "$pat" -print 2>/dev/null >> "$out"
  done
  sort -u "$out" -o "$out"
  printf "fn:%-14s pat=%-16s hits=%s\n" "$slug" "$pat" "$(wc -l < "$out" | tr -d ' ')"
done

echo "### CONTENT QUERIES ###"
for q in "${CT_QUERIES[@]}"; do
  slug="${q%%|*}"; lit="${q#*|}"
  out="$HITS/hits-ct-${slug}.txt"
  "${RG_BASE[@]}" -F "$lit" "${ROOTS[@]}" 2>/dev/null | sort -u > "$out"
  printf "ct:%-20s lit=%-24s hits=%s\n" "$slug" "$lit" "$(wc -l < "$out" | tr -d ' ')"
done

echo "DONE"
