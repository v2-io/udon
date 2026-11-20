# pre-design — open questions for spec-lite-0.1.0

Each question has two files:

| File | Holds | Who writes it |
|---|---|---|
| `NN-topic.md` | **Neutral:** the question, the alternatives, UDON examples and the tree each alternative produces, and interactions with other questions. No leans. | Claude (Opus 5.5), 2026-09-29 |
| `NN-topic.discussion.md` | **History and leans:** the full history of the question in chronological order (mainline UDON and v2, chats and files), then leans. | History agents write the history section **without seeing any lean**; Claude's initial lean (written before the history pass) and Joseph's current statements are added afterwards |

Files numbered 50–69 were raised by a history survey launched with a bare brief (no hints about where to look). Files numbered 70 and up were raised by a second, parallel survey whose brief listed where the coordinator had already seen relevant material. Running both is deliberate: two passes, and a comparison of what priming does.

**Terminology:** `../../references/def/` is the adopted vocabulary for identity, keys and referents (decided 2026-09-29). Use its words; lite's own definitions, including new terms, will go in `../lexicon.md` (not yet written).

`STEWARD-2026-09-29.md` records Joseph's in-session statements and leans from 2026-09-29 that aren't yet folded into `../README.md`.

## How to read the history sections

Joseph's words (2026-09-29):

- Order is chronological, because otherwise "whatever turned up last" feels most relevant.
- Older discussions are not more privileged than newer ones; newer ones are not more authoritative than older ones.
- Joseph's ideas, comments, and decisions are included but have no special status over agents' ideas and pushback. He reserves the right to change his mind about anything in the past.
- Joseph's chat examples usually illustrate several features at once. An example given for one rule does not mean he was advocating the other rules it happens to show.
- Most persuasive: whatever simplifies the grammar or rules without violating least surprise.

## Tree notation used in every file

```text
document                      <- the implied root node
└ element user                <- an element and its name
    $key   "jw"               <- attributes: label, then value ("…" = string; bare = typed)
    active true
    ├ text "Body text.\n"     <- content (children), in order
    └ element child
```

`typed "…"` is an explicit typed value `<…>` (called "box" in files written before 2026-09-29). `reserved "…"` marks refused future syntax. `anomaly:` lines give a warning or error and where it is.
