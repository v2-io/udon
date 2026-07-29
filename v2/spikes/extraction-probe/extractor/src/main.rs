//! defacto-extract — probe 8's instrument (schema-ideation §6.3 item 8).
//!
//! Event-pass only, deliberately. The tree layer (udon_core::tree) drops the
//! key of flow-valued attributes (`:author Alice Smith` loses `author`; the
//! text leaks into element content) — the implied-value wire defect that
//! helped trigger the v2 wire deratification (R8). So this tool consumes the
//! event stream directly and performs the value-ownership inference itself,
//! following the documented wire semantics in core/fixtures/v0.9/*.yaml
//! (Attr carries the key; the following value/Text event is its value).
//!
//! Everything this prints PINS THE CURRENT PARSER (0.9.0-alpha.2 lineage) and
//! is debug-shaped scratch — NOT a schema format, and it must not become one
//! (O11: incidental formats get imitated as law).

use std::collections::BTreeMap;
use udon_core::{Event, Parser};

// ---------------------------------------------------------------- utilities

struct LineIndex(Vec<usize>);

impl LineIndex {
    fn new(input: &[u8]) -> Self {
        let mut starts = vec![0usize];
        for (i, b) in input.iter().enumerate() {
            if *b == b'\n' {
                starts.push(i + 1);
            }
        }
        LineIndex(starts)
    }
    fn line_of(&self, byte: usize) -> usize {
        match self.0.binary_search(&byte) {
            Ok(l) => l + 1,
            Err(l) => l,
        }
    }
}

fn excerpt(s: &str) -> String {
    let s = s.trim_end_matches('\n');
    if s.chars().count() > 44 {
        let t: String = s.chars().take(41).collect();
        format!("{}...", t)
    } else {
        s.to_string()
    }
}

// ------------------------------------------------------------------- stats

#[derive(Default)]
struct AttrStat {
    assignments: usize,
    on_n_elements: usize,
    stacked_on: usize,
    sameline: usize,
    block: usize,
    kinds: BTreeMap<String, usize>,
    samples: Vec<String>,
    positions: Vec<usize>,
}

#[derive(Default)]
struct ChildStat {
    total: usize,
    on_n_parents: usize,
    max_per_parent: usize,
}

#[derive(Default)]
struct ElemStat {
    count: usize,
    keyed: usize,
    partial_key: usize,
    key_kinds: BTreeMap<String, usize>,
    trait_counts: BTreeMap<String, usize>,
    suffix_flags: BTreeMap<String, usize>,
    attrs: BTreeMap<String, AttrStat>,
    order_sigs: BTreeMap<String, usize>,
    child_elems: BTreeMap<String, ChildStat>,
    with_text: usize,
    with_child_elems: usize,
    with_verbatim: usize,
    leaf: usize,
}

#[derive(Default)]
struct FileStats {
    elems: BTreeMap<String, ElemStat>,
    warnings: BTreeMap<String, usize>,
    warning_lines: BTreeMap<String, Vec<usize>>,
    errors: BTreeMap<String, usize>,
    error_lines: BTreeMap<String, Vec<usize>>,
    top_level: BTreeMap<String, usize>,
    top_seq: Vec<String>,
    top_text_lines: usize,
    comments: usize,
    blank_lines: usize,
    total_elements: usize,
}

// A frame on the open-element stack.
struct Frame {
    display: String, // "name", "{name}", "!name", "(anon)"
    start_line: usize,
    named: bool,
    // identity / classification
    keyed: bool,
    partial_key: bool,
    key_kind: Option<String>,
    traits: Vec<String>,
    suffix_flags: Vec<String>,
    // ordinary attrs, in order: (key, sameline, kind, sample)
    attrs: Vec<(String, bool, String, String)>,
    // children
    child_elems: BTreeMap<String, usize>,
    has_text: bool,
    has_verbatim: bool,
    any_content: bool,
}

enum PendingOwner {
    Ordinary(usize), // index into frame.attrs
    Key,
    PartialKey,
    Trait,
    SuffixFlag(String),
}

struct Extractor {
    stats: FileStats,
    stack: Vec<Frame>,
    pending: Option<PendingOwner>,
    array_depth: usize,
    in_comment: usize,
    in_raw: bool,
}

