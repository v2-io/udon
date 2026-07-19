//! Test harness for running tests with stochastic variations

use crate::common::{TestCase, ExpectedEvent, Gen};
use udon_core::{Parser, Event};

/// Result of running a test
#[derive(Debug)]
pub struct TestResult {
    pub passed: bool,
    pub input: Vec<u8>,
    pub expected: Vec<String>,
    pub actual: Vec<String>,
    pub seed: u64,
    pub errors: Vec<String>,
}

/// Collect events from parsing
fn collect_events(input: &[u8]) -> Vec<Event<'_>> {
    let mut events = Vec::new();
    Parser::new(input).parse(|e| events.push(e));
    events
}

/// Collapse same-line adjacent Text events (harness convention, ratified
/// 2026-07-15): the parser makes NO guarantee that a Text event carries a
/// complete text run — escapes (and, later, chunk boundaries) may split one
/// line's prose into several Texts. Fixtures therefore express text
/// maximally collapsed per line, and the harness folds consecutive Text
/// events together whenever the source between their spans contains no
/// newline. Across lines the boundary is real (each Text is one line's
/// content, newline excluded), so those never merge.
/// Whether a case asserts an empty `Text ""` in its expected events.
///
/// This is the fixture's own way of saying "I mean this literally" — the
/// assertion IS the declaration (`assert-text == ""`, vs the default
/// `assert-collapsed-text`). A case that spells out an empty Text is pinning
/// that the parser really emits it (e.g. an intentional empty forced-text
/// value `:a \`, or a trailing `\` line that must survive) — a `Text` a real
/// API consumer genuinely receives, that `collapse_adjacent_text` would
/// otherwise drop for rhythm-independence. Such a case is compared EXACTLY
/// (no fold) and skips variations. Note this only lets you assert the
/// well-defined *empty* Text; unspecified mid-line Text *splits* still can't
/// be pinned, which is correct — their granularity is deliberately unspecified.
pub fn asserts_empty_text(case: &TestCase) -> bool {
    case.events.iter().any(|e| {
        matches!(e, ExpectedEvent::WithContent(name, content) if name == "Text" && content.is_empty())
    })
}

