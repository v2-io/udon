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
// The harness runs the ACTIVE version-scoped group (see loader::ACTIVE_GROUP),
// discovered dynamically. Frozen groups (core/fixtures/v0.8/, tag core-v0.8.0;
// core/fixtures/legacy-pre-0.8/) are NOT run — see core/fixtures/README.md.
//
// A RED gate is the intended, honest state whenever the spec is ahead of the
// parser: as the active group's cases are updated to the new spec version they
// go RED until the grammar catches up. (udon-core last fully passed 0.8.0.)

#[test]
fn compliance_gate() {
    let names = common::active_fixture_names();
    assert!(
        !names.is_empty(),
        "compliance-fixture group is empty: {:?}",
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
            "\n{} compliance: {} of {} canonical+variation checks failed across {} files:\n  {}",
            common::ACTIVE_GROUP,
            failures.len(),
            total,
            names.len(),
            failures.join("\n  ")
        );
    }
}

// Drift-check (TODO-META): the three version declarations move together —
// spec/CORE-VERSION (operable source of truth), udon_core::CORE_COMPLIANCE
// (what the parser targets), and loader::ACTIVE_GROUP (which fixture group
// measures it). CI-level enforcement of the CORE.md header / CHANGELOG top
// entry remains open in TODO-META.
#[test]
fn version_declarations_agree() {
    let core_version_path = common::fixtures_root()
        .parent()
        .and_then(|core| core.parent())
        .map(|repo| repo.join("spec/CORE-VERSION"))
        .expect("repo root above core/fixtures");
    let core_version = std::fs::read_to_string(&core_version_path)
        .unwrap_or_else(|e| panic!("read {:?}: {e}", core_version_path));
    let core_version = core_version.trim();
    assert_eq!(
        core_version,
        udon_core::CORE_COMPLIANCE,
        "spec/CORE-VERSION vs udon_core::CORE_COMPLIANCE"
    );
    // "0.9.0-alpha.1" → group "v0.9"
    let mut parts = core_version.split('.');
    let expected_group = format!(
        "v{}.{}",
        parts.next().unwrap_or_default(),
        parts.next().unwrap_or_default()
    );
    assert_eq!(
        expected_group,
        common::ACTIVE_GROUP,
        "CORE-VERSION major.minor vs loader::ACTIVE_GROUP"
    );
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
