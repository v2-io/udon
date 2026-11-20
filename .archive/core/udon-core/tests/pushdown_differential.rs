//! Differential proof for the pushdown (explicit-stack) backend: for every
//! active compliance fixture, the pushdown parser fed at every chunk size
//! must emit the exact event stream — content, order, AND spans — of the
//! single-shot recursive parser on the whole input. This is the spike's
//! 273-configuration methodology industrialized over the real grammar and
//! the real corpus (fixtures × chunk sizes), and it covers the precise
//! chunk-boundary case that broke the retired line-oriented StreamingParser
//! (review defect #1).

mod common;

use common::load_fixtures_by_name;
use udon_core::{Event, Parser, PushdownParser, StreamEvent};

fn fmt_event(e: &Event) -> String {
    let d = format!("{e:?}");
    normalize(&d)
}

fn fmt_stream(e: &StreamEvent) -> String {
    let d = format!("{e:?}");
    normalize(&d)
}

/// Normalize Debug output so Cow-vs-Vec content prints identically.
fn normalize(d: &str) -> String {
    d.replace("content: [", "content: b[").replace("Cow(", "(")
}

fn single_shot(input: &[u8]) -> Vec<String> {
    let mut out = Vec::new();
    Parser::new(input).parse(|e| out.push(fmt_event(&e)));
    out
}

fn pushdown(input: &[u8], chunk: usize) -> Vec<String> {
    let mut out = Vec::new();
    let mut pd = PushdownParser::new();
    let mut cb = |e: StreamEvent| out.push(fmt_stream(&e));
    if input.is_empty() {
        pd.push_chunk(&[], &mut cb);
    } else {
        for c in input.chunks(chunk) {
            pd.push_chunk(c, &mut cb);
        }
    }
    pd.finish(&mut cb);
    out
}

#[test]
fn pushdown_matches_single_shot_across_all_fixtures_and_chunk_sizes() {
    let names = common::active_fixture_names();
    let mut cases = 0usize;
    let mut configs = 0usize;
    let mut failures: Vec<String> = Vec::new();

    for name in &names {
        for case in load_fixtures_by_name(name) {
            cases += 1;
            let input = case.udon.as_bytes();
            let expected = single_shot(input);
            // every chunk size up to the input length (capped for large
            // inputs), plus whole-input
            let max = input.len().min(24).max(1);
            let mut sizes: Vec<usize> = (1..=max).collect();
            if input.len() > 24 {
                sizes.extend([37, input.len()]);
            }
            for &sz in &sizes {
                configs += 1;
                let got = pushdown(input, sz);
                if got != expected {
                    let diff = expected
                        .iter()
                        .zip(got.iter())
                        .position(|(a, b)| a != b)
                        .unwrap_or(expected.len().min(got.len()));
                    failures.push(format!(
                        "{name}::{id} chunk={sz}: first divergence at event {diff}\n  expected: {e:?}\n  got:      {g:?}",
                        id = case.id,
                        e = expected.get(diff),
                        g = got.get(diff),
                    ));
                    break; // one config per case is enough to report
                }
            }
        }
    }

    eprintln!("pushdown differential: {cases} cases x chunk sizes = {configs} configurations");
    assert!(
        failures.is_empty(),
        "\n{} cases diverged:\n{}",
        failures.len(),
        failures.join("\n")
    );
}