impl Extractor {
    fn new() -> Self {
        Extractor {
            stats: FileStats::default(),
            stack: Vec::new(),
            pending: None,
            array_depth: 0,
            in_comment: 0,
            in_raw: false,
        }
    }

    fn top_label(&mut self, label: String) {
        if self.stack.is_empty() {
            *self.stats.top_level.entry(label.clone()).or_default() += 1;
            if self.stats.top_seq.len() < 400 {
                self.stats.top_seq.push(label);
            }
        }
    }

    fn value_event(&mut self, kind: &str, sample: String) {
        if self.array_depth > 0 {
            return; // array items: the array itself was already credited
        }
        if let Some(owner) = self.pending.take() {
            if let Some(f) = self.stack.last_mut() {
                match owner {
                    PendingOwner::Ordinary(i) => {
                        f.attrs[i].2 = kind.to_string();
                        f.attrs[i].3 = sample;
                    }
                    PendingOwner::Key => {
                        f.keyed = true;
                        f.key_kind = Some(kind.to_string());
                    }
                    PendingOwner::PartialKey => f.partial_key = true,
                    PendingOwner::Trait => f.traits.push(sample),
                    PendingOwner::SuffixFlag(k) => f.suffix_flags.push(k),
                }
            }
        }
        // values with no pending owner and no frame: ignore (shouldn't occur)
    }

    fn close_frame(&mut self) {
        self.pending = None;
        let Some(f) = self.stack.pop() else { return };
        // credit as child of the parent
        if let Some(p) = self.stack.last_mut() {
            *p.child_elems.entry(f.display.clone()).or_default() += 1;
            p.any_content = true;
        }
        self.stats.total_elements += 1;
        let e = self.stats.elems.entry(f.display.clone()).or_default();
        e.count += 1;
        if f.keyed {
            e.keyed += 1;
            if let Some(k) = f.key_kind {
                *e.key_kinds.entry(k).or_default() += 1;
            }
        }
        if f.partial_key {
            e.partial_key += 1;
        }
        for t in f.traits {
            *e.trait_counts.entry(t).or_default() += 1;
        }
        for sf in f.suffix_flags {
            *e.suffix_flags.entry(sf).or_default() += 1;
        }
        let mut per_key: BTreeMap<String, usize> = BTreeMap::new();
        let mut sig: Vec<String> = Vec::new();
        for (pos, (key, sameline, kind, sample)) in f.attrs.iter().enumerate() {
            let st = e.attrs.entry(key.clone()).or_default();
            st.assignments += 1;
            if *sameline {
                st.sameline += 1;
            } else {
                st.block += 1;
            }
            *st.kinds.entry(kind.clone()).or_default() += 1;
            if st.samples.len() < 3 && !st.samples.contains(sample) {
                st.samples.push(sample.clone());
            }
            st.positions.push(pos);
            *per_key.entry(key.clone()).or_default() += 1;
            if sig.len() < 8 {
                sig.push(key.clone());
            }
        }
        for (key, n) in per_key {
            let st = e.attrs.get_mut(&key).unwrap();
            st.on_n_elements += 1;
            if n > 1 {
                st.stacked_on += 1;
            }
        }
        if !sig.is_empty() && e.count <= 4000 {
            *e.order_sigs.entry(sig.join(" ")).or_default() += 1;
        }
        if !f.child_elems.is_empty() {
            e.with_child_elems += 1;
        }
        for (cn, n) in f.child_elems {
            let cs = e.child_elems.entry(cn).or_default();
            cs.total += n;
            cs.on_n_parents += 1;
            cs.max_per_parent = cs.max_per_parent.max(n);
        }
        if f.has_text {
            e.with_text += 1;
        }
        if f.has_verbatim {
            e.with_verbatim += 1;
        }
        if !f.any_content {
            e.leaf += 1;
        }
    }
}

impl Frame {
    fn new(display: &str, line: usize) -> Self {
        Frame {
            display: display.to_string(),
            start_line: line,
            named: false,
            keyed: false,
            partial_key: false,
            key_kind: None,
            traits: Vec::new(),
            suffix_flags: Vec::new(),
            attrs: Vec::new(),
            child_elems: BTreeMap::new(),
            has_text: false,
            has_verbatim: false,
            any_content: false,
        }
    }
}

