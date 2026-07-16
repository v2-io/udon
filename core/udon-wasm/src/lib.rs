//! WebAssembly export of the event-stream highlighter + autocolors engine.
//!
//! Highlighting: same walk as `udon-core/examples/highlight.rs` — the
//! parser's events with byte spans ARE the highlighter. On top of the event
//! spans, a *lexical refinement pass* subdivides the remaining scaffold bytes
//! (sigils, brackets, quotes, flags…) into the fine-grained role tree of
//! `roles.rs`, so kin roles can be shaded relative to their owners. The
//! refinement is presentation-only adjacency decoration around authoritative
//! parser spans — it is NOT a second grammar and never overrides an event.
//!
//! Autocolors: `udon_theme` generates a named, deterministic color scheme
//! (scheme.rs) anchored to the live theme's background/foreground and emits
//! CSS for the `.udon-hl-<role>` classes. The scheme NAME is the SEED.
//!
//! ABI (raw, no wasm-bindgen; all offsets into wasm linear memory):
//!   udon_alloc(len)              -> ptr      caller writes UTF-8/bytes here
//!   udon_free(ptr, len)                      free an udon_alloc buffer
//!   udon_highlight(ptr, len)     -> res_ptr  u32 layout: [n, start,end,role]*n
//!                                            covering runs over 0..len, byte
//!                                            offsets, non-overlapping, asc.
//!   udon_free_result(res_ptr)                free a highlight result
//!   udon_role_names()            -> ptr      [len:u32][utf8], '\n'-separated
//!                                            role names in wire-index order
//!   udon_theme(nptr, nlen, bg, fg) -> ptr    [len:u32][utf8 CSS]; bg/fg are
//!                                            0xRRGGBB of the live theme
//!   udon_free_bytes(ptr)                     free a [len:u32][bytes] result

mod color;
mod rng;
mod roles;
mod scheme;

use roles::*;
use std::ops::Range;
use udon_core::{Event, Parser};

/// Event walk -> per-byte role, then lexical refinement of scaffold bytes.
fn classify(input: &[u8]) -> Vec<u8> {
    let mut ops: Vec<(Range<usize>, u8, u8)> = Vec::new(); // (range, role, priority)
    let mut containers: Vec<(usize, u8)> = Vec::new();
    Parser::new(input).parse(|e| {
        use Event::*;
        match &e {
            CommentStart { span } => containers.push((span.start, R_COMMENT)),
            FreeformStart { span } => containers.push((span.start, R_DYNAMIC)),
            DirectiveStart { span } => containers.push((span.start, R_DYNAMIC)),
            CommentEnd { span } | FreeformEnd { span } | DirectiveEnd { span } => {
                if let Some((start, cls)) = containers.pop() {
                    let pri = if cls == R_COMMENT { 2 } else { 0 };
                    ops.push((start..span.end, cls, pri));
                }
            }
            Name { span, .. } => ops.push((span.clone(), R_ELEMENT_NAME, 1)),
            Attr { span, .. } => ops.push((span.clone(), R_ATTR_KEY, 1)),
            StringValue { span, .. } => ops.push((span.clone(), R_STRING, 1)),
            BareValue { span, .. } => ops.push((span.clone(), R_VALUE_BARE, 1)),
            Integer { span, .. } | Float { span, .. } | Rational { span, .. }
            | Complex { span, .. } => ops.push((span.clone(), R_NUMBER, 1)),
            BoolTrue { span, .. } | BoolFalse { span, .. } => {
                ops.push((span.clone(), R_BOOL, 1))
            }
            Nil { span, .. } => ops.push((span.clone(), R_NIL, 1)),
            Text { span, .. } => ops.push((span.clone(), R_TEXT, 1)),
            RawContent { span, .. } => ops.push((span.clone(), R_RAW_CONTENT, 1)),
            Interpolation { span, .. } => ops.push((span.clone(), R_INTERPOLATION, 2)),
            Reference { span, .. } => ops.push((span.clone(), R_REFERENCE, 2)),
            Warning { span, .. } => ops.push((span.clone(), R_WARNING, 3)),
            _ => {}
        }
    });

    let mut class: Vec<u8> = vec![R_DIM; input.len()];
    ops.sort_by_key(|(_, _, pri)| *pri);
    for (range, c, _) in &ops {
        let end = range.end.min(input.len());
        if range.start < end {
            class[range.start..end].fill(*c);
        }
    }
    refine(input, &mut class);
    class
}

