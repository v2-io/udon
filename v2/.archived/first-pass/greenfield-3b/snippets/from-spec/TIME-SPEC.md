# udon snippets lifted from TIME-SPEC.md (scrubbed spec)

## Dates

```udon
:published 2025-01-03
:expires 2025-12
:fiscal-quarter 2025-01          ; host interprets as Q1
```

## Times

```udon
:opens 09:00
:closes 17:30
:logged-at 14:30:00.123
```

## Times

```udon
:timestamp 14:30:00.123456789    ; nanosecond precision
```

## DateTimes

```udon
:created 2025-01-03T14:30:00Z
:local-time 2025-01-03T14:30:00
:india-time 2025-01-03T20:00:00+05:30
```

## DateTimes

```udon
:meeting 2025-01-03T14:30:00
  :tz America/New_York           ; named timezone as separate attribute
```

## ISO 8601 Durations

```udon
:lease P1Y                       ; 1 year
:rental P2M15D                   ; 2 months, 15 days
:timeout PT30S                   ; 30 seconds
:meeting PT1H30M                 ; 1 hour 30 minutes
:sprint P2W                      ; 2 weeks
```

## Shorthand Durations

```udon
:ttl 30s                         ; 30 seconds
:cache 5m                        ; 5 minutes
:session 2h                      ; 2 hours
:retention 90d                   ; 90 days
:billing-cycle 1mo               ; 1 month
:contract 2y                     ; 2 years
```

## Shorthand Durations

```udon
:duration P1DT12H                ; 1 day, 12 hours (ISO 8601)
:duration 36h                    ; alternative: 36 hours (shorthand)
; NOT: 1d12h                     ; compound shorthand not recognized
```

## Relative Times (Offsets)

```udon
:expires +30d                    ; 30 days from now
:reminder -1h                    ; 1 hour ago
:deadline +2w                    ; 2 weeks from now
:last-seen -5m                   ; 5 minutes ago
```

## Relative Times (Offsets)

```udon
:next-review +P3M                ; 3 months from now (ISO)
:next-review +3mo                ; 3 months from now (shorthand)
:created -P1Y2M3D                ; 1 year, 2 months, 3 days ago
```

## Relative Times (Offsets)

```udon
:due +7d                         ; 7 days from now (default)
:due +7d :from 2025-01-01        ; 7 days from Jan 1 (explicit, host-defined)
```

## Midnight and Noon

```udon
:closes 24:00:00                 ; end of day (equivalent to next day 00:00:00)
:opens 00:00:00                  ; start of day
```

## Negative Durations

```udon
:adjustment -P1D                 ; 1 day in the past (relative)
; NOT: P-1D                      ; invalid
```

## Leading Zeros Required

```udon
:date 2025-01-03                 ; Date (valid)
:date 2025-1-3                   ; WARNING: missing leading zeros -> bare string
:time 09:30                      ; Time (valid)
:time 9:30                       ; WARNING: missing leading zero -> bare string
```

## Week Durations Cannot Mix with Other Components

```udon
:span P2W                        ; Duration: 2 weeks (valid)
:span P1W2D                      ; INVALID: weeks + days
:span P2WT4H                     ; INVALID: weeks + hours
```

## Fractional Values Only on Smallest Unit

```udon
:duration PT1.5H                 ; Duration: 1.5 hours (valid)
:duration PT1H30M                ; Duration: 1h 30m (valid)
:duration PT1.5H30M              ; INVALID: fractional H followed by M
:duration P1.5DT2H               ; INVALID: fractional D followed by T...H
```

## Negative Zero Offset

```udon
:timestamp 2025-01-03T14:30:00-00:00   ; Accepted as UTC (no warning)
:timestamp 2025-01-03T14:30:00Z        ; Canonical UTC
:timestamp 2025-01-03T14:30:00+00:00   ; Also UTC
```

## Fractional Seconds Precision

```udon
:timestamp 14:30:00.123456789012       ; All digits preserved
```

## Empty Duration Components

```udon
:duration P1D                    ; Valid
:duration PT30S                  ; Valid
:duration P                      ; INVALID: no components -> bare string "P"
:duration PT                     ; INVALID: T but no time components -> bare string "PT"
```

## Configuration

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

## Scheduling

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

## Logging

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
