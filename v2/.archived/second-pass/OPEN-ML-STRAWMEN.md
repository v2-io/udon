# Multi-line strawmen (non-normative)

**Not law.** OPEN **ML** remains WAIT-DEMAND.  
This file freezes the *evidence set* so agents stop re-deriving “what did greenfields say?”

| Construct | 2a (Fable) | 3a (Gemini) | 3b (Grok, post-Fable) |
|-----------|------------|-------------|------------------------|
| `\|{…}` | multi-line (settled) | multi-line | multi-line (settled) |
| Fence | multi-line | multi-line | multi-line |
| Envelope `<…>` | multi-line | multi-line | multi-line |
| Quoted strings | open / lean multi | multi-line | multi-line (this suite) |
| Lists `[…]` | open / lean multi | multi-line | multi-line (newlines = item ws) |
| `!{{…}}` | open / lean multi | multi-line | multi-line |
| Identity `[…]` / ref key | open; lean **line-bound** | multi-line (all) | **line-bound** → `$partial-key` |
| `;{…}` / `!{…}` / `!{:…}` | open w/ dialect work | multi-line (all) | **open** (document-swallow risk) |

**0.9 live (R3):** remaining delimited multi-line largely undefined / warn-before-disallow.

**Demand pull (from spikes, still not pins):** agent stream/edit mid-line; path embeddability terminators; incomplete-input twins.

Close **ML** only with DECISIONS rows + SPEC §14.2 table — not by editing this file into law.