fn run(input: &[u8]) -> FileStats {
    let li = LineIndex::new(input);
    let mut x = Extractor::new();

    Parser::new(input).parse(|event| {
        match &event {
            Event::ElementStart { span } => {
                if let Some(PendingOwner::Ordinary(i)) = &x.pending {
                    if let Some(f) = x.stack.last_mut() {
                        f.attrs[*i].2 = "node(element)".into();
                    }
                    x.pending = None;
                }
                x.stack.push(Frame::new("(anon)", li.line_of(span.start)));
            }
            Event::EmbeddedStart { span } => {
                if let Some(PendingOwner::Ordinary(i)) = &x.pending {
                    if let Some(f) = x.stack.last_mut() {
                        f.attrs[*i].2 = "flow(inline-el)".into();
                    }
                    x.pending = None;
                }
                if let Some(f) = x.stack.last_mut() {
                    f.has_text = true; // inline elements are flow segments
                    f.any_content = true;
                }
                x.stack.push(Frame::new("{(anon)}", li.line_of(span.start)));
            }
            Event::DirectiveStart { span } => {
                if let Some(PendingOwner::Ordinary(i)) = &x.pending {
                    if let Some(f) = x.stack.last_mut() {
                        f.attrs[*i].2 = "node(directive)".into();
                    }
                    x.pending = None;
                }
                x.stack.push(Frame::new("!", li.line_of(span.start)));
            }
            Event::ElementEnd { .. } | Event::EmbeddedEnd { .. } | Event::DirectiveEnd { .. } => {
                // label top-level before popping
                if x.stack.len() == 1 {
                    let label = format!("|{}", x.stack[0].display);
                    *x.stats.top_level.entry(label.clone()).or_default() += 1;
                    if x.stats.top_seq.len() < 400 {
                        x.stats.top_seq.push(label);
                    }
                }
                x.close_frame();
            }
            Event::Name { content, .. } => {
                let n = String::from_utf8_lossy(content).to_string();
                if let Some(f) = x.stack.last_mut() {
                    if !f.named {
                        f.named = true;
                        f.display = match f.display.as_str() {
                            "{(anon)}" => format!("{{{}}}", n),
                            "!" => format!("!{}", n),
                            _ => n,
                        };
                    }
                }
            }
            Event::Attr { content, span } => {
                let key = String::from_utf8_lossy(content).to_string();
                let line = li.line_of(span.start);
                if let Some(f) = x.stack.last_mut() {
                    let sameline = line == f.start_line;
                    x.pending = Some(match key.as_str() {
                        "$key" => PendingOwner::Key,
                        "$partial-key" => PendingOwner::PartialKey,
                        "$traits" => PendingOwner::Trait,
                        "$?" | "$!" | "$*" | "$+" => PendingOwner::SuffixFlag(key),
                        _ => {
                            f.attrs.push((key, sameline, "(none)".into(), String::new()));
                            PendingOwner::Ordinary(f.attrs.len() - 1)
                        }
                    });
                }
            }
            Event::StringValue { content, .. } => {
                x.value_event("string", excerpt(&String::from_utf8_lossy(content)))
            }
            Event::BareValue { content, .. } => {
                let s = String::from_utf8_lossy(content).to_string();
                let kind = if s.starts_with('<') { "envelope?" } else { "bare" };
                x.value_event(kind, excerpt(&s))
            }
            Event::Integer { content, .. } => {
                x.value_event("int", excerpt(&String::from_utf8_lossy(content)))
            }
            Event::Float { content, .. } => {
                x.value_event("float", excerpt(&String::from_utf8_lossy(content)))
            }
            Event::Rational { content, .. } => {
                x.value_event("rational", excerpt(&String::from_utf8_lossy(content)))
            }
            Event::Complex { content, .. } => {
                x.value_event("complex", excerpt(&String::from_utf8_lossy(content)))
            }
            Event::BoolTrue { .. } => x.value_event("true", "true".into()),
            Event::BoolFalse { .. } => x.value_event("false", "false".into()),
            Event::Nil { .. } => x.value_event("nil", "nil".into()),
            Event::Reference { content, .. } => {
                if x.pending.is_some() {
                    x.value_event("reference", excerpt(&String::from_utf8_lossy(content)));
                } else if let Some(f) = x.stack.last_mut() {
                    *f.child_elems.entry("@ref".into()).or_default() += 1;
                    f.any_content = true;
                } else {
                    x.top_label("@ref".into());
                }
            }
            Event::Interpolation { content, .. } => {
                if x.pending.is_some() {
                    x.value_event("interpolation", excerpt(&String::from_utf8_lossy(content)));
                } else if let Some(f) = x.stack.last_mut() {
                    f.has_text = true;
                    f.any_content = true;
                }
            }
            Event::ArrayStart { .. } => {
                if x.array_depth == 0 {
                    x.value_event("array", "[...]".into());
                }
                x.array_depth += 1;
            }
            Event::ArrayEnd { .. } => {
                x.array_depth = x.array_depth.saturating_sub(1);
            }
            Event::Text { content, .. } => {
                if x.in_comment > 0 || x.in_raw {
                    // comment/verbatim body lines: not document text
                } else if x.pending.is_some() {
                    x.value_event("flow-text", excerpt(&String::from_utf8_lossy(content)));
                } else if let Some(f) = x.stack.last_mut() {
                    f.has_text = true;
                    f.any_content = true;
                } else {
                    x.stats.top_text_lines += 1;
                    x.top_label("text".into());
                }
            }
            Event::CommentStart { .. } => {
                x.in_comment += 1;
                x.stats.comments += 1;
            }
            Event::CommentEnd { .. } => {
                x.in_comment = x.in_comment.saturating_sub(1);
            }
            Event::FreeformStart { .. } => {
                if let Some(PendingOwner::Ordinary(i)) = &x.pending {
                    if let Some(f) = x.stack.last_mut() {
                        f.attrs[*i].2 = "node(verbatim)".into();
                    }
                    x.pending = None;
                }
                x.in_raw = true;
                if let Some(f) = x.stack.last_mut() {
                    f.has_verbatim = true;
                    f.any_content = true;
                } else {
                    x.top_label("verbatim".into());
                }
            }
            Event::FreeformEnd { .. } => x.in_raw = false,
            Event::Raw { .. } | Event::RawContent { .. } => {
                if let Some(PendingOwner::Ordinary(i)) = &x.pending {
                    if let Some(f) = x.stack.last_mut() {
                        f.attrs[*i].2 = "node(verbatim)".into();
                    }
                    x.pending = None;
                } else if x.stack.is_empty() {
                    // raw at top level with no frame: count once via top label
                } else if let Some(f) = x.stack.last_mut() {
                    f.has_verbatim = true;
                    f.any_content = true;
                }
            }
            Event::BlankLine { .. } => x.stats.blank_lines += 1,
            Event::Warning { content, span } => {
                let w = String::from_utf8_lossy(content).to_string();
                let line = li.line_of(span.start);
                *x.stats.warnings.entry(w.clone()).or_default() += 1;
                let v = x.stats.warning_lines.entry(w).or_default();
                if v.len() < 5 {
                    v.push(line);
                }
            }
            Event::Error { code, span } => {
                let c = format!("{:?}", code);
                let line = li.line_of(span.start);
                *x.stats.errors.entry(c.clone()).or_default() += 1;
                let v = x.stats.error_lines.entry(c).or_default();
                if v.len() < 5 {
                    v.push(line);
                }
            }
        }
    });
    x.stats
}

