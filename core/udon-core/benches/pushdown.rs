//! Recursive vs pushdown backend throughput.
//!
//! The question this answers (TODO-CORE-PARSING): what does resumability
//! cost? The recursive backend borrows content (zero-copy Cow) and lives on
//! the native call stack; the pushdown backend pays for frame push/pop, the
//! accumulation buffer, and (v1) owned Vec<u8> event content. Run:
//!   cargo bench --bench pushdown

use criterion::{black_box, criterion_group, criterion_main, Criterion, Throughput};
use udon_core::{Parser, PushdownParser};

fn doc_1mb() -> Vec<u8> {
    let base = std::fs::read("../examples/comprehensive.udon")
        .expect("run from core/ (examples/comprehensive.udon)");
    let mut doc = Vec::with_capacity(1 << 20);
    while doc.len() < (1 << 20) {
        doc.extend_from_slice(&base);
    }
    doc
}

fn bench_backends(c: &mut Criterion) {
    let doc = doc_1mb();
    let mut group = c.benchmark_group("backends_1mb");
    group.throughput(Throughput::Bytes(doc.len() as u64));

    group.bench_function("recursive_single_shot", |b| {
        b.iter(|| {
            let mut n = 0usize;
            Parser::new(black_box(&doc)).parse(|e| {
                n += 1;
                black_box(&e);
            });
            black_box(n)
        })
    });

    for (label, chunk) in [
        ("pushdown_whole", usize::MAX),
        ("pushdown_64k", 64 * 1024),
        ("pushdown_4k", 4 * 1024),
        ("pushdown_256b", 256),
    ] {
        group.bench_function(label, |b| {
            b.iter(|| {
                let mut n = 0usize;
                let mut pd = PushdownParser::new();
                let mut cb = |e: udon_core::StreamEvent| {
                    n += 1;
                    black_box(&e);
                };
                if chunk == usize::MAX {
                    pd.push_chunk(black_box(&doc), &mut cb);
                } else {
                    for c in doc.chunks(chunk) {
                        pd.push_chunk(black_box(c), &mut cb);
                    }
                }
                pd.finish(&mut cb);
                black_box(n)
            })
        });
    }
    group.finish();
}

criterion_group!(benches, bench_backends);
criterion_main!(benches);
