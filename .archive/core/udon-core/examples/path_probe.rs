//! SCRATCH probe for the paths terminator-table spike (2026-07-28).
//! Reads UDON on stdin, prints the event trace with `format_line` to stdout.
//! Not a fixture, not a test — descriptive instrument only.
use std::io::Read;
use udon_core::Parser;

fn main() {
    let mut input = Vec::new();
    std::io::stdin().read_to_end(&mut input).unwrap();

    Parser::new(&input).parse(|event| {
        println!("{}", event.format_line());
    });
}
