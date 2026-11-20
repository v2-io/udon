// classify — run inputs through the reference UDON parser and classify what
// happened to them, for the markdown x UDON probes.
//
// WHAT THIS MEASURES (and does not):
//   It measures the behavior of THIS reference parser build, which implements
//   0.9.0-alpha.2 (see ../../../current-0.9.1-spec/DELTAS.md for the 11 rows
//   where 0.9.1 law differs). It is an instrument, not an oracle. Where a
//   result lands on a DELTAS row or a CARVEOUTS item, the tables that consume
//   this output say so explicitly.
//
// THE TEXT-LAW INSTRUMENT
//   CORE §15.10 / MODEL §6: "document text reconstructs by pure in-order
//   concatenation of text". So the honest test of "did this input survive
//   verbatim as prose" is exactly:
//       concat(Text events, BlankLine events) == input bytes
//   with no structure-bearing events emitted. That is a mechanical check, not
//   a judgment call, which is the whole point of the probe.
//
// STDIN PROTOCOL (length-framed so case bodies can contain anything):
//       <id>\t<byte-len>\n <bytes> \n
//   repeated. STDOUT: one JSON object per case, one per line.

use std::io::{Read, Write};
use udon_core::{Event, Parser};

/// Event kinds that mean "UDON recognized structure here" — i.e. this input is
/// NOT inert prose. Text/BlankLine are the text carriers; Warning/Error are
/// anomalies, tracked separately (an anomaly alone does not mean structure was
/// recognized).
fn structural_name(ev: &Event) -> Option<&'static str> {
    Some(match ev {
        Event::Text { .. } | Event::BlankLine { .. } => return None,
        Event::Warning { .. } | Event::Error { .. } => return None,
        Event::ElementStart { .. } => "ElementStart",
        Event::ElementEnd { .. } => "ElementEnd",
        Event::EmbeddedStart { .. } => "EmbeddedStart",
        Event::EmbeddedEnd { .. } => "EmbeddedEnd",
        Event::DirectiveStart { .. } => "DirectiveStart",
        Event::DirectiveEnd { .. } => "DirectiveEnd",
        Event::ArrayStart { .. } => "ArrayStart",
        Event::ArrayEnd { .. } => "ArrayEnd",
        Event::FreeformStart { .. } => "FreeformStart",
        Event::FreeformEnd { .. } => "FreeformEnd",
        Event::CommentStart { .. } => "CommentStart",
        Event::CommentEnd { .. } => "CommentEnd",
        Event::Name { .. } => "Name",
        Event::Attr { .. } => "Attr",
        Event::StringValue { .. } => "StringValue",
        Event::BareValue { .. } => "BareValue",
        Event::BoolTrue { .. } => "BoolTrue",
        Event::BoolFalse { .. } => "BoolFalse",
        Event::Nil { .. } => "Nil",
        Event::Interpolation { .. } => "Interpolation",
        Event::Reference { .. } => "Reference",
        Event::RawContent { .. } => "RawContent",
        Event::Raw { .. } => "Raw",
        Event::Integer { .. } => "Integer",
        Event::Float { .. } => "Float",
        Event::Rational { .. } => "Rational",
        Event::Complex { .. } => "Complex",
    })
}

fn json_escape(s: &str) -> String {
    let mut out = String::with_capacity(s.len() + 8);
    for c in s.chars() {
        match c {
            '"' => out.push_str("\\\""),
            '\\' => out.push_str("\\\\"),
            '\n' => out.push_str("\\n"),
            '\r' => out.push_str("\\r"),
            '\t' => out.push_str("\\t"),
            c if (c as u32) < 0x20 => out.push_str(&format!("\\u{:04x}", c as u32)),
            c => out.push(c),
        }
    }
    out
}

fn lossy(b: &[u8]) -> String {
    String::from_utf8_lossy(b).into_owned()
}

struct Outcome {
    text: Vec<u8>,
    structural: Vec<String>,
    warnings: Vec<String>,
    errors: Vec<String>,
    panicked: bool,
}

