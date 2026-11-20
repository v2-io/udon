//! Exploratory, NON-GATING sandbox player.
//!
//! This is NOT a compliance test. It loads `core/fixtures/exploratory/*.yaml`
//! — the multi-line-behavior sandbox for the "single-line for now, multi-line
//! deliberately undefined" delimited constructs (see that dir's README) — and
//! PRINTS what the parser does today. It never gates a release: the sole test
//! is `#[ignore]`d, so `cargo test` / CI / `compliance_gate` never touch it.
//!
//! Play it:
//!     cargo test -p udon-core --test exploratory -- --ignored --nocapture
//!
//! Because these inputs are undefined-by-ruling, the recorded `events:` are
//! CURRENT behavior, not ratified expectations. This runner therefore does
//! NOT fail on a mismatch — a DRIFT is reported as informative signal (the
//! parser or spec moved), exactly the opposite of the compliance gate. The
//! only way it "fails" is a genuine parser panic, which is itself a find.

mod common;

use common::{fixtures_root, load_fixtures, run_test};

#[test]
#[ignore = "exploratory sandbox — non-gating; run with --ignored --nocapture to play"]
fn exploratory_multi_line_sandbox() {
    let dir = fixtures_root().join("exploratory");
    let mut files: Vec<_> = std::fs::read_dir(&dir)
        .unwrap_or_else(|e| panic!("read exploratory dir {:?}: {e}", dir))
        .filter_map(|entry| {
            let path = entry.ok()?.path();
            (path.extension()?.to_str()? == "yaml").then_some(path)
        })
        .collect();
    files.sort();

    println!("\n=== EXPLORATORY multi-line sandbox (CURRENT parser behavior, NOT ratified) ===");
    let (mut probes, mut recorded, mut drifted) = (0usize, 0usize, 0usize);

    for path in &files {
        println!("\n----- {} -----", path.file_name().unwrap().to_string_lossy());
        for case in load_fixtures(path) {
            let result = run_test(&case);
            println!("\n[{}] {}", case.id, case.desc);
            println!("  input: {:?}", case.udon);
            if case.events.is_empty() {
                probes += 1;
                println!("  (probe only — no assertion; see fixture comment)");
                println!("  CURRENT events:");
                for e in &result.actual {
                    println!("    {e}");
                }
            } else {
                recorded += 1;
                if result.passed {
                    println!("  MATCHES recorded CURRENT behavior ({} events)", result.actual.len());
                } else {
                    drifted += 1;
                    println!("  ⚠ DRIFT from recorded CURRENT behavior (informative, not a failure):");
                    println!("    recorded:");
                    for e in &result.expected {
                        println!("      {e}");
                    }
                    println!("    now:");
                    for e in &result.actual {
                        println!("      {e}");
                    }
                }
            }
        }
    }

    println!(
        "\n=== summary: {recorded} recorded ({drifted} drifted), {probes} probe-only; \
         drift is informative, never a gate ===\n"
    );
}