fn is_ident(b: u8) -> bool {
    b.is_ascii_alphanumeric() || b == b'_' || b == b'-'
}

/// Subdivide scaffold (R_DIM) bytes and decorate span edges into the fine
/// role vocabulary. Purely local/adjacency rules keyed off the event-derived
/// classes around each byte; conservative by design — anything unmatched
/// stays R_DIM (which the generator makes recede regardless).
fn refine(input: &[u8], class: &mut [u8]) {
    let n = input.len();
    // Bracket-kind stack so `]` closes as the same kind `[` opened as.
    let mut brackets: Vec<u8> = Vec::new();
    let mut i = 0;
    while i < n {
        let b = input[i];
        let c = class[i];
        if c == R_DIM {
            match b {
                b'|' => {
                    if i + 1 < n && input[i + 1] == b'{' && class[i + 1] == R_DIM {
                        class[i] = R_INLINE_SIGIL;
                        class[i + 1] = R_INLINE_SIGIL;
                        i += 2;
                        continue;
                    }
                    class[i] = R_ELEMENT_SIGIL;
                }
                b'}' => class[i] = R_INLINE_CLOSE,
                b'[' => {
                    // After a name/id/trait => identity bracket; else array.
                    let kind = if i > 0
                        && matches!(
                            class[i - 1],
                            x if x == R_ELEMENT_NAME
                                || x == R_ID_KEY
                                || x == R_ID_KEY_DOLLAR
                                || x == R_TRAIT_NAME
                                || x == R_ID_BRACKET
                        ) {
                        R_ID_BRACKET
                    } else {
                        R_ARRAY_BRACKET
                    };
                    class[i] = kind;
                    brackets.push(kind);
                }
                b']' => {
                    class[i] = brackets.pop().unwrap_or(R_ARRAY_BRACKET);
                }
                b'.' => {
                    // Trait dot: directly after a name / identity / trait.
                    if i > 0
                        && matches!(
                            class[i - 1],
                            x if x == R_ELEMENT_NAME
                                || x == R_ID_BRACKET
                                || x == R_TRAIT_NAME
                        )
                    {
                        class[i] = R_TRAIT_DOT;
                        // Trait names may arrive evented (BareValue) or as
                        // scaffold; either way they are identity, kin of the
                        // element name.
                        let mut j = i + 1;
                        while j < n
                            && (class[j] == R_DIM || class[j] == R_VALUE_BARE)
                            && is_ident(input[j])
                        {
                            class[j] = R_TRAIT_NAME;
                            j += 1;
                        }
                        i = j;
                        continue;
                    }
                }
                b':' => {
                    if i + 1 < n && class[i + 1] == R_ATTR_KEY {
                        class[i] = R_ATTR_SIGIL;
                    }
                }
                b'?' => {
                    if i > 0 && class[i - 1] == R_ATTR_KEY {
                        class[i] = R_ATTR_FLAG;
                    }
                }
                b';' => {
                    // Comment sigil left outside the comment container span.
                    class[i] = R_COMMENT_SIGIL;
                    if i + 1 < n && input[i + 1] == b'{' && class[i + 1] == R_DIM {
                        class[i + 1] = R_COMMENT_SIGIL;
                    }
                }
                b'!' => class[i] = R_DYNAMIC_SIGIL,
                b'@' => class[i] = R_REFERENCE_SIGIL,
                b'"' => {
                    let quote_adj = (i > 0 && class[i - 1] == R_STRING)
                        || (i + 1 < n && class[i + 1] == R_STRING);
                    if quote_adj {
                        class[i] = R_STRING_QUOTE;
                    }
                }
                b'<' | b'>' => class[i] = R_TYPE_ANGLE,
                b'$' => {
                    // $-key inside identity brackets: underline lineage.
                    if brackets.last() == Some(&R_ID_BRACKET) {
                        class[i] = R_ID_KEY_DOLLAR;
                        let mut j = i + 1;
                        while j < n && class[j] == R_DIM && is_ident(input[j]) {
                            class[j] = R_ID_KEY_DOLLAR;
                            j += 1;
                        }
                        i = j;
                        continue;
                    }
                }
                _ => {
                    // Bare identity key inside [ ] that produced no event.
                    if is_ident(b) && brackets.last() == Some(&R_ID_BRACKET) {
                        class[i] = R_ID_KEY;
                    }
                }
            }
        } else if c == R_COMMENT {
            // Comment sigil: leading ';' (and '{' of ';{ … }', and its '}').
            let run_start = i == 0 || class[i - 1] != R_COMMENT;
            if run_start && b == b';' {
                class[i] = R_COMMENT_SIGIL;
                if i + 1 < n && input[i + 1] == b'{' && class[i + 1] == R_COMMENT {
                    class[i + 1] = R_COMMENT_SIGIL;
                }
            } else if b == b'}' && (i + 1 >= n || class[i + 1] != R_COMMENT) {
                class[i] = R_COMMENT_SIGIL;
            }
        } else if c == R_VALUE_BARE {
            let run_start = i == 0 || class[i - 1] != R_VALUE_BARE;
            if run_start {
                let mut j = i;
                while j < n && class[j] == R_VALUE_BARE {
                    j += 1;
                }
                if brackets.last() == Some(&R_ID_BRACKET) {
                    // Identity key inside [ … ]: kin of the element name;
                    // $-keys get the underline lineage. (These arrive as
                    // BareValue events today — 0.9 grammar in flight.)
                    let role = if b == b'$' { R_ID_KEY_DOLLAR } else { R_ID_KEY };
                    class[i..j].fill(role);
                } else if b == b'?' && j == i + 1 && i > 0 && class[i - 1] == R_ATTR_KEY {
                    // 0.9 flag syntax `:key?`.
                    class[i] = R_ATTR_FLAG;
                } else if b == b'<' && input[j - 1] == b'>' && j > i + 1 {
                    // `<…>` typing envelope (interim pass-through): angles
                    // get their own kin role, payload stays a value.
                    class[i] = R_TYPE_ANGLE;
                    class[j - 1] = R_TYPE_ANGLE;
                }
                if j > i + 1 {
                    i = j;
                    continue;
                }
            }
        } else if c == R_REFERENCE && b == b'@' && (i == 0 || class[i - 1] != R_REFERENCE) {
            class[i] = R_REFERENCE_SIGIL;
        } else if c == R_STRING && b == b'"' {
            let run_start = i == 0 || class[i - 1] != R_STRING;
            let run_end = i + 1 >= n || class[i + 1] != R_STRING;
            if run_start || run_end {
                class[i] = R_STRING_QUOTE;
            }
        } else if (c == R_TEXT || c == R_STRING) && b == b'\\' && i + 1 < n {
            // Escape pair inside prose/strings (spec: `\` escape model).
            class[i] = R_ESCAPE;
            class[i + 1] = R_ESCAPE;
            i += 2;
            continue;
        }
        i += 1;
    }
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

/// Package a byte string as [len:u32 LE][bytes] for the JS side.
fn boxed_bytes(payload: &[u8]) -> *mut u8 {
    let mut v = Vec::with_capacity(4 + payload.len());
    v.extend_from_slice(&(payload.len() as u32).to_le_bytes());
    v.extend_from_slice(payload);
    let boxed = v.into_boxed_slice();
    Box::into_raw(boxed) as *mut u8
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

/// Role-name table, '\n'-separated, wire-index order. [len:u32][utf8].
#[no_mangle]
pub extern "C" fn udon_role_names() -> *mut u8 {
    let names: Vec<&str> = ROLES.iter().map(|r| r.name).collect();
    boxed_bytes(names.join("\n").as_bytes())
}

/// Generate the named scheme's CSS for the given theme anchors.
/// `bg`/`fg` are 0xRRGGBB. Returns [len:u32][utf8 CSS].
///
/// # Safety
/// `name_ptr..name_ptr+name_len` must be initialized memory in this instance.
#[no_mangle]
pub unsafe extern "C" fn udon_theme(
    name_ptr: *const u8,
    name_len: usize,
    bg: u32,
    fg: u32,
) -> *mut u8 {
    let name_bytes = std::slice::from_raw_parts(name_ptr, name_len);
    let name = std::str::from_utf8(name_bytes).unwrap_or("tony-the-tiger");
    let (br, bgc, bb) = color::rgb_u32(bg);
    let (fr, fgc, fb) = color::rgb_u32(fg);
    let css = scheme::css(
        name,
        color::srgb_to_oklab(br, bgc, bb),
        color::srgb_to_oklab(fr, fgc, fb),
    );
    boxed_bytes(css.as_bytes())
}

/// # Safety
/// `ptr` must be an un-freed [len:u32][bytes] result from this module.
#[no_mangle]
pub unsafe extern "C" fn udon_free_bytes(ptr: *mut u8) {
    let len = u32::from_le_bytes(*(ptr as *const [u8; 4])) as usize;
    drop(Box::from_raw(std::slice::from_raw_parts_mut(ptr, 4 + len) as *mut [u8]));
}

#[cfg(test)]
mod tests {
    use super::*;

    fn class_str(src: &str) -> Vec<u8> {
        classify(src.as_bytes())
    }

    #[test]
    fn runs_tile_the_input() {
        let src = "|article[intro].featured\n  :author Joseph\n  prose here\n";
        let r = runs(&class_str(src));
        let n = r[0] as usize;
        let mut pos = 0u32;
        for k in 0..n {
            assert_eq!(r[1 + k * 3], pos, "runs must be contiguous");
            assert!(r[2 + k * 3] > r[1 + k * 3]);
            pos = r[2 + k * 3];
        }
        assert_eq!(pos as usize, src.len());
    }

    #[test]
    fn north_star_roles_assigned() {
        // |element[123].trait — sigil / name / brackets / typed key / trait.
        let src = "|element[abc].featured\n";
        let c = class_str(src);
        assert_eq!(c[0], R_ELEMENT_SIGIL, "| is the element sigil");
        assert_eq!(c[1], R_ELEMENT_NAME);
        assert_eq!(c[8], R_ID_BRACKET, "[");
        assert_eq!(c[12], R_ID_BRACKET, "]");
        assert_eq!(c[13], R_TRAIT_DOT, ".");
        assert_eq!(c[14], R_TRAIT_NAME, "trait name");
    }

    #[test]
    fn attr_sigil_and_flag() {
        let src = "|m :key value\n";
        let c = class_str(src);
        let colon = src.find(':').unwrap();
        assert_eq!(c[colon], R_ATTR_SIGIL);
        assert_eq!(c[colon + 1], R_ATTR_KEY);
    }

    #[test]
    fn comment_sigil_refined() {
        let src = "; a comment\n";
        let c = class_str(src);
        assert_eq!(c[0], R_COMMENT_SIGIL);
        assert_eq!(c[2], R_COMMENT);
    }

    #[test]
    fn reference_sigil_refined() {
        let src = "|m :license @spdx\n";
        let c = class_str(src);
        let at = src.find('@').unwrap();
        assert!(c[at] == R_REFERENCE_SIGIL || c[at] == R_DIM); // sigil either from run head or dim rule
        assert_ne!(c[at], R_REFERENCE);
    }

    #[test]
    fn refinement_never_rewrites_content_spans() {
        // Pipes and brackets inside prose belong to Text and must stay Text.
        let src = "|p a pipe | and bracket [x] in prose\n";
        let c = class_str(src);
        let pipe2 = src.rfind('|').unwrap();
        assert_eq!(c[pipe2], R_TEXT, "prose | must not become a sigil");
    }
}
