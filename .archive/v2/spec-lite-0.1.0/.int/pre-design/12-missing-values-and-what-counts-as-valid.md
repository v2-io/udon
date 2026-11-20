# 12 — Warnings, errors, and what counts as "valid lite"

## Why this matters

The lite contract is "any document a lite parser accepts means the same under every future version." So what does *accepts* mean — a document with no anomalies at all, with no errors, or something in between?

## The current anomaly set (0.10.0 §14; K6, K8, K14, L1, L4)

| Situation | Severity | What's kept |
|---|---|---|
| `:label` with no value (`\|el :a :b 1` → `a`) | **Error** (the only core error) | `a nil` |
| `:done?` alone (flags are retired, K12) | Error | `done? nil` |
| Attribute after the element's content has begun | Warning | accepted as an attribute |
| `:label` line directly under an open attribute body | Warning | kept as text of that body |
| Tab in indentation | Warning | line kept as text |
| Unclosed `[key]` | Warning | `$partial-key` |
| Unclosed string, list, `\|{`, `<`, or fence at end of input | Warning | content kept; result = incomplete-input |
| Top-level `:label` | Warning | kept as text (but see [04](04-root-and-top-level-text.md)) |
| Inconsistent text indentation | Warning | re-based |
| Reserved syntax | ? (see [09](09-reserved-syntax.md)) | ? |

## Q1 — What does "valid lite" mean?

- **A)** no anomalies of any kind;
- **B)** no errors (warnings allowed, since their keep shapes mean the same in every version);
- **C)** an explicit list: each anomaly is marked forward-stable (allowed) or not (makes the document not-valid-lite).

Consequence: under B, a warning's keep shape becomes a permanent promise. For example, "a late attribute is still an attribute" could never later become "late attribute lines are text."

## Q2 — Missing value

```udon
|task :done :owner sam
```

- **A, error + nil** (K6: this catches deleted or forgotten values):
  ```text
  element task
      done  nil       ; anomaly: error, missing value
      owner "sam"
  ```
- **B, nil silently.**
- **C, `true`** (the old flag reading; retired by K12).

## Q3 — Late attributes

```udon
|el
  Some text.
  :late 1
```

- **A)** attribute + warning (K14);
- **B)** attribute, silently; or
- **C)** text + warning (the earlier rule).

## Interactions

- [04](04-root-and-top-level-text.md), [05](05-values-across-lines.md), and [09](09-reserved-syntax.md): each adds or removes anomalies.
