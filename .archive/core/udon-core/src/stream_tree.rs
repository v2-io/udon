//! Streaming AST — the incremental tree as events arrive.
//!
//! CORE "Design Principles > Streaming Parse" asks for exactly this shape:
//! *parse as data arrives, emit complete subtrees as they close*. The design
//! splits the problem along the line the substrate draws today:
//!
//! - [`TreeStream`] is the real deliverable: a push-based incremental tree
//!   builder. Feed it events (from ANY correct event source), and it ships
//!   each completed root-level subtree as an owned [`Document`] the moment
//!   the subtree closes. It is source-agnostic on purpose — when the
//!   resumable (explicit-stack) parser lands in descent, it plugs in here
//!   unchanged.
//! - [`StreamingTreeParser`] is the byte-feeding convenience over the
//!   pushdown (explicit-stack) parser — resumable at ANY byte boundary
//!   (review defect #1 resolved at the generator level; see
//!   `tests/pushdown_differential.rs` for the fixtures-times-chunk-sizes
//!   proof). Feed bytes however they arrive; subtrees ship as they close.
//!
//! Subtree granularity: one completed root-level node per shipment — an
//! element with its whole subtree, a directive, a comment, a prose line.
//! That is the finest granularity at which "complete" is meaningful; batch
//! upward as needed. Shipped documents own their bytes (`Document<'static>`)
//! so they outlive the input chunks.

use std::borrow::Cow;

use crate::parser::{Event, StreamEvent};
use crate::parser_pd::PushdownParser;
use crate::tree::{describe_code, Document, ParseError, TreeBuilder};

/// Convert a [`StreamEvent`] (possibly borrowing the parser's buffer) into
/// an owned-lifetime [`Event`] so the tree machinery (written against
/// `Event<'a>`) can consume it. Content becomes `Cow::Owned` — the price of
/// outliving the chunk.
fn to_owned_event(ev: StreamEvent<'_>) -> Event<'static> {
    macro_rules! bare {
        ($v:ident, $span:expr) => {
            Event::$v { span: $span }
        };
    }
    macro_rules! content {
        ($v:ident, $c:expr, $span:expr) => {
            Event::$v { content: Cow::Owned($c.into_owned()), span: $span }
        };
    }
    match ev {
        StreamEvent::ElementStart { span } => bare!(ElementStart, span),
        StreamEvent::ElementEnd { span } => bare!(ElementEnd, span),
        StreamEvent::EmbeddedStart { span } => bare!(EmbeddedStart, span),
        StreamEvent::EmbeddedEnd { span } => bare!(EmbeddedEnd, span),
        StreamEvent::DirectiveStart { span } => bare!(DirectiveStart, span),
        StreamEvent::DirectiveEnd { span } => bare!(DirectiveEnd, span),
        StreamEvent::ArrayStart { span } => bare!(ArrayStart, span),
        StreamEvent::ArrayEnd { span } => bare!(ArrayEnd, span),
        StreamEvent::FreeformStart { span } => bare!(FreeformStart, span),
        StreamEvent::FreeformEnd { span } => bare!(FreeformEnd, span),
        StreamEvent::CommentStart { span } => bare!(CommentStart, span),
        StreamEvent::CommentEnd { span } => bare!(CommentEnd, span),
        StreamEvent::Name { content, span } => content!(Name, content, span),
        StreamEvent::Text { content, span } => content!(Text, content, span),
        StreamEvent::Attr { content, span } => content!(Attr, content, span),
        StreamEvent::StringValue { content, span } => content!(StringValue, content, span),
        StreamEvent::BareValue { content, span } => content!(BareValue, content, span),
        StreamEvent::BoolTrue { content, span } => content!(BoolTrue, content, span),
        StreamEvent::BoolFalse { content, span } => content!(BoolFalse, content, span),
        StreamEvent::Nil { content, span } => content!(Nil, content, span),
        StreamEvent::Interpolation { content, span } => content!(Interpolation, content, span),
        StreamEvent::Reference { content, span } => content!(Reference, content, span),
        StreamEvent::RawContent { content, span } => content!(RawContent, content, span),
        StreamEvent::Raw { content, span } => content!(Raw, content, span),
        StreamEvent::Integer { content, span } => content!(Integer, content, span),
        StreamEvent::Float { content, span } => content!(Float, content, span),
        StreamEvent::Rational { content, span } => content!(Rational, content, span),
        StreamEvent::Complex { content, span } => content!(Complex, content, span),
        StreamEvent::Warning { content, span } => content!(Warning, content, span),
        StreamEvent::BlankLine { content, span } => content!(BlankLine, content, span),
        StreamEvent::Error { code, span } => Event::Error { code, span },
    }
}

/// Push-based incremental tree: events in, completed root-level subtrees
/// out. See the module docs for where this sits architecturally.
pub struct TreeStream {
    builder: TreeBuilder<'static>,
    /// Container nesting depth relative to the document root.
    depth: usize,
    /// Highest span end seen for the subtree under construction (used as
    /// the finished document's extent).
    max_end: usize,
    completed: Vec<Document<'static>>,
    errors: Vec<ParseError>,
}

impl Default for TreeStream {
    fn default() -> Self {
        Self::new()
    }
}

impl TreeStream {
    pub fn new() -> Self {
        TreeStream {
            builder: TreeBuilder::new(),
            depth: 0,
            max_end: 0,
            completed: Vec::new(),
            errors: Vec::new(),
        }
    }

    /// Push one event. Completed subtrees accumulate; drain them with
    /// [`take_completed`](Self::take_completed).
    pub fn push(&mut self, event: Event<'static>) {
        use Event::*;
        match &event {
            Error { code, span } => {
                self.errors.push(ParseError {
                    code: *code,
                    message: describe_code(code),
                    span: span.clone(),
                });
                return;
            }
            ElementStart { .. } | EmbeddedStart { .. } | DirectiveStart { .. }
            | FreeformStart { .. } | CommentStart { .. } => {
                self.depth += 1;
            }
            ElementEnd { span } | EmbeddedEnd { span } | DirectiveEnd { span }
            | FreeformEnd { span } | CommentEnd { span } => {
                self.max_end = self.max_end.max(span.end);
                self.builder.handle_event(event);
                self.depth -= 1;
                if self.depth == 0 {
                    self.complete_subtree();
                }
                return;
            }
            _ => {}
        }
        if let Some(end) = event_end(&event) {
            self.max_end = self.max_end.max(end);
        }
        self.builder.handle_event(event);
        // A leaf at root level (prose line, interpolation, reference, ...)
        // is itself a complete subtree.
        if self.depth == 0 {
            self.complete_subtree();
        }
    }

    /// Push a [`StreamEvent`] (borrowed content is copied here).
    pub fn push_stream_event(&mut self, event: StreamEvent<'_>) {
        self.push(to_owned_event(event));
    }

    /// Drain the subtrees completed so far, in document order.
    pub fn take_completed(&mut self) -> Vec<Document<'static>> {
        std::mem::take(&mut self.completed)
    }

    /// Drain the errors encountered so far (the event stream recovers and
    /// continues; errors don't abort subtree delivery).
    pub fn take_errors(&mut self) -> Vec<ParseError> {
        std::mem::take(&mut self.errors)
    }

    /// Finish the stream. A source that ends mid-construct (truncated
    /// input) still yields whatever tree was built — the event parser has
    /// already emitted its own Error/close events for that case.
    pub fn finish(mut self) -> (Vec<Document<'static>>, Vec<ParseError>) {
        self.complete_subtree();
        (self.completed, self.errors)
    }

    fn complete_subtree(&mut self) {
        let builder = std::mem::replace(&mut self.builder, TreeBuilder::new());
        let doc = builder.finish(self.max_end);
        // Ship only substantive subtrees: root-level blank lines and
        // warnings build no nodes and would ship empty documents.
        if doc.root().first_child().is_some() {
            self.completed.push(doc);
        }
    }
}

