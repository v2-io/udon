# UDON Temporal Values Specification

**Draft extension to FULL-SPEC.md**

This document specifies syntactic recognition of date, time, datetime, duration,
and relative time values in UDON.

---

## Design Principles

1. **Syntactic typing**: Patterns are recognized by syntax, not sniffed from strings
2. **ISO 8601 as foundation**: The international standard for date/time interchange
3. **Practical shorthand**: Common duration forms from configuration conventions
4. **No ambiguity**: Patterns must not conflict with existing UDON types

---

## Dates

ISO 8601 calendar dates.

| Pattern | Type | Example |
|---------|------|---------|
| `YYYY-MM-DD` | Date | `2025-01-03` |
| `YYYY-MM` | YearMonth | `2025-01` |

```udon
:published 2025-01-03
:expires 2025-12
:fiscal-quarter 2025-01          ; host interprets as Q1
```

**Not recognized** (use strings):
- Year only: `2025` is Integer, use `"2025"` for year-as-string
- Week dates: `"2025-W01-1"`
- Ordinal dates: `"2025-032"`

---

## Times

ISO 8601 times of day (24-hour format).

| Pattern | Type | Example |
|---------|------|---------|
| `HH:MM:SS` | Time | `14:30:00` |
| `HH:MM:SS.nnn` | Time | `14:30:00.123` |
| `HH:MM` | Time | `14:30` |

```udon
:opens 09:00
:closes 17:30
:logged-at 14:30:00.123
```

**Fractional seconds**: Up to nanosecond precision (9 digits). Parser preserves
all provided digits; host decides internal representation.

```udon
:timestamp 14:30:00.123456789    ; nanosecond precision
```

**Not recognized** (use strings):
- 12-hour format: `"2:30 PM"`
- Informal times: `"noon"`, `"midnight"`

---

## DateTimes

ISO 8601 combined date and time, with optional timezone offset.

| Pattern | Type | Example |
|---------|------|---------|
| `<date>T<time>` | DateTime (local) | `2025-01-03T14:30:00` |
| `<date>T<time>Z` | DateTime (UTC) | `2025-01-03T14:30:00Z` |
| `<date>T<time>+HH:MM` | DateTime (offset) | `2025-01-03T14:30:00+05:30` |
| `<date>T<time>-HH:MM` | DateTime (offset) | `2025-01-03T14:30:00-08:00` |

```udon
:created 2025-01-03T14:30:00Z
:local-time 2025-01-03T14:30:00
:india-time 2025-01-03T20:00:00+05:30
```

The `T` separator is required (not space). This matches strict ISO 8601 and
avoids ambiguity.

**Timezone representation**:
- `Z` = UTC (Zulu time)
- `+HH:MM` or `-HH:MM` = fixed offset from UTC
- Named timezones (`America/New_York`) are not syntactically recognized; use
  strings and host interpretation

```udon
:meeting 2025-01-03T14:30:00
  :tz America/New_York           ; named timezone as separate attribute
```

---

## Durations

Two forms: ISO 8601 and shorthand.

### ISO 8601 Durations

| Pattern | Type | Example |
|---------|------|---------|
| `P[nY][nM][nD]` | Duration | `P1Y2M3D` |
| `PT[nH][nM][nS]` | Duration | `PT1H30M` |
| `P[date]T[time]` | Duration | `P1Y2M3DT4H5M6S` |
| `PnW` | Duration | `P2W` |

```udon
:lease P1Y                       ; 1 year
:rental P2M15D                   ; 2 months, 15 days
:timeout PT30S                   ; 30 seconds
:meeting PT1H30M                 ; 1 hour 30 minutes
:sprint P2W                      ; 2 weeks
```

**Rules**:
- `P` prefix required (Period)
- `T` separates date components from time components
- At least one component required after `P` (or after `T` if time-only)
- Components in order: Y, M, D, then T, then H, M, S
- Fractional values allowed on smallest unit: `PT1.5H`, `P0.5D`

### Shorthand Durations

Common configuration-style durations.

| Pattern | Meaning | ISO 8601 Equivalent |
|---------|---------|---------------------|
| `Ns` | N seconds | `PTnS` |
| `Nm` | N minutes | `PTnM` |
| `Nh` | N hours | `PTnH` |
| `Nd` | N days | `PnD` |
| `Nw` | N weeks | `PnW` |
| `Nmo` | N months | `PnM` |
| `Ny` | N years | `PnY` |

```udon
:ttl 30s                         ; 30 seconds
:cache 5m                        ; 5 minutes
:session 2h                      ; 2 hours
:retention 90d                   ; 90 days
:billing-cycle 1mo               ; 1 month
:contract 2y                     ; 2 years
```

**Rules**:
- Integer or decimal number followed by unit suffix
- No space between number and unit
- Case-insensitive units: `30S`, `30s`, `5M`, `5m` (recommended: lowercase)
- `m` = minutes, `mo` = months (no ambiguity: `mo` requires two characters)
- Fractional values allowed: `1.5h`, `0.5d`