fn run(input: &[u8]) -> Outcome {
    let mut text: Vec<u8> = Vec::new();
    let mut structural: Vec<String> = Vec::new();
    let mut warnings: Vec<String> = Vec::new();
    let mut errors: Vec<String> = Vec::new();

    let res = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        Parser::new(input).parse(|event| {
            match &event {
                Event::Text { content, .. } => {
                    text.extend_from_slice(content.as_ref());
                }
                // BlankLine carries EMPTY content bytes but *denotes* "\n" —
                // the text-wire recast's "BlankLine ≡ \n" (core/CLAUDE.md;
                // CORE §7.4 "contributes \n to text reconstruction"). Summing
                // its literal bytes would manufacture a false text-law defect,
                // which is exactly what this line exists to prevent.
                Event::BlankLine { .. } => {
                    text.push(b'\n');
                }
                Event::Warning { content, .. } => {
                    let w = lossy(content.as_ref());
                    if !warnings.contains(&w) {
                        warnings.push(w);
                    }
                }
                Event::Error { code, .. } => {
                    let e = format!("{:?}", code);
                    if !errors.contains(&e) {
                        errors.push(e);
                    }
                }
                other => {
                    if let Some(n) = structural_name(other) {
                        let n = n.to_string();
                        if !structural.contains(&n) {
                            structural.push(n);
                        }
                    }
                }
            }
        });
    }));

    Outcome {
        text,
        structural,
        warnings,
        errors,
        panicked: res.is_err(),
    }
}

/// Is the text-loss purely a matter of stripped leading indentation?
/// (CORE §7.2: stripped indentation is geometry, not text. So a mismatch that
/// disappears once you left-strip every line of BOTH sides is a dedentation
/// effect, not a drop — a materially different finding from real byte loss.)
fn differs_only_by_indent(input: &[u8], text: &[u8]) -> bool {
    let norm = |b: &[u8]| -> Vec<String> {
        lossy(b)
            .lines()
            .map(|l| l.trim_start_matches([' ', '\t']).to_string())
            .collect()
    };
    norm(input) == norm(text)
}

fn main() {
    std::panic::set_hook(Box::new(|_| {}));

    let mut buf = Vec::new();
    std::io::stdin().read_to_end(&mut buf).unwrap();

    let stdout = std::io::stdout();
    let mut out = std::io::BufWriter::new(stdout.lock());

    let mut pos = 0usize;
    while pos < buf.len() {
        // header: <id>\t<len>\n
        let nl = match buf[pos..].iter().position(|&b| b == b'\n') {
            Some(i) => pos + i,
            None => break,
        };
        let header = lossy(&buf[pos..nl]);
        let mut parts = header.splitn(2, '\t');
        let id = parts.next().unwrap_or("").to_string();
        let len: usize = parts.next().unwrap_or("0").trim().parse().unwrap_or(0);
        let start = nl + 1;
        let end = start + len;
        if end > buf.len() {
            break;
        }
        let input = &buf[start..end];
        pos = end + 1; // skip trailing \n

        let o = run(input);
        let verbatim = o.text == input;
        let indent_only = !verbatim && differs_only_by_indent(input, &o.text);

        let verdict = if o.panicked {
            "panic"
        } else if !o.structural.is_empty() {
            "structure-recognized"
        } else if verbatim {
            "prose-verbatim"
        } else if indent_only {
            "prose-dedented"
        } else {
            "text-differs"
        };

        writeln!(
            out,
            r#"{{"id":"{}","verdict":"{}","verbatim":{},"indent_only":{},"structural":[{}],"warnings":[{}],"errors":[{}],"input":"{}","text":"{}"}}"#,
            json_escape(&id),
            verdict,
            verbatim,
            indent_only,
            o.structural
                .iter()
                .map(|s| format!("\"{}\"", json_escape(s)))
                .collect::<Vec<_>>()
                .join(","),
            o.warnings
                .iter()
                .map(|s| format!("\"{}\"", json_escape(s)))
                .collect::<Vec<_>>()
                .join(","),
            o.errors
                .iter()
                .map(|s| format!("\"{}\"", json_escape(s)))
                .collect::<Vec<_>>()
                .join(","),
            json_escape(&lossy(input)),
            json_escape(&lossy(&o.text)),
        )
        .unwrap();
    }
}
