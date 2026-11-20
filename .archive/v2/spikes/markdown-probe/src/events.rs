// events — dump the reference parser's event stream per framed case, for the
// fence-knot probe (where the *shape* of what happened matters, not just
// whether text survived).
//
// Same caveat as classify.rs: this is the 0.9.0-alpha.2 reference parser, an
// instrument and not an oracle. See ../../../current-0.9.1-spec/DELTAS.md.
//
// STDIN: <id>\t<byte-len>\n <bytes> \n   (repeated)

use std::io::Read;
use udon_core::{Event, Parser};

fn main() {
    let mut buf = Vec::new();
    std::io::stdin().read_to_end(&mut buf).unwrap();

    let mut pos = 0usize;
    while pos < buf.len() {
        let nl = match buf[pos..].iter().position(|&b| b == b'\n') {
            Some(i) => pos + i,
            None => break,
        };
        let header = String::from_utf8_lossy(&buf[pos..nl]).into_owned();
        let mut parts = header.splitn(2, '\t');
        let id = parts.next().unwrap_or("").to_string();
        let len: usize = parts.next().unwrap_or("0").trim().parse().unwrap_or(0);
        let start = nl + 1;
        let end = start + len;
        if end > buf.len() {
            break;
        }
        let input = &buf[start..end];
        pos = end + 1;

        println!("### {}", id);
        println!("--- input:\n{}", String::from_utf8_lossy(input));
        println!("--- events:");
        let res = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            Parser::new(input).parse(|event| {
                let line = match &event {
                    Event::Text { content, .. } => {
                        format!("Text {:?}", String::from_utf8_lossy(content.as_ref()))
                    }
                    Event::BlankLine { .. } => "BlankLine (== \"\\n\")".to_string(),
                    Event::Warning { content, .. } => {
                        format!("WARNING {}", String::from_utf8_lossy(content.as_ref()))
                    }
                    Event::Error { code, .. } => format!("ERROR {:?}", code),
                    other => other.format_line(),
                };
                println!("  {}", line);
            });
        }));
        if res.is_err() {
            println!("  <PANIC>");
        }
        println!();
    }
}