/// Rhythm-independence fold, derived ENTIRELY from event content — no spans,
/// no source (the old span-gap/source consultation was the compensator that
/// masked the newline-dropping wire; see spec/TODO-TEXT-WIRE.md +
/// _archive/HARNESS-AUDIT-2026-07.md). Since line terminators are text, adjacent Text
/// events merge exactly when the first does NOT end in '\n' — a same-line
/// split (escape, packet boundary) merges; a line boundary stands. Empty
/// Texts fold away (authorized concatenation; exact cases opt out via
/// `asserts_empty_text`).
fn collapse_adjacent_text(events: Vec<Event<'_>>) -> Vec<Event<'_>> {
    let mut out: Vec<Event<'_>> = Vec::with_capacity(events.len());
    for e in events {
        if matches!(&e, Event::Text { content, .. } if content.is_empty()) {
            continue;
        }
        if let (Some(Event::Text { content: prev_c, span: prev_s }), Event::Text { content, span }) =
            (out.last_mut(), &e)
        {
            if !prev_c.ends_with(b"\n") {
                let mut merged = prev_c.to_vec();
                merged.extend_from_slice(content);
                *prev_c = std::borrow::Cow::Owned(merged);
                prev_s.end = span.end;
                continue;
            }
        }
        out.push(e);
    }
    out
}

/// The SAME fold applied to the expected side (symmetry: authors may write
/// text at any granularity; both sides normalize identically before compare).
fn collapse_expected(events: &[ExpectedEvent]) -> Vec<String> {
    let mut out: Vec<ExpectedEvent> = Vec::with_capacity(events.len());
    for e in events {
        if matches!(e, ExpectedEvent::WithContent(n, c) if n == "Text" && c.is_empty()) {
            continue;
        }
        if let (
            Some(ExpectedEvent::WithContent(pn, pc)),
            ExpectedEvent::WithContent(n, c),
        ) = (out.last_mut(), e)
        {
            if pn == "Text" && n == "Text" && !pc.ends_with('\n') {
                pc.push_str(c);
                continue;
            }
        }
        out.push(e.clone());
    }
    out.iter().map(format_expected).collect()
}

/// Format event for comparison (simplified, no spans)
fn format_event(event: &Event) -> String {
    match event {
        Event::ElementStart { .. } => "ElementStart".to_string(),
        Event::ElementEnd { .. } => "ElementEnd".to_string(),
        Event::EmbeddedStart { .. } => "EmbeddedStart".to_string(),
        Event::EmbeddedEnd { .. } => "EmbeddedEnd".to_string(),
        Event::DirectiveStart { .. } => "DirectiveStart".to_string(),
        Event::DirectiveEnd { .. } => "DirectiveEnd".to_string(),
        Event::ArrayStart { .. } => "ArrayStart".to_string(),
        Event::ArrayEnd { .. } => "ArrayEnd".to_string(),
        Event::FreeformStart { .. } => "FreeformStart".to_string(),
        Event::FreeformEnd { .. } => "FreeformEnd".to_string(),
        Event::CommentStart { .. } => "CommentStart".to_string(),
        Event::CommentEnd { .. } => "CommentEnd".to_string(),
        Event::Name { content, .. } => format!("Name {:?}", String::from_utf8_lossy(content)),
        Event::Text { content, .. } => format!("Text {:?}", String::from_utf8_lossy(content)),
        Event::Attr { content, .. } => format!("Attr {:?}", String::from_utf8_lossy(content)),
        Event::StringValue { content, .. } => format!("StringValue {:?}", String::from_utf8_lossy(content)),
        Event::BareValue { content, .. } => format!("BareValue {:?}", String::from_utf8_lossy(content)),
        Event::BoolTrue { .. } => "BoolTrue".to_string(),
        Event::BoolFalse { .. } => "BoolFalse".to_string(),
        Event::Nil { .. } => "Nil".to_string(),
        Event::Interpolation { content, .. } => format!("Interpolation {:?}", String::from_utf8_lossy(content)),
        Event::Reference { content, .. } => format!("Reference {:?}", String::from_utf8_lossy(content)),
        Event::RawContent { content, .. } => format!("RawContent {:?}", String::from_utf8_lossy(content)),
        Event::Raw { content, .. } => format!("Raw {:?}", String::from_utf8_lossy(content)),
        Event::Integer { content, .. } => format!("Integer {:?}", String::from_utf8_lossy(content)),
        Event::Float { content, .. } => format!("Float {:?}", String::from_utf8_lossy(content)),
        Event::Rational { content, .. } => format!("Rational {:?}", String::from_utf8_lossy(content)),
        Event::Complex { content, .. } => format!("Complex {:?}", String::from_utf8_lossy(content)),
        Event::Warning { content, .. } => format!("Warning {:?}", String::from_utf8_lossy(content)),
        Event::BlankLine { .. } => "BlankLine".to_string(),
        // Format error code as string to match YAML fixture format
        Event::Error { code, .. } => format!("Error \"{:?}\"", code),
    }
}

/// Format expected event for comparison
fn format_expected(event: &ExpectedEvent) -> String {
    match event {
        ExpectedEvent::Bare(name) => name.clone(),
        ExpectedEvent::WithContent(name, content) => format!("{} {:?}", name, content),
    }
}

/// Run a single test case (canonical, no variations)
///
/// If expected events is empty, this is a TODO test - we skip comparison
/// but still run the parser to check for panics/errors.
pub fn run_test(case: &TestCase) -> TestResult {
    let input = case.udon.as_bytes();
    // A case that asserts an empty Text wants EXACT comparison (see
    // `asserts_empty_text`): the raw events, unfolded, so the empty Text it
    // pins is actually present to match against.
    let raw = collect_events(input);
    let exact = asserts_empty_text(case);
    let events = if exact { raw } else { collapse_adjacent_text(raw) };

    let actual: Vec<String> = events.iter().map(format_event).collect();
    let expected: Vec<String> = if exact {
        case.events.iter().map(format_expected).collect()
    } else {
        collapse_expected(&case.events)
    };

    let mut errors = Vec::new();

    // Empty expected = TODO test, skip comparison but check for errors
    if expected.is_empty() {
        // Still check for unexpected Error events
        for act in &actual {
            if act.starts_with("Error") {
                errors.push(format!("Unexpected error in TODO test: {}", act));
            }
        }
        return TestResult {
            passed: errors.is_empty(),
            input: input.to_vec(),
            expected,
            actual,
            seed: 0,
            errors,
        };
    }

    // Check event count
    if actual.len() != expected.len() {
        errors.push(format!(
            "Event count mismatch: expected {}, got {}",
            expected.len(),
            actual.len()
        ));
    }

    // Check each event
    for (i, (act, exp)) in actual.iter().zip(expected.iter()).enumerate() {
        if act != exp {
            errors.push(format!("Event {}: expected '{}', got '{}'", i, exp, act));
        }
    }

    TestResult {
        passed: errors.is_empty(),
        input: input.to_vec(),
        expected,
        actual,
        seed: 0,
        errors,
    }
}

/// Run test with stochastic variations
///
/// Applies independent variations:
/// - 40% chance of UDON above
/// - Geometric indent (α=0.9)
/// - Random blank lines
/// - 40% chance of UDON below
///
/// If expected events is empty, this is a TODO test - skip variations.
/// If expected events include Error, skip variations (error tests rely on EOF behavior).
pub fn run_with_variations(case: &TestCase, gen: &mut Gen) -> TestResult {
    // Skip variations for TODO tests (empty expected)
    if case.events.is_empty() {
        return run_test(case);
    }

    // Skip variations for error-related tests - they rely on specific EOF behavior
    // and adding content after would change the semantics (e.g., unclosed
    // interpolation tests need EOF to trigger the error, not appended content)
    let expects_error = case.events.iter().any(|e| {
        matches!(e, ExpectedEvent::Bare(s) | ExpectedEvent::WithContent(s, _) if s.starts_with("Error"))
    });
    // Also skip if the test ID suggests error/edge case testing
    let is_error_test = case.id.contains("unclosed") || case.id.contains("error");
    // Semantic form of the same intent: any case that expects an `Unclosed*`
    // warning is a truncated/unclosed-construct test whose parse changes if the
    // harness appends a trailing newline or blank lines (a line-bound `[…]` /
    // `<…>` / string closes on the inserted newline instead of at EOF). The
    // id-substring check above is a fragile proxy for this; the expected-events
    // signal catches every EOF case regardless of how it happens to be named.
    let expects_unclosed = case.events.iter().any(|e| {
        matches!(e, ExpectedEvent::WithContent(s, c) if s == "Warning" && c.starts_with("Unclosed"))
    });
    // Skip variations for freeform tests - freeform blocks only work at document root
    let is_freeform_test = case.events.iter().any(|e| {
        matches!(e, ExpectedEvent::Bare(s) if s == "FreeformStart")
    });
    // A case whose expected DELIMITED-CAPTURE content spans a newline
    // (string/interpolation/envelope-pass-through interiors) is
    // interior-mutation-sensitive: the blank-line/indent variations land
    // INSIDE the construct and become part of the captured content, changing
    // the expectation. Scoped to the delimited-capture event KINDS — not
    // "any content containing \n" — so that when prose Text events gain
    // their line terminators (the TODO-TEXT-WIRE recast), ordinary
    // multi-line prose fixtures do NOT silently lose variation coverage
    // (HARNESS-AUDIT.md finding #1).
    let expects_multiline_content = case.events.iter().any(|e| {
        matches!(e, ExpectedEvent::WithContent(s, c)
            if c.contains('\n')
            && matches!(s.as_str(), "StringValue" | "Interpolation" | "BareValue"))
    });
    // A case asserting an empty Text is an exact-comparison case (see
    // `asserts_empty_text`); varying its input could add or remove the very
    // Text it pins, so it runs canonically like the EOF/unclosed cases.
    if expects_error || is_error_test || is_freeform_test || expects_unclosed
        || expects_multiline_content || asserts_empty_text(case) {
        return run_test(case);
    }

    let mut input = Vec::new();

    // For root_only tests, skip element-wrapping mutations but allow blank lines
    // These tests require document root semantics (e.g., `; ` as line comment)
    if case.root_only {
        // Add canonical test with possible blank lines (no indent, no wrapping elements)
        for line in case.udon.as_bytes().split(|&b| b == b'\n') {
            input.extend(gen.blank_lines());
            if !line.is_empty() {
                input.extend(line);
            }
            input.push(b'\n');
        }
    } else {
        // Normal variation: add context elements and indent

        // 40% chance: add UDON above
        if gen.chance(0.4) {
            input.extend(gen.udon_fragment(0));
        }

        // Determine indent level (geometric, α=0.9)
        let indent_level = gen.indent_level();
        let indent: Vec<u8> = vec![b' '; indent_level];

        // Add canonical test with indent and possible blank lines
        for line in case.udon.as_bytes().split(|&b| b == b'\n') {
            // Maybe inject blank line before
            input.extend(gen.blank_lines());

            if !line.is_empty() {
                input.extend(&indent);
                input.extend(line);
            }
            input.push(b'\n');
        }

        // 40% chance: add UDON below
        if gen.chance(0.4) {
            input.extend(gen.udon_fragment(indent_level));
        }
    }

    // Parse and collect events
    let events = collapse_adjacent_text(collect_events(&input));
    let actual: Vec<String> = events.iter().map(format_event).collect();
    let expected: Vec<String> = collapse_expected(&case.events);

    // For variations, we check that expected events appear in order (subsequence match)
    // because we may have extra events from the wrapping context.
    // D3 tolerance (ruled 2026-07-19): the variation machinery re-terminates
    // every line, so a case whose source ends WITHOUT a newline gains one —
    // its final text event legitimately carries a "\n" the expectation
    // (written for the EOF form) lacks. Suppress the captured newline that is
    // really an EOF stand-in: a Text/RawContent actual also matches
    // expected-with-"\n"-appended-before-the-closing-quote.
    let d3_match = |act: &str, exp: &str| -> bool {
        if act == exp {
            return true;
        }
        if (exp.starts_with("Text \"") || exp.starts_with("RawContent \""))
            && exp.ends_with('"')
        {
            let mut with_nl = exp[..exp.len() - 1].to_string();
            with_nl.push_str("\\n\"");
            return act == with_nl;
        }
        false
    };
    let mut errors = Vec::new();
    let mut exp_idx = 0;

    for act in &actual {
        if exp_idx < expected.len() && d3_match(act, &expected[exp_idx]) {
            exp_idx += 1;
        }
    }

    if exp_idx < expected.len() {
        errors.push(format!(
            "Missing expected events starting at index {}: {:?}",
            exp_idx,
            &expected[exp_idx..]
        ));
    }

    // Check for Error events (unless expected)
    for act in &actual {
        if act.starts_with("Error") && !expected.iter().any(|e| e.starts_with("Error")) {
            errors.push(format!("Unexpected error: {}", act));
        }
    }

    TestResult {
        passed: errors.is_empty(),
        input,
        expected,
        actual,
        seed: gen.seed,
        errors,
    }
}

impl TestResult {
    /// Print detailed failure info
    pub fn print_failure(&self, case_id: &str) {
        eprintln!("\n=== FAILED: {} ===", case_id);
        eprintln!("Seed: {} (set UDON_TEST_SEED={} to reproduce)", self.seed, self.seed);
        eprintln!("\nInput:");
        eprintln!("{}", String::from_utf8_lossy(&self.input));
        eprintln!("\nExpected events:");
        for (i, e) in self.expected.iter().enumerate() {
            eprintln!("  {}: {}", i, e);
        }
        eprintln!("\nActual events:");
        for (i, e) in self.actual.iter().enumerate() {
            eprintln!("  {}: {}", i, e);
        }
        eprintln!("\nErrors:");
        for e in &self.errors {
            eprintln!("  - {}", e);
        }
    }
}