/// Byte-feeding streaming tree over the pushdown (explicit-stack) parser:
/// resumable at any byte boundary, so feed chunks exactly as they arrive.
pub struct StreamingTreeParser {
    parser: PushdownParser,
    tree: TreeStream,
}

impl Default for StreamingTreeParser {
    fn default() -> Self {
        Self::new()
    }
}

impl StreamingTreeParser {
    pub fn new() -> Self {
        StreamingTreeParser { parser: PushdownParser::new(), tree: TreeStream::new() }
    }

    /// Feed a chunk of bytes; returns the subtrees completed by this chunk.
    pub fn feed(&mut self, chunk: &[u8]) -> Vec<Document<'static>> {
        let tree = &mut self.tree;
        self.parser.push_chunk(chunk, &mut |ev| tree.push_stream_event(ev));
        tree.take_completed()
    }

    /// Errors encountered so far (drained).
    pub fn take_errors(&mut self) -> Vec<ParseError> {
        self.tree.take_errors()
    }

    /// Close the stream (remaining structure runs its EOF behavior) and
    /// return the final subtrees and errors.
    pub fn finish(mut self) -> (Vec<Document<'static>>, Vec<ParseError>) {
        let tree = &mut self.tree;
        self.parser.finish(&mut |ev| tree.push_stream_event(ev));
        self.tree.finish()
    }
}

/// The end offset of an event's span, for extent tracking.
fn event_end(event: &Event<'_>) -> Option<usize> {
    use Event::*;
    let span = match event {
        ElementStart { span } | ElementEnd { span } | EmbeddedStart { span }
        | EmbeddedEnd { span } | DirectiveStart { span } | DirectiveEnd { span }
        | ArrayStart { span } | ArrayEnd { span } | FreeformStart { span }
        | FreeformEnd { span } | CommentStart { span } | CommentEnd { span } => span,
        Name { span, .. } | Text { span, .. } | Attr { span, .. }
        | StringValue { span, .. } | BareValue { span, .. } | BoolTrue { span, .. }
        | BoolFalse { span, .. } | Nil { span, .. } | Interpolation { span, .. }
        | Reference { span, .. } | RawContent { span, .. } | Raw { span, .. }
        | Integer { span, .. } | Float { span, .. } | Rational { span, .. }
        | Complex { span, .. } | Warning { span, .. } | BlankLine { span, .. }
        | Error { span, .. } => span,
    };
    Some(span.end)
}
