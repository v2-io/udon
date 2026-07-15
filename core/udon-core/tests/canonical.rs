//! Canonical tests loaded from YAML fixtures
//!
//! Runs each fixture test case:
//! 1. Canonical (exact input → exact events)
//! 2. With variations (stochastic context wrapping)
//!
//! Tests with empty `events: []` are TODO tests - they run the parser
//! to check for panics but don't compare output.

mod common;

use common::{load_fixtures_by_name, run_test, run_with_variations, Gen};

/// Run canonical tests for a fixture file
fn run_fixture(name: &str) {
    let failures = collect_fixture_failures(name);
    if !failures.is_empty() {
        panic!("\n{} tests failed:\n  {}", failures.len(), failures.join("\n  "));
    }
}

/// Run a fixture file's cases, returning failure labels instead of panicking,
/// so a multi-file gate can report the whole picture in one run.
fn collect_fixture_failures(name: &str) -> Vec<String> {
    let cases = load_fixtures_by_name(name);
    let mut gen = Gen::from_env_or_random();
    let mut failures = Vec::new();
    let mut todo_count = 0;

    for case in &cases {
        // Track TODO tests
        if case.events.is_empty() {
            todo_count += 1;
        }

        // Canonical test (exact match)
        let result = run_test(case);
        if !result.passed {
            result.print_failure(&format!("{}::{} (canonical)", name, case.id));
            failures.push(format!("{}::{}", name, case.id));
        }

        // Variation tests (Poisson count, default λ=3)
        let variation_count = std::env::var("UDON_TEST_COUNT")
            .ok()
            .and_then(|s| s.parse().ok())
            .unwrap_or_else(|| gen.poisson(3.0).max(1));

        for i in 0..variation_count {
            let result = run_with_variations(case, &mut gen);
            if !result.passed {
                result.print_failure(&format!("{}::{} (variation {})", name, case.id, i));
                failures.push(format!("{}::{} (var {})", name, case.id, i));
            }
        }
    }

    if !failures.is_empty() {
        eprintln!(
            "{}: {} of {} cases failed (seed {}; set UDON_TEST_SEED={} to reproduce)",
            name,
            failures.len(),
            cases.len(),
            gen.seed,
            gen.seed
        );
    }
    if todo_count > 0 {
        eprintln!("  {} - {} tests ({} TODO with empty events)", name, cases.len(), todo_count);
    }
    failures
}

// === v0.8 compliance-fixture group ===
//
// The harness runs the ACTIVE version-scoped group (core/fixtures/v0.8/),
// discovered dynamically. The legacy pre-0.8 corpus (core/fixtures/legacy-pre-0.8/)
// is frozen and NOT run — see core/fixtures/README.md.
//
// The group currently holds only a smoke placeholder, so this is green-trivial.
// As real 0.8 cases land they will go RED against the still-pre-0.8 parser
// until the parser is rebuilt; that RED is the intended, honest state.

#[test]
fn v0_8_compliance_group() {
    let names = common::active_fixture_names();
    assert!(
        !names.is_empty(),
        "v0.8 compliance-fixture group is empty: {:?}",
        common::active_group_dir()
    );
    let mut failures = Vec::new();
    let mut total = 0usize;
    for name in &names {
        let cases = common::load_fixtures_by_name(name);
        total += cases.len();
        failures.extend(collect_fixture_failures(name));
    }
    if !failures.is_empty() {
        panic!(
            "\nv0.8 compliance: {} of {} canonical+variation checks failed across {} files:\n  {}",
            failures.len(),
            total,
            names.len(),
            failures.join("\n  ")
        );
    }
}

// Quick smoke test
#[test]
fn smoke_test() {
    use udon_core::Parser;

    let input = b"|div :class container\n  Hello world\n";
    let mut events = Vec::new();
    Parser::new(input).parse(|e| events.push(e.format_line()));

    assert!(!events.is_empty(), "Should produce events");
    assert!(
        events.iter().any(|e| e.contains("ElementStart")),
        "Should have ElementStart"
    );
    assert!(
        events.iter().any(|e| e.contains("ElementEnd")),
        "Should have ElementEnd"
    );
}

/// Fuzz: temporal-SHAPED inputs must fall back cleanly to plain values.
///
/// CORE 0.8 removed bare temporal recognition (a bare 2026-07-11 is a
/// string; temporal returns via the <...> envelope / temporal@1 dialect).
/// The generator still produces the full zoo of temporal shapes — dates,
/// times, datetimes, ISO + shorthand durations, signed relatives — and the
/// invariant is now: every one parses without error into SOME value event
/// (BareValue / Integer / Float), never a hole or a crash.
/// Run with UDON_FUZZ_COUNT=N to control iteration count (default 1000)
#[test]
fn fuzz_temporal_shapes_fall_back_to_values() {
    use udon_core::Parser;

    let count: usize = std::env::var("UDON_FUZZ_COUNT")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(1000);

    let mut gen = Gen::from_env_or_random();
    let mut errors = Vec::new();

    for i in 0..count {
        // Generate a random temporal value as an attribute
        let temporal = gen.temporal_value();
        let temporal_str = String::from_utf8_lossy(&temporal);

        // Wrap in element with attribute
        let input = format!("|el :val {}\n", temporal_str);

        // Parse and collect events
        let mut events = Vec::new();
        let mut has_error = false;
        Parser::new(input.as_bytes()).parse(|e| {
            if e.format_line().contains("Error") {
                has_error = true;
            }
            events.push(e.format_line());
        });

        // Should have ElementStart, Name, Attr, some value event, ElementEnd
        // No Error events for valid temporal values
        if has_error {
            errors.push(format!(
                "#{}: Input {:?} produced error. Events: {:?}",
                i, temporal_str, events
            ));
        }

        // Should have at least 4 events (ElementStart, Name, Attr, value, ElementEnd)
        if events.len() < 4 {
            errors.push(format!(
                "#{}: Input {:?} produced too few events: {:?}",
                i, temporal_str, events
            ));
        }

        // Every shape must land as SOME plain value (string or numeric) —
        // no temporal events exist anymore, and nothing may vanish.
        let has_value = events.iter().any(|e| {
            e.contains("BareValue") || e.contains("Integer") || e.contains("Float")
                || e.contains("StringValue")
        });
        if !has_value {
            errors.push(format!(
                "#{}: Input {:?} produced no value event: {:?}",
                i, temporal_str, events
            ));
        }
    }

    if !errors.is_empty() {
        panic!(
            "\n{} fuzz failures (seed={}):\n{}\n",
            errors.len(),
            gen.seed,
            errors.join("\n")
        );
    }

    eprintln!("  fuzz_temporal_values: {} iterations passed (seed={})", count, gen.seed);
}
