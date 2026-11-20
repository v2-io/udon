# Dialect: `temporal@1`

**Status:** normative for the first standard temporal Dialect.  
**Core rule:** temporal values appear only inside Envelopes `<…>` in value position. A bare `2025-01-03` is the string `"2025-01-03"`.

This document recasts the scrubbed TIME-SPEC value *grammar* for use **inside** envelopes. It does not restore bare recognition.

---

## 1. Envelope spellings

| Unlabelled (if temporal@1 claims first) | Type-labelled | Examples |
|------------------------------------------|---------------|----------|
| `<2025-01-03>` | `<date:2025-01-03>` | Date |
| `<14:30>` | `<time:14:30>` | Time |
| `<2025-01-03T14:30:00Z>` | `<datetime:…>` | DateTime |
| `<PT1H30M>` or `<5m>` | `<duration:…>` | Duration |
| `<+30d>` | `<relative:…>` | RelativeTime |

Dialect-and-type form: `<temporal:date:2025-01-03>` (and similarly).

If the Dialect is not loaded, Core keeps the envelope text and signals unresolved (CORE §11.6).

---

## 2. Design principles

1. Syntactic patterns (no sniffing of arbitrary strings outside patterns).
2. ISO 8601 foundation.
3. Practical shorthand durations for configuration.
4. No collision with Frozen Core Scalars (envelope boundary enforces this).

---

## 3. Dates

| Pattern | Type | Example |
|---------|------|---------|
| `YYYY-MM-DD` | Date | `2025-01-03` |
| `YYYY-MM` | YearMonth | `2025-01` |

Not recognized as temporal (remain non-claim / string body failure → unresolved or Error per Host): year-only `2025`, week dates, ordinal dates without quotes in a non-matching envelope.

Leading zeros required; missing zeros → Dialect declines claim (body stays unresolved string content / Warning).

---

## 4. Times

| Pattern | Type | Example |
|---------|------|---------|
| `HH:MM` | Time | `14:30` |
| `HH:MM:SS` | Time | `14:30:00` |
| `HH:MM:SS.fn` | Time | `14:30:00.123` |

Fractional seconds: up to implementation precision; all provided digits preserved in the raw string. `24:00:00` allowed (end-of-day); preserved literally.

No 12-hour or informal times.

---

## 5. DateTimes

| Pattern | Example |
|---------|---------|
| `<date>T<time>` | `2025-01-03T14:30:00` |
| `…Z` | UTC |
| `…+HH:MM` / `…-HH:MM` | fixed offset |

`T` required (not space). Named timezones are not syntactic; use a separate Attribute or string.

`-00:00` accepted as UTC-equivalent to `Z` / `+00:00`.

---

## 6. Durations

### 6.1 ISO 8601

`P[nY][nM][nD][T[nH][nM][nS]]`, `PnW`, etc. Standard ordering; fractional only on smallest unit; weeks not mixed with other components.

### 6.2 Shorthand

| Pattern | Meaning |
|---------|---------|
| `Ns` | seconds |
| `Nm` | minutes |
| `Nh` | hours |
| `Nd` | days |
| `Nw` | weeks |
| `Nmo` | months |
| `Ny` | years |

No space; `mo` before `m` in matching. Case-insensitive units; lowercase recommended. No compound shorthand (`1d12h` invalid); use ISO or single unit.

---

## 7. Relative times

`+<duration>` / `-<duration>` with ISO or shorthand duration.  
Semantics: direction + duration; Host supplies reference instant (default now).

---

## 8. Claim algorithm (inside envelope body)

After stripping optional type labels, the Dialect attempts patterns in order:

1. Relative time (`+`/`-` + duration)
2. DateTime
3. Date / YearMonth
4. Time
5. Duration ISO
6. Duration shorthand

On full-pattern success: claim with type tag + **raw body string** (not eagerly decomposed components — avoids partial orphans on near-misses).  
On failure: decline; Core/Host handle unresolved.

---

## 9. Host projection

Hosts parse the validated raw string into native date/time types. Core and this Dialect guarantee pattern validity + type tag, not a particular timezone database behavior.

---

## 10. Open (non-blocking)

- Intervals `start/end`
- RRULE-style recurrence (prefer structured Elements)
- Fiscal quarters as syntactic forms
- IANA timezone names inside the envelope
