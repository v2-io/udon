//! Span-integrity tests (defect #16, REVIEW-JULY-2026 §4).
//!
//! An event's span must cover exactly the source bytes that produced its
//! content. The guard-char dispatch pattern (consume `|`/`` ` ``/`'`/`@`/`:`
//! to peek, then restore it into the text via PREPEND) used to leave spans
//! short by the restored length, corrupting any span-based edit.

use udon_core::{Event, Parser};

/// Every Text event's span must select exactly its content bytes.
fn assert_text_spans_cover_content(input: &[u8]) {
    Parser::new(input).parse(|ev| {
        if let Event::Text { content, span } = &ev {
            assert_eq!(
                span.len(),
                content.len(),
                "span length != content length for Text {:?} in input {:?}",
                String::from_utf8_lossy(content),
                String::from_utf8_lossy(input),
            );
            assert_eq!(
                &input[span.clone()],
                content.as_ref(),
                "span does not select the content bytes for Text {:?} in input {:?}",
                String::from_utf8_lossy(content),
                String::from_utf8_lossy(input),
            );
        }
    });
}

#[test]
fn backtick_initial_prose_line() {
    assert_text_spans_cover_content(b"|el\n  `code` first\n");
}

#[test]
fn double_backtick_initial_prose_line() {
    assert_text_spans_cover_content(b"``x not freeform\n");
}

#[test]
fn apostrophe_initial_prose_line() {
    assert_text_spans_cover_content(b"|el\n  'hello world\n");
}

#[test]
fn pipe_fallback_prose_line() {
    assert_text_spans_cover_content(b"|el\n  | maybe\n");
}

#[test]
fn at_fallback_prose_line() {
    assert_text_spans_cover_content(b"|el\n  @here now\n");
}

#[test]
fn colon_fallback_prose_line() {
    assert_text_spans_cover_content(b"|el\n  :-) ok\n");
}

#[test]
fn escaped_prefix_prose_line() {
    // Block-level escape: the apostrophe is dropped (escape), the escaped
    // char is content — span covers the escaped char, not the apostrophe.
    assert_text_spans_cover_content(b"|el\n  '| literal pipe\n");
}

#[test]
fn plain_prose_line_unchanged() {
    assert_text_spans_cover_content(b"|el\n  plain line\n");
}
