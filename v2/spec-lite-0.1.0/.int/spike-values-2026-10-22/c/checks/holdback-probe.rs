use udon_core::{PushdownParser, StreamEvent};
fn content_len(e: &StreamEvent) -> Option<(String, usize)> {
    use StreamEvent::*;
    let (k, c) = match e {
        Text{content,..} => ("Text", content), BareValue{content,..} => ("BareValue", content),
        Integer{content,..} => ("Integer", content), Float{content,..} => ("Float", content),
        StringValue{content,..} => ("StringValue", content), Raw{content,..}=>("Raw",content),
        RawContent{content,..}=>("RawContent",content),
        _ => return None };
    Some((k.to_string(), c.len()))
}
fn probe(label: &str, head: &str, n: usize, fill: u8, tail: &str) {
    let mut doc = head.as_bytes().to_vec();
    doc.extend(std::iter::repeat(fill).take(n));
    doc.extend_from_slice(tail.as_bytes());
    let mut p = PushdownParser::new();
    let mut emitted_before_tail = 0usize;
    let mut events: Vec<(String, usize)> = vec![];
    let body_end = head.len() + n;
    let mut fed = 0usize;
    for chunk in doc.chunks(4096) {
        let mut cb = |e: StreamEvent| { if let Some(x) = content_len(&e) { events.push(x); } };
        p.push_chunk(chunk, &mut cb);
        fed += chunk.len();
        if fed <= body_end { emitted_before_tail = events.iter().map(|x| x.1).sum(); }
    }
    let mut cb = |e: StreamEvent| { if let Some(x) = content_len(&e) { events.push(x); } };
    p.finish(&mut cb);
    let big: Vec<_> = events.iter().filter(|x| x.1 > 100).collect();
    println!("{label}: content bytes emitted before the terminator arrived = {emitted_before_tail}; large events after = {:?}", big);
}
fn main() {
    let n = 1_000_000;
    probe("bare text run  ", "|el :t ", n, b'a', " b\n");
    probe("digits then p  ", "|el :t ", n, b'4', "p\n");
    probe("digits then EOL", "|el :t ", n, b'4', "\n");
    probe("prose line     ", "|el\n  ", n, b'a', "\n");
    probe("quoted string  ", "|el :t \"", n, b'a', "\"\n");
}
