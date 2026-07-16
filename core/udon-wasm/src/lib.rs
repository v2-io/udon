//! SPIKE (2026-07-16) — WebAssembly export of the event-stream highlighter.
//!
//! Same walk as `udon-core/examples/highlight.rs`: the parser's events with
//! byte spans ARE the highlighter — no separate grammar. This crate exposes
//! it over a raw wasm ABI (no wasm-bindgen, no npm build step) so the
//! Obsidian plugin can call it with plain `WebAssembly.instantiate`.
//!
//! ABI (all offsets into wasm linear memory):
//!   udon_alloc(len)            -> ptr        caller writes UTF-8/bytes here
//!   udon_highlight(ptr, len)   -> res_ptr    u32 layout: [n, start,end,class]*n
//!                                            covering runs over 0..len,
//!                                            byte offsets, non-overlapping,
//!                                            ascending. Frees nothing.
//!   udon_free(ptr, len)                      free an udon_alloc buffer
//!   udon_free_result(res_ptr)                free a highlight result
//!
//! Token classes (keep in sync with editors/obsidian-udon CSS):
//!   0 scaffold/dim  1 name  2 attr  3 string  4 number  5 keyword
//!   6 text/prose    7 comment  8 dynamic  9 reference  10 warning

use std::ops::Range;
use udon_core::{Event, Parser};

const CLS_DIM: u8 = 0;
const CLS_NAME: u8 = 1;
const CLS_ATTR: u8 = 2;
const CLS_STR: u8 = 3;
const CLS_NUM: u8 = 4;
const CLS_KW: u8 = 5;
const CLS_TEXT: u8 = 6;
const CLS_CMT: u8 = 7;
const CLS_DYN: u8 = 8;
const CLS_REF: u8 = 9;
const CLS_WARN: u8 = 10;

/// Core walk — identical structure to examples/highlight.rs.
fn classify(input: &[u8]) -> Vec<u8> {
    let mut ops: Vec<(Range<usize>, u8, u8)> = Vec::new(); // (range, class, priority)
    let mut containers: Vec<(usize, u8)> = Vec::new();
    Parser::new(input).parse(|e| {
        use Event::*;
        match &e {
            CommentStart { span } => containers.push((span.start, CLS_CMT)),
            FreeformStart { span } => containers.push((span.start, CLS_DYN)),
            DirectiveStart { span } => containers.push((span.start, CLS_DYN)),
            CommentEnd { span } | FreeformEnd { span } | DirectiveEnd { span } => {
                if let Some((start, cls)) = containers.pop() {
                    let pri = if cls == CLS_CMT { 2 } else { 0 };
                    ops.push((start..span.end, cls, pri));
                }
            }
            Name { span, .. } => ops.push((span.clone(), CLS_NAME, 1)),
            Attr { span, .. } => ops.push((span.clone(), CLS_ATTR, 1)),
            StringValue { span, .. } | BareValue { span, .. } => {
                ops.push((span.clone(), CLS_STR, 1))
            }
            Integer { span, .. } | Float { span, .. } | Rational { span, .. }
            | Complex { span, .. } => ops.push((span.clone(), CLS_NUM, 1)),
            BoolTrue { span, .. } | BoolFalse { span, .. } | Nil { span, .. } => {
                ops.push((span.clone(), CLS_KW, 1))
            }
            Text { span, .. } | RawContent { span, .. } => {
                ops.push((span.clone(), CLS_TEXT, 1))
            }
            Interpolation { span, .. } => ops.push((span.clone(), CLS_DYN, 2)),
            Reference { span, .. } => ops.push((span.clone(), CLS_REF, 2)),
            Warning { span, .. } => ops.push((span.clone(), CLS_WARN, 3)),
            _ => {}
        }
    });

    let mut class: Vec<u8> = vec![CLS_DIM; input.len()];
    ops.sort_by_key(|(_, _, pri)| *pri);
    for (range, c, _) in &ops {
        let end = range.end.min(input.len());
        if range.start < end {
            class[range.start..end].fill(*c);
        }
    }
    class
}

/// Run-length encode into [n, (start,end,class)*n] as u32s.
fn runs(class: &[u8]) -> Vec<u32> {
    let mut out: Vec<u32> = vec![0];
    let mut i = 0;
    while i < class.len() {
        let c = class[i];
        let mut j = i + 1;
        while j < class.len() && class[j] == c {
            j += 1;
        }
        out.push(i as u32);
        out.push(j as u32);
        out.push(c as u32);
        i = j;
    }
    out[0] = ((out.len() - 1) / 3) as u32;
    out
}

#[no_mangle]
pub extern "C" fn udon_alloc(len: usize) -> *mut u8 {
    let mut v = Vec::<u8>::with_capacity(len.max(1));
    let ptr = v.as_mut_ptr();
    std::mem::forget(v);
    ptr
}

/// # Safety
/// `ptr` must be a live `udon_alloc(len)` buffer.
#[no_mangle]
pub unsafe extern "C" fn udon_free(ptr: *mut u8, len: usize) {
    drop(Vec::from_raw_parts(ptr, 0, len.max(1)));
}

/// # Safety
/// `ptr..ptr+len` must be initialized memory in this instance.
#[no_mangle]
pub unsafe extern "C" fn udon_highlight(ptr: *const u8, len: usize) -> *mut u32 {
    let input = std::slice::from_raw_parts(ptr, len);
    let result = runs(&classify(input));
    let boxed = result.into_boxed_slice();
    Box::into_raw(boxed) as *mut u32
}

/// # Safety
/// `res` must be an un-freed result of `udon_highlight`.
#[no_mangle]
pub unsafe extern "C" fn udon_free_result(res: *mut u32) {
    let n = *res as usize;
    let total = 1 + n * 3;
    drop(Box::from_raw(std::slice::from_raw_parts_mut(res, total) as *mut [u32]));
}