// ------------------------------------------------------------------ report

fn pct(part: usize, whole: usize) -> String {
    if whole == 0 {
        "-".into()
    } else {
        format!("{}%", (part * 100) / whole)
    }
}

fn print_file(path: &str, s: &FileStats) {
    println!("\n=== FILE {} ===", path);
    println!(
        "elements: {} | comments: {} | blank-lines: {} | top-level text lines: {}",
        s.total_elements, s.comments, s.blank_lines, s.top_text_lines
    );
    if !s.warnings.is_empty() {
        for (k, v) in &s.warnings {
            println!(
                "warning: {} x{}  (lines {:?})",
                k, v,
                s.warning_lines.get(k).unwrap_or(&vec![])
            );
        }
    }
    if !s.errors.is_empty() {
        for (k, v) in &s.errors {
            println!(
                "ERROR: {} x{}  (lines {:?})",
                k, v,
                s.error_lines.get(k).unwrap_or(&vec![])
            );
        }
    }
    if !s.top_level.is_empty() {
        let w: Vec<String> = s.top_level.iter().map(|(k, v)| format!("{}x{}", k, v)).collect();
        println!("top-level census: {}", w.join("  "));
        let seq: Vec<&str> = s.top_seq.iter().take(16).map(|x| x.as_str()).collect();
        println!(
            "top-seq[..16]: {}{}",
            seq.join(" "),
            if s.top_seq.len() > 16 { " ..." } else { "" }
        );
    }

    let mut names: Vec<(&String, &ElemStat)> = s.elems.iter().collect();
    names.sort_by(|a, b| b.1.count.cmp(&a.1.count));
    for (name, e) in names {
        println!(
            "\n  |{}  n={}  keyed={}{} text={} child-elems={} verbatim={} leaf={}",
            name,
            e.count,
            pct(e.keyed, e.count),
            if e.partial_key > 0 {
                format!(" PARTIAL-KEYx{}", e.partial_key)
            } else {
                String::new()
            },
            pct(e.with_text, e.count),
            pct(e.with_child_elems, e.count),
            pct(e.with_verbatim, e.count),
            pct(e.leaf, e.count),
        );
        if !e.key_kinds.is_empty() {
            let w: Vec<String> = e.key_kinds.iter().map(|(k, v)| format!("{}x{}", k, v)).collect();
            println!("      key-kinds: {}", w.join(" "));
        }
        if !e.trait_counts.is_empty() {
            let mut ts: Vec<(&String, &usize)> = e.trait_counts.iter().collect();
            ts.sort_by(|a, b| b.1.cmp(a.1));
            let w: Vec<String> = ts.iter().take(12).map(|(k, v)| format!(".{}x{}", k, v)).collect();
            println!("      traits: {}{}", w.join(" "), if ts.len() > 12 { " ..." } else { "" });
        }
        if !e.suffix_flags.is_empty() {
            let w: Vec<String> = e.suffix_flags.iter().map(|(k, v)| format!("{}x{}", k, v)).collect();
            println!("      suffixes: {}", w.join(" "));
        }
        let mut attrs: Vec<(&String, &AttrStat)> = e.attrs.iter().collect();
        attrs.sort_by(|a, b| b.1.on_n_elements.cmp(&a.1.on_n_elements));
        for (k, st) in attrs {
            let kinds: Vec<String> = st.kinds.iter().map(|(kk, v)| format!("{}x{}", kk, v)).collect();
            let mean_pos = if st.positions.is_empty() {
                0.0
            } else {
                st.positions.iter().sum::<usize>() as f64 / st.positions.len() as f64
            };
            println!(
                "      :{}  on {}/{} ({})  sameline {}/{}  stackedx{}  pos~{:.1}  [{}]  e.g. {:?}",
                k,
                st.on_n_elements,
                e.count,
                pct(st.on_n_elements, e.count),
                st.sameline,
                st.sameline + st.block,
                st.stacked_on,
                mean_pos,
                kinds.join(" "),
                st.samples
            );
        }
        if e.order_sigs.len() > 0 && e.count > 2 {
            let mut sigs: Vec<(&String, &usize)> = e.order_sigs.iter().collect();
            sigs.sort_by(|a, b| b.1.cmp(a.1));
            let top: Vec<String> = sigs.iter().take(3).map(|(sg, n)| format!("[{}]x{}", sg, n)).collect();
            println!("      attr-order: {}", top.join("  "));
        }
        let mut kids: Vec<(&String, &ChildStat)> = e.child_elems.iter().collect();
        kids.sort_by(|a, b| b.1.total.cmp(&a.1.total));
        for (cn, cs) in kids.iter().take(15) {
            println!(
                "      > |{}  total={} on {}/{} parents, max/parent={}",
                cn, cs.total, cs.on_n_parents, e.count, cs.max_per_parent
            );
        }
        if kids.len() > 15 {
            println!("      > ... {} more child kinds", kids.len() - 15);
        }
    }
}

fn main() {
    let args: Vec<String> = std::env::args().skip(1).collect();
    if args.is_empty() {
        eprintln!("usage: defacto-extract <file.udon> ...");
        std::process::exit(2);
    }
    for path in &args {
        match std::fs::read(path) {
            Ok(input) => {
                let stats = run(&input);
                print_file(path, &stats);
            }
            Err(e) => eprintln!("SKIP {}: {}", path, e),
        }
    }
}