**Compound shorthand**: Not supported. Use ISO 8601 for compound durations.

```udon
:duration P1DT12H                ; 1 day, 12 hours (ISO 8601)
:duration 36h                    ; alternative: 36 hours (shorthand)
; NOT: 1d12h                     ; compound shorthand not recognized
```

---

## Relative Times (Offsets)

Offsets from an implicit reference point (typically "now").

| Pattern | Meaning | Example |
|---------|---------|---------|
| `+<duration>` | Future offset | `+30d` |
| `-<duration>` | Past offset | `-1h` |

```udon
:expires +30d                    ; 30 days from now
:reminder -1h                    ; 1 hour ago
:deadline +2w                    ; 2 weeks from now
:last-seen -5m                   ; 5 minutes ago
```

Both ISO 8601 and shorthand durations work with offset prefixes:

```udon
:next-review +P3M                ; 3 months from now (ISO)
:next-review +3mo                ; 3 months from now (shorthand)
:created -P1Y2M3D                ; 1 year, 2 months, 3 days ago
```

**Semantics**: The parser emits a RelativeTime value with direction and
duration. The host resolves the reference point (typically current time) and
computes the absolute value.

```
RelativeTime { direction: Future, duration: Duration { days: 30 } }
```

**Reference point**: By default, "now" (evaluation time). Hosts may support
explicit reference:

```udon
:due +7d                         ; 7 days from now (default)
:due +7d :from 2025-01-01        ; 7 days from Jan 1 (explicit, host-defined)
```

---

## Recognition Priority

When parsing a bare value, the parser attempts recognition in this order:

1. **Boolean**: `true`, `false`
2. **Nil**: `null`, `nil`
3. **Relative time**: `+` or `-` followed by duration pattern
4. **DateTime**: Date `T` Time pattern
5. **Date**: `YYYY-MM-DD` or `YYYY-MM` pattern
6. **Time**: `HH:MM:SS` or `HH:MM` pattern
7. **Duration (ISO)**: `P...` pattern
8. **Duration (shorthand)**: Number followed by `s|m|h|d|w|mo|y`
9. **Number**: Integer, float, rational, complex patterns
10. **String**: Everything else (bare string)

This ordering ensures:
- `+30d` is RelativeTime, not a malformed number
- `2025-01-03` is Date, not a subtraction expression
- `14:30` is Time, not a ratio (rationals require `r` suffix)
- `30d` is Duration, not a hex number (hex requires `0x` prefix)

---

## Edge Cases

### Ambiguity: `m` vs `mo`

Minutes use `m`, months use `mo`. No ambiguity because:
- `5m` → 5 minutes (single character suffix)
- `5mo` → 5 months (two character suffix)

Parser checks for `mo` before `m`.

### Ambiguity: Year vs Integer

