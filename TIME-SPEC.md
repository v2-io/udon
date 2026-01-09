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

### Negative Durations

ISO 8601 doesn't define negative durations. In UDON, use relative time syntax:

```udon
:adjustment -P1D                 ; 1 day in the past (relative)
; NOT: P-1D                      ; invalid
```

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

The parser emits typed events for temporal values:

```rust
enum TemporalValue {
    Date { year: u16, month: u8, day: Option<u8> },
    Time { hour: u8, minute: u8, second: u8, nanos: u32 },
    DateTime { date: Date, time: Time, offset: Option<Offset> },
    Duration { years: u32, months: u32, days: u32,
               hours: u32, minutes: u32, seconds: u32, nanos: u32 },
    RelativeTime { direction: Direction, duration: Duration },
}

enum Offset {
    Utc,
    Fixed { hours: i8, minutes: u8 },
}

enum Direction {
    Past,    // -
    Future,  // +
}
```

Hosts convert these to their preferred datetime representations (chrono,
time, jiff, NaiveDateTime, etc.).

---

## Open Questions

1. **Intervals**: Should `2025-01-01/2025-12-31` be recognized? Deferred for now.

2. **Recurring patterns**: RRULE-style recurrence (`FREQ=WEEKLY;BYDAY=MO,WE,FR`)?
   Likely too complex for syntactic recognition; use structured elements.

3. **Fiscal/business calendars**: `2025-Q1`, `2025-H2`? Probably host-defined.

4. **Timezone database**: Should UDON specify IANA timezone behavior? Probably
   leave to host, with recommendation to use IANA names as strings.
