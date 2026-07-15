//! ANSI syntax highlighting straight from the event stream — no separate
//! grammar, no regexes, no tree-sitter: the parser's events with their spans
//! ARE the highlighter. Every token class arrives labeled with exact byte
//! ranges, so highlighting is just painting spans.
//!
//!     cargo run --example highlight ../examples/cheatsheet.udon
//!
//! Container ranges (comments, freeform) paint first; leaf spans paint over
//! them; unpainted bytes (sigils, indentation) stay dim — which makes the
//! structure *scaffolding* visually recede exactly the way UDON's design
//! intends prose and data to stand forward.
//!
//! This doubles as a span-fidelity audit: any mis-highlighted character is
//! a span bug. (See editors/TODO-HUMAN-UX.md — the same walk emits HTML or
//! textmate scopes as easily as ANSI.)

use std::ops::Range;
use udon_core::{Event, Parser};

// Muted 256-color palette; scaffolding dim, content forward.
const DIM: &str = "\x1b[38;5;243m"; // sigils, indentation
const NAME: &str = "\x1b[1;38;5;81m"; // element names — bold cyan
const ATTR: &str = "\x1b[38;5;179m"; // attribute keys — soft gold
const STR: &str = "\x1b[38;5;114m"; // strings / bare values — green
const NUM: &str = "\x1b[38;5;176m"; // numbers — orchid
const KW: &str = "\x1b[38;5;209m"; // booleans / nil — coral
const TEXT: &str = "\x1b[38;5;252m"; // prose — near-white
const CMT: &str = "\x1b[38;5;240;3m"; // comments — dim italic
const DYN: &str = "\x1b[38;5;110m"; // interpolation / directives / raw
const REF: &str = "\x1b[4;38;5;146m"; // references — underlined lavender
const WARN: &str = "\x1b[48;5;52m"; // warning span background
const RESET: &str = "\x1b[0m";

fn main() {
    let path = std::env::args().nth(1);
    let input: Vec<u8> = match &path {
        Some(p) => std::fs::read(p).expect("readable input file"),
        None => SAMPLE.to_vec(),
    };

    // Pass 1: collect (range, color, priority) paint ops from events.
    let mut ops: Vec<(Range<usize>, &str, u8)> = Vec::new();
    let mut containers: Vec<(usize, &str)> = Vec::new(); // (start, color)
    Parser::new(&input).parse(|e| {
        use Event::*;
        match &e {
            CommentStart { span } => containers.push((span.start, CMT)),
            FreeformStart { span } => containers.push((span.start, DYN)),
            DirectiveStart { span } => containers.push((span.start, DYN)),
            CommentEnd { span } | FreeformEnd { span } | DirectiveEnd { span } => {
                if let Some((start, color)) = containers.pop() {
                    // Comments overpaint their interior Text (priority 2);
                    // freeform/directive containers underlay theirs (0).
                    let pri = if color == CMT { 2 } else { 0 };
                    ops.push((start..span.end, color, pri));
                }
            }
            Name { span, .. } => ops.push((span.clone(), NAME, 1)),
            Attr { span, .. } => ops.push((span.clone(), ATTR, 1)),
            StringValue { span, .. } | BareValue { span, .. } => {
                ops.push((span.clone(), STR, 1))
            }
            Integer { span, .. } | Float { span, .. } | Rational { span, .. }
            | Complex { span, .. } => ops.push((span.clone(), NUM, 1)),
            BoolTrue { span, .. } | BoolFalse { span, .. } | Nil { span, .. } => {
                ops.push((span.clone(), KW, 1))
            }
            Text { span, .. } | RawContent { span, .. } => {
                ops.push((span.clone(), TEXT, 1))
            }
            Interpolation { span, .. } => ops.push((span.clone(), DYN, 2)),
            Reference { span, .. } => ops.push((span.clone(), REF, 2)),
            Warning { span, .. } => ops.push((span.clone(), WARN, 3)),
            _ => {}
        }
    });

    // Pass 2: byte-color table, low priority first so leaves overpaint.
    let mut color: Vec<&str> = vec![DIM; input.len()];
    ops.sort_by_key(|(_, _, pri)| *pri);
    for (range, c, _) in &ops {
        for slot in color
            .iter_mut()
            .take(range.end.min(input.len()))
            .skip(range.start)
        {
            *slot = c;
        }
    }

    // Pass 3: emit as runs.
    let mut current = "";
    let mut out = String::with_capacity(input.len() * 2);
    for (i, &b) in input.iter().enumerate() {
        if color[i] != current {
            out.push_str(RESET);
            out.push_str(color[i]);
            current = color[i];
        }
        out.push(b as char);
    }
    out.push_str(RESET);
    print!("{out}");
}

const SAMPLE: &[u8] = br#"|article[intro].featured
  :author Joseph Wecker
  :retries 3
  :active true
  :when <2026-07-15>          ; interim: warns, passes through
  :license @spdx[MIT]

  |heading Welcome to UDON

  Structure and prose coexist -- **markdown survives**, and a
  wink ;-) is not a comment, but this is ; a real sameline comment

  !if user
    Hello, !{{user.name | capitalize}}!

  ```
  verbatim |markers stay literal
  ```
"#;
