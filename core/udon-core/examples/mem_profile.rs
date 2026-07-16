//! Controlled memory measurement for the parser backends.
//!
//! Wraps the system allocator in a counting allocator and reports, for the
//! 1 MiB comprehensive doc: peak live bytes, net live bytes at end, and
//! total allocation count — per backend and chunk size. Deterministic
//! (same doc, same path), so runs are comparable across commits; record
//! deltas alongside throughput pairs when a change plausibly touches
//! allocation. Run from core/:
//!
//!   cargo run --release --example mem_profile
//!
//! Note: figures include the driver's own buffers (the doc Vec is
//! allocated before measurement starts and excluded by resetting stats).

use std::alloc::{GlobalAlloc, Layout, System};
use std::sync::atomic::{AtomicUsize, Ordering::Relaxed};

struct Counting;

static LIVE: AtomicUsize = AtomicUsize::new(0);
static PEAK: AtomicUsize = AtomicUsize::new(0);
static COUNT: AtomicUsize = AtomicUsize::new(0);

unsafe impl GlobalAlloc for Counting {
    unsafe fn alloc(&self, l: Layout) -> *mut u8 {
        let p = System.alloc(l);
        if !p.is_null() {
            COUNT.fetch_add(1, Relaxed);
            let live = LIVE.fetch_add(l.size(), Relaxed) + l.size();
            PEAK.fetch_max(live, Relaxed);
        }
        p
    }
    unsafe fn dealloc(&self, p: *mut u8, l: Layout) {
        LIVE.fetch_sub(l.size(), Relaxed);
        System.dealloc(p, l);
    }
    unsafe fn realloc(&self, p: *mut u8, l: Layout, new: usize) -> *mut u8 {
        let q = System.realloc(p, l, new);
        if !q.is_null() {
            COUNT.fetch_add(1, Relaxed);
            let live = LIVE.fetch_add(new, Relaxed) + new;
            LIVE.fetch_sub(l.size(), Relaxed);
            PEAK.fetch_max(live, Relaxed);
        }
        q
    }
}

#[global_allocator]
static A: Counting = Counting;

fn reset() -> usize {
    let base = LIVE.load(Relaxed);
    PEAK.store(base, Relaxed);
    COUNT.store(0, Relaxed);
    base
}

fn report(label: &str, base: usize, events: usize) {
    let peak = PEAK.load(Relaxed) - base;
    let count = COUNT.load(Relaxed);
    println!("{label:<28} peak +{peak:>9} B   allocs {count:>7}   events {events}");
}

fn main() {
    let base_doc = std::fs::read("../examples/comprehensive.udon").expect("run from core/");
    let mut doc = Vec::with_capacity(1 << 20);
    while doc.len() < (1 << 20) {
        doc.extend_from_slice(&base_doc);
    }
    println!("doc: {} bytes\n", doc.len());

    {
        let base = reset();
        let mut n = 0usize;
        udon_core::Parser::new(&doc).parse(|e| {
            n += 1;
            std::hint::black_box(&e);
        });
        report("recursive_single_shot", base, n);
    }

    for (label, chunk) in [
        ("pushdown_whole", usize::MAX),
        ("pushdown_64k", 64 * 1024),
        ("pushdown_4k", 4 * 1024),
        ("pushdown_256b", 256),
    ] {
        let base = reset();
        let mut n = 0usize;
        let mut pd = udon_core::PushdownParser::new();
        let mut cb = |e: udon_core::StreamEvent| {
            n += 1;
            std::hint::black_box(&e);
        };
        if chunk == usize::MAX {
            pd.push_chunk(&doc, &mut cb);
        } else {
            for c in doc.chunks(chunk) {
                pd.push_chunk(c, &mut cb);
            }
        }
        pd.finish(&mut cb);
        report(label, base, n);
    }
}