`2025` alone is Integer, not Year. For year-only values:
- Use YearMonth: `2025-01`
- Use explicit string: `"2025"`
- Use attribute semantics: `:year 2025` (host knows it's a year from key name)

### Ambiguity: Duration `m` vs `M`

ISO 8601 uses `M` for both months (in date portion) and minutes (in time portion):
- `P2M` → 2 months (before `T`)
- `PT2M` → 2 minutes (after `T`)

Shorthand avoids this: `2mo` vs `2m`.

### Midnight and Noon

ISO 8601 allows `24:00:00` for end-of-day midnight. UDON recognizes this:

```udon
:closes 24:00:00                 ; end of day (equivalent to next day 00:00:00)
:opens 00:00:00                  ; start of day
```

The parser emits `hour: 24` literally, preserving the semantic distinction between
"end of Jan 3" and "start of Jan 4". Hosts may normalize if desired.

### Negative Durations

ISO 8601 doesn't define negative durations. In UDON, use relative time syntax:

```udon
:adjustment -P1D                 ; 1 day in the past (relative)
; NOT: P-1D                      ; invalid
```

---

## Validation and Warnings

This section documents strictness decisions for temporal parsing. The parser
follows ISO 8601 strictly where practical, with warnings for common mistakes.

### Leading Zeros Required

ISO 8601 requires leading zeros in dates and times. Values without leading zeros
are not recognized as temporal types:

```udon
:date 2025-01-03                 ; Date (valid)
:date 2025-1-3                   ; WARNING: missing leading zeros -> bare string
:time 09:30                      ; Time (valid)
:time 9:30                       ; WARNING: missing leading zero -> bare string
```

**Behavior:** Warn, then parse as bare string (not a temporal value).

### Week Durations Cannot Mix with Other Components

ISO 8601 prohibits combining weeks with other date/time components:

```udon
:span P2W                        ; Duration: 2 weeks (valid)
:span P1W2D                      ; INVALID: weeks + days
:span P2WT4H                     ; INVALID: weeks + hours
```

**Behavior:** Warn and reject (parse as bare string).

### Fractional Values Only on Smallest Unit

ISO 8601 allows decimal fractions only on the smallest (rightmost) component:

```udon
:duration PT1.5H                 ; Duration: 1.5 hours (valid)
:duration PT1H30M                ; Duration: 1h 30m (valid)
:duration PT1.5H30M              ; INVALID: fractional H followed by M
:duration P1.5DT2H               ; INVALID: fractional D followed by T...H
```

**Behavior:** Warn and reject (parse as bare string).

### Negative Zero Offset

Some systems produce `-00:00` for UTC. UDON accepts this as equivalent to
`Z` or `+00:00`:

```udon
:timestamp 2025-01-03T14:30:00-00:00   ; Accepted as UTC (no warning)
:timestamp 2025-01-03T14:30:00Z        ; Canonical UTC
:timestamp 2025-01-03T14:30:00+00:00   ; Also UTC
```

**Behavior:** Accept silently as UTC.

### Fractional Seconds Precision

The parser preserves all provided fractional second digits (up to implementation
limits). Hosts receive the full precision and decide their internal representation:

```udon
:timestamp 14:30:00.123456789012       ; All digits preserved
```

**Behavior:** Preserve all digits. Hosts may warn if precision exceeds their
capability, but the parser does not truncate or reject.

### Empty Duration Components

A duration must have at least one component after `P` (or after `T` for time-only):

```udon
:duration P1D                    ; Valid
:duration PT30S                  ; Valid
:duration P                      ; INVALID: no components -> bare string "P"
:duration PT                     ; INVALID: T but no time components -> bare string "PT"
```

**Behavior:** No warning (unambiguous non-match). Parse as bare string.

### Warning Summary

| Condition | Warning? | Result |
|-----------|----------|--------|
| Missing leading zeros | Yes | Bare string |
| Weeks mixed with other components | Yes | Bare string |
| Fractional on non-smallest unit | Yes | Bare string |
| Negative zero offset (`-00:00`) | No | Accept as UTC |
| Excess fractional second digits | No (host may) | Preserve all |
| Empty duration (`P`, `PT`) | No | Bare string |

---

## Examples

### Configuration

```udon
|cache
  :ttl 5m
  :max-age 1h
  :stale-while-revalidate 30s

|session
  :timeout 30m
  :absolute-timeout 8h
  :remember-me 30d

|certificate
  :issued 2025-01-03
  :expires 2026-01-03
  :renew-before -30d             ; 30 days before expiry
```

### Scheduling

```udon
|meeting
  :starts 2025-01-15T10:00:00-05:00
  :duration PT1H30M
  :reminder -15m                 ; 15 minutes before

|recurring
  :first 2025-01-01
  :interval P2W                  ; every 2 weeks
  :until 2025-12-31
```

### Logging

```udon
|event
  :timestamp 2025-01-03T14:30:00.123456Z
  :level info
  :message Connection established

|metric
  :recorded 2025-01-03T14:30:00Z
  :window 5m
  :value 42.5
```

---

## Parser Events

The parser emits **typed events with raw string content**:

```rust
// Parser output - type tag with original string
Date { content: "2025-01-03", span: 0..10 }
Time { content: "14:30:00.123", span: 0..12 }
DateTime { content: "2025-01-03T14:30:00Z", span: 0..20 }
Duration { content: "PT1H30M", span: 0..7 }
RelativeTime { content: "+30d", span: 0..4 }
```

### Why Raw Strings, Not Parsed Components?

The parser validates patterns character-by-character without lookahead. Consider:

```
2026-03-24T03:12:4.993290109288-says-what
```

This looks like a DateTime until we reach the invalid ending. Without lookahead,
we don't know whether something is a valid temporal value until we've validated
the **entire pattern**. If we emitted sub-events (Year, Month, Day...) as we
parsed, invalid inputs would leave orphaned partial events.

The solution: validate the full pattern through the state machine, emit a single
typed event only on successful completion. If validation fails at any point,
fall through to BareValue.

### What the Parser Provides

1. **Type discrimination**: "This is a Duration, not a bare string"
2. **Pattern validation**: The string conforms to the expected format
3. **Original representation**: Preserved exactly (e.g., `24:00:00` vs `00:00:00`)

### Host Responsibility

Hosts parse the validated string into native types. This is straightforward
because the parser has already determined the type:

```ruby
# Ruby example
case event
when :Duration
  parse_iso_duration(content)  # We know it's valid ISO 8601
when :Date
  Date.parse(content)          # We know it's YYYY-MM-DD or YYYY-MM
end
```

Hosts convert to their preferred datetime representations (chrono, time, jiff,
DateTime, Time, etc.).

---

## Open Questions

1. **Intervals**: Should `2025-01-01/2025-12-31` be recognized? Deferred for now.

2. **Recurring patterns**: RRULE-style recurrence (`FREQ=WEEKLY;BYDAY=MO,WE,FR`)?
   Likely too complex for syntactic recognition; use structured elements.

3. **Fiscal/business calendars**: `2025-Q1`, `2025-H2`? Probably host-defined.

4. **Timezone database**: Should UDON specify IANA timezone behavior? Probably
   leave to host, with recommendation to use IANA names as strings.
