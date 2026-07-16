//! Throwaway profiling driver for the pushdown backend (used with
//! `sample`/xctrace during perf work; not a benchmark — see
//! benches/pushdown.rs for the measured suite).
use udon_core::PushdownParser;

fn main() {
    let base = std::fs::read("../examples/comprehensive.udon").expect("run from core/");
    let mut doc = Vec::with_capacity(1 << 20);
    while doc.len() < (1 << 20) {
        doc.extend_from_slice(&base);
    }
    let iters: usize = std::env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(3000);
    let mut total = 0usize;
    for _ in 0..iters {
        let mut n = 0usize;
        let mut pd = PushdownParser::new();
        let mut cb = |e: udon_core::StreamEvent| {
            n += 1;
            std::hint::black_box(&e);
        };
        pd.push_chunk(std::hint::black_box(&doc), &mut cb);
        pd.finish(&mut cb);
        total += n;
    }
    println!("{total}");
}
