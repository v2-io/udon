//! Streaming AST tests.
//!
//! `TreeStream` (events in → completed root-level subtrees out) is tested
//! against the one-shot parser's event stream, including delivery timing.
//! `StreamingTreeParser` rides the pushdown (explicit-stack) parser, so it
//! is additionally tested at arbitrary feed boundaries — byte-at-a-time
//! included, the exact case that broke the retired line-oriented streamer.

use udon_core::stream_tree::{StreamingTreeParser, TreeStream};
use udon_core::tree::Document;
use udon_core::Parser;

const DOC: &[u8] = b"|config[main].prod :retries 3\n  :host example.com\n  |nested\n    deep prose\n; a root comment\nroot prose line\n|last\n";

#[test]
fn subtrees_arrive_as_they_close() {
    // Drive TreeStream directly from one-shot events, checking WHEN each
    // subtree completes.
    let mut ts = TreeStream::new();
    let mut deliveries: Vec<(usize, usize)> = Vec::new(); // (event_index, completed_so_far)
    let mut i = 0usize;
    Parser::new(DOC).parse(|e| {
        // Borrowed events -> owned via format-preserving conversion:
        ts.push(own(e));
        i += 1;
        let n = ts.take_completed().len();
        if n > 0 {
            deliveries.push((i, n));
        }
    });
    let (rest, errors) = ts.finish();
    assert!(errors.is_empty(), "{errors:?}");
    assert!(rest.is_empty(), "everything should have shipped at close");

    // Four root-level subtrees: |config, the comment, the prose line, |last
    let total: usize = deliveries.iter().map(|(_, n)| n).sum();
    assert_eq!(total, 4, "deliveries: {deliveries:?}");
    // And they arrived at four distinct moments (as they closed, not at EOF)
    assert_eq!(deliveries.len(), 4, "deliveries: {deliveries:?}");
}

#[test]
fn streamed_subtrees_match_one_shot() {
    let mut stp = StreamingTreeParser::new();
    let split = DOC.windows(2).position(|w| w == b"\n;").unwrap() + 1;
    let mut docs = stp.feed(&DOC[..split]);
    docs.extend(stp.feed(&DOC[split..]));
    let (rest, errors) = stp.finish();
    docs.extend(rest);
    assert!(errors.is_empty(), "{errors:?}");
    assert_eq!(docs.len(), 4);

    // Structural equivalence with the one-shot tree, subtree by subtree
    // (compared by shape — arena NodeIds differ between documents).
    let one_shot = Document::parse(DOC).unwrap();
    let expected: Vec<String> = one_shot.root().children().map(|c| shape(&c)).collect();
    let streamed: Vec<String> =
        docs.iter().map(|d| shape(&d.root().first_child().unwrap())).collect();
    assert_eq!(streamed, expected);
}

#[test]
fn byte_at_a_time_feeding_is_exact() {
    // The resumable parser makes arbitrary boundaries safe — including one
    // byte per feed across nested structure (review defect #1's case).
    let mut stp = StreamingTreeParser::new();
    let mut docs = Vec::new();
    for b in DOC {
        docs.extend(stp.feed(&[*b]));
    }
    let (rest, errors) = stp.finish();
    docs.extend(rest);
    assert!(errors.is_empty(), "{errors:?}");

    let one_shot = Document::parse(DOC).unwrap();
    let expected: Vec<String> = one_shot.root().children().map(|c| shape(&c)).collect();
    let streamed: Vec<String> =
        docs.iter().map(|d| shape(&d.root().first_child().unwrap())).collect();
    assert_eq!(streamed, expected);
}

/// Structural fingerprint: node kind plus children shapes, no arena ids.
fn shape(n: &udon_core::Node<'_, '_>) -> String {
    let children: Vec<String> = n.children().map(|c| shape(&c)).collect();
    format!("{:?}[{}]", n.kind(), children.join(","))
}

#[test]
fn element_subtree_is_complete() {
    let mut stp = StreamingTreeParser::new();
    let mut docs = stp.feed(b"|config[main] :retries 3\n  :host h\n  |nested\n    deep\n|next\n");
    let (rest, errors) = stp.finish();
    docs.extend(rest);
    assert!(errors.is_empty());
    assert_eq!(docs.len(), 2);

    let config = docs[0].root().first_child().unwrap().as_element().unwrap();
    assert_eq!(config.name(), "config");
    assert_eq!(config.key().and_then(|v| v.as_str()), Some("main"));
    assert_eq!(config.attr("host").and_then(|v| v.as_str()), Some("h"));
    let nested = config.node().first_child().unwrap().as_element().unwrap();
    assert_eq!(nested.name(), "nested");
    assert_eq!(nested.node().all_text(), "deep");
}

#[test]
fn errors_are_reported_not_fatal() {
    let mut stp = StreamingTreeParser::new();
    // A tab in indentation is a recoverable error confined to its line
    // (a quoted string would swallow the rest of the input instead).
    let mut docs = stp.feed(b"|el\n\t|child\n|ok\n");
    let errors = stp.take_errors();
    let (rest, _) = stp.finish();
    docs.extend(rest);
    assert!(!errors.is_empty(), "tab indentation should surface an error");
    // Subtrees still delivered around the error.
    assert_eq!(docs.len(), 2);
}

/// Borrowed → owned event conversion for test driving.
fn own(e: udon_core::Event<'_>) -> udon_core::Event<'static> {
    use std::borrow::Cow;
    use udon_core::Event::*;
    macro_rules! b {
        ($v:ident, $span:expr) => { $v { span: $span } };
    }
    macro_rules! c {
        ($v:ident, $content:expr, $span:expr) => {
            $v { content: Cow::Owned($content.into_owned()), span: $span }
        };
    }
    match e {
        ElementStart { span } => b!(ElementStart, span),
        ElementEnd { span } => b!(ElementEnd, span),
        EmbeddedStart { span } => b!(EmbeddedStart, span),
        EmbeddedEnd { span } => b!(EmbeddedEnd, span),
        DirectiveStart { span } => b!(DirectiveStart, span),
        DirectiveEnd { span } => b!(DirectiveEnd, span),
        ArrayStart { span } => b!(ArrayStart, span),
        ArrayEnd { span } => b!(ArrayEnd, span),
        FreeformStart { span } => b!(FreeformStart, span),
        FreeformEnd { span } => b!(FreeformEnd, span),
        CommentStart { span } => b!(CommentStart, span),
        CommentEnd { span } => b!(CommentEnd, span),
        Name { content, span } => c!(Name, content, span),
        Text { content, span } => c!(Text, content, span),
        Attr { content, span } => c!(Attr, content, span),
        StringValue { content, span } => c!(StringValue, content, span),
        BareValue { content, span } => c!(BareValue, content, span),
        BoolTrue { content, span } => c!(BoolTrue, content, span),
        BoolFalse { content, span } => c!(BoolFalse, content, span),
        Nil { content, span } => c!(Nil, content, span),
        Interpolation { content, span } => c!(Interpolation, content, span),
        Reference { content, span } => c!(Reference, content, span),
        RawContent { content, span } => c!(RawContent, content, span),
        Raw { content, span } => c!(Raw, content, span),
        Integer { content, span } => c!(Integer, content, span),
        Float { content, span } => c!(Float, content, span),
        Rational { content, span } => c!(Rational, content, span),
        Complex { content, span } => c!(Complex, content, span),
        Warning { content, span } => c!(Warning, content, span),
        BlankLine { content, span } => c!(BlankLine, content, span),
        Error { code, span } => Error { code, span },
    }
}
