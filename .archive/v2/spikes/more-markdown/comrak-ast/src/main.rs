//! Print the comrak AST of a Markdown file (or stdin) as an indented tree of
//! `NodeValue` variants, with each node's payload and any parsed attributes.
//!
//! Flags mirror the `comrak` command line, so the flags in a feature table
//! can be passed through unchanged:
//!   comrak-ast -e strikethrough,table --smart --front-matter-delimiter --- FILE
//!
//! `--links` prints one line per link or image instead, classified by reading
//! its source text back through its source position: inline, full reference
//! `[x][label]`, collapsed `[x][]`, shortcut `[x]`, angle-bracket autolink, or
//! bare-URL autolink. comrak itself keeps no record of which form was used.
//! It then lists the source lines that hold link reference definitions, which
//! comrak removes from the tree.
use comrak::nodes::{AstNode, NodeValue};
use comrak::{parse_document, Arena, Options};
use std::io::Read;

fn set_extension(o: &mut Options, name: &str) {
    let e = &mut o.extension;
    match name {
        "strikethrough" => e.strikethrough = true,
        "tagfilter" => e.tagfilter = true,
        "table" => e.table = true,
        "autolink" => e.autolink = true,
        "tasklist" => e.tasklist = true,
        "superscript" => e.superscript = true,
        "footnotes" => e.footnotes = true,
        "inline-footnotes" => e.inline_footnotes = true,
        "description-lists" => e.description_lists = true,
        "multiline-block-quotes" => e.multiline_block_quotes = true,
        "math-dollars" => e.math_dollars = true,
        "math-latex" => e.math_latex = true,
        "math-code" => e.math_code = true,
        "wikilinks-title-after-pipe" => e.wikilinks_title_after_pipe = true,
        "wikilinks-title-before-pipe" => e.wikilinks_title_before_pipe = true,
        "underline" => e.underline = true,
        "subscript" => e.subscript = true,
        "spoiler" => e.spoiler = true,
        "greentext" => e.greentext = true,
        "alerts" => e.alerts = true,
        "cjk-friendly-emphasis" => e.cjk_friendly_emphasis = true,
        "subtext" => e.subtext = true,
        "highlight" => e.highlight = true,
        "insert" => e.insert = true,
        "phoenix-heex" => e.phoenix_heex = true,
        "block-directive" => e.block_directive = true,
        "header-attributes" => e.header_attributes = true,
        "fenced-code-attributes" => e.fenced_code_attributes = true,
        "inline-code-attributes" => e.inline_code_attributes = true,
        "link-attributes" => e.link_attributes = true,
        other => die(&format!("unknown extension: {other}")),
    }
}

fn die(msg: &str) -> ! {
    eprintln!("comrak-ast: {msg}");
    std::process::exit(2)
}

fn main() {
    let mut o = Options::default();
    let mut file: Option<String> = None;
    let mut links = false;
    let mut args = std::env::args().skip(1);
    while let Some(a) = args.next() {
        let mut val = |a: &str| args.next().unwrap_or_else(|| die(&format!("{a} needs a value")));
        match a.as_str() {
            "-e" | "--extension" => {
                for name in val(&a).split(',') {
                    set_extension(&mut o, name.trim());
                }
            }
            "--gfm" => {
                for name in ["strikethrough", "tagfilter", "table", "autolink", "tasklist"] {
                    set_extension(&mut o, name);
                }
            }
            "--smart" => o.parse.smart = true,
            "--relaxed-tasklist-character" => o.parse.relaxed_tasklist_matching = true,
            "--relaxed-autolinks" => o.parse.relaxed_autolinks = true,
            "--ignore-setext" => o.parse.ignore_setext = true,
            "--gemoji" => o.extension.shortcodes = true,
            "--hardbreaks" => o.render.hardbreaks = true,
            "--front-matter-delimiter" => o.extension.front_matter_delimiter = Some(val(&a)),
            "--header-id-prefix" => o.extension.header_id_prefix = Some(val(&a)),
            "--links" => links = true,
            "-h" | "--help" => {
                println!("usage: comrak-ast [-e EXT,...] [--gfm] [--smart] [--gemoji] [--relaxed-tasklist-character] [--relaxed-autolinks] [--ignore-setext] [--hardbreaks] [--front-matter-delimiter D] [--header-id-prefix P] [--links] [FILE]");
                return;
            }
            s if s.starts_with('-') && s != "-" => die(&format!("unknown option: {s}")),
            s => file = Some(s.to_string()),
        }
    }
    let mut input = String::new();
    match file.as_deref() {
        None | Some("-") => {
            std::io::stdin().read_to_string(&mut input).unwrap_or_else(|e| die(&e.to_string()));
        }
        Some(path) => input = std::fs::read_to_string(path).unwrap_or_else(|e| die(&format!("{path}: {e}"))),
    }
    let arena = Arena::new();
    let root = parse_document(&arena, &input, &o);
    if links {
        let lines = line_starts(&input);
        let mut covered = vec![false; lines.len() + 2];
        print_links(root, &input, &lines, &mut covered);
        print_definitions(&input, &covered);
    } else {
        print_node(root, 0);
    }
}

/// Byte offset at which each line starts.
fn line_starts(input: &str) -> Vec<usize> {
    let mut v = vec![0];
    v.extend(input.match_indices('\n').map(|(i, _)| i + 1));
    v
}

/// Byte offset of a 1-based (line, byte column) position.
fn offset(lines: &[usize], line: usize, col: usize) -> Option<usize> {
    lines.get(line.checked_sub(1)?).map(|s| s + col.saturating_sub(1))
}

/// Walk the tree and print every link and image in each paragraph.
///
/// Two quirks of comrak 0.54's inline source positions matter here:
///
/// - When a link has a line break between its destination and its closing
///   parenthesis or title, every later position on the next line keeps the
///   earlier line number and counts columns on through the line break. The
///   byte offset `line start + column - 1` still lands on the right byte, so
///   `offset` needs no correction for it.
/// - When a paragraph starts with reference definitions, comrak removes them
///   before parsing the inlines, and the inline lines count from the shortened
///   text: they come out too early by the number of lines removed. The fix is
///   to try line shifts from 0 up and keep the first one under which the
///   paragraph's first text and all its links read back correctly.
fn print_links<'a>(node: &'a AstNode<'a>, input: &str, lines: &[usize], covered: &mut Vec<bool>) {
    let sp = node.data().sourcepos;
    let is_container = matches!(
        node.data().value,
        NodeValue::Document | NodeValue::BlockQuote | NodeValue::List(_) | NodeValue::Item(_)
            | NodeValue::TaskItem(_) | NodeValue::DescriptionList | NodeValue::DescriptionItem(_)
            | NodeValue::DescriptionTerm | NodeValue::DescriptionDetails | NodeValue::Alert(_)
            | NodeValue::MultilineBlockQuote(_) | NodeValue::BlockDirective(_)
            | NodeValue::FootnoteDefinition(_)
    );
    if !is_container && node.data().value.block() && !matches!(node.data().value, NodeValue::Paragraph) {
        for l in sp.start.line..=sp.end.line {
            if let Some(c) = covered.get_mut(l) { *c = true; }
        }
    }
    if let NodeValue::Paragraph = node.data().value {
        let found: Vec<_> = node
            .descendants()
            .filter(|d| matches!(d.data().value, NodeValue::Link(_) | NodeValue::Image(_)))
            .collect();
        let span = node.data().sourcepos.end.line - node.data().sourcepos.start.line;
        let shift = (0..=span)
            .find(|&k| first_text_matches(node, input, lines, k)
                && found.iter().all(|l| !describe(l, input, lines, k).1.starts_with("unknown")))
            .unwrap_or(0);
        // The paragraph's text starts where its first inline does; any lines
        // above that held reference definitions. (Stock comrak reports that
        // first line `shift` lines early; the v2-io fork reports it right,
        // with a shift of 0.)
        let text_start = node.first_child().map_or(sp.start.line, |c| c.data().sourcepos.start.line + shift);
        for l in text_start..=sp.end.line {
            if let Some(c) = covered.get_mut(l) { *c = true; }
        }
        for l in found {
            let (line, kind, url, src) = describe(l, input, lines, shift);
            let what = if matches!(l.data().value, NodeValue::Image(_)) { "image" } else { "link" };
            let fixed = if shift > 0 { format!("  (lines corrected by +{shift})") } else { String::new() };
            println!("{line} {what} {kind}  url={url:?}  source={src:?}{fixed}");
        }
        return;
    }
    for child in node.children() {
        print_links(child, input, lines, covered);
    }
}

/// Source lines that no leaf block accounts for and that look like link
/// reference definitions (comrak keeps no node for a definition). Lines that
/// start with a quote or parenthesis directly under one are taken as its
/// title continuing.
fn print_definitions(input: &str, covered: &[bool]) {
    let mut prev_def = false;
    for (i, raw) in input.lines().enumerate() {
        let n = i + 1;
        let text = raw.trim_start_matches(|c: char| c == '>' || c == ' ' || c == '\t');
        let uncovered = !covered.get(n).copied().unwrap_or(false);
        let is_def = uncovered && text.starts_with('[') && text.contains("]:");
        let is_title = uncovered && prev_def && (text.starts_with('"') || text.starts_with('\'') || text.starts_with('('));
        if is_def || is_title {
            println!("{n} definition{}  source={raw:?}", if is_title { " (title line)" } else { "" });
        }
        prev_def = is_def || is_title;
    }
}

/// Does the paragraph's first child, if it is text, read back from the source
/// at this line shift?
fn first_text_matches<'a>(para: &'a AstNode<'a>, input: &str, lines: &[usize], shift: usize) -> bool {
    let Some(first) = para.first_child() else { return true };
    let ast = first.data();
    let NodeValue::Text(t) = &ast.value else { return true };
    let prefix: String = t.chars().take(6).collect();
    match offset(lines, ast.sourcepos.start.line + shift, ast.sourcepos.start.column) {
        Some(o) => input.get(o..).is_some_and(|rest| rest.starts_with(&prefix)),
        _ => false,
    }
}

/// (position, kind, url, source text) for one link or image.
fn describe<'a>(node: &'a AstNode<'a>, input: &str, lines: &[usize], shift: usize) -> (String, String, String, String) {
    let ast = node.data();
    let (is_image, url) = match &ast.value {
        NodeValue::Link(nl) => (false, nl.url.clone()),
        NodeValue::Image(nl) => (true, nl.url.clone()),
        _ => unreachable!(),
    };
    let sp = ast.sourcepos;
    let start = offset(lines, sp.start.line + shift, sp.start.column);
    let end = offset(lines, sp.end.line + shift, sp.end.column).map(|e| e + 1);
    let (start, src) = match (start, end) {
        // `get` refuses a range outside the input or off a character boundary;
        // comrak's positions can be either (see comrak-sourcepos-security-review.md).
        (Some(s), Some(e)) if s < e && input.get(s..e).is_some() => (s, &input[s..e]),
        _ => return (format!("{}:{}", sp.start.line + shift, sp.start.column), "unknown (position outside the input)".into(), url, String::new()),
    };
    drop(ast);
    let kind = classify(node, src, start, input, lines, shift, is_image);
    // Report the true line and column of the start byte.
    let line = lines.partition_point(|&l| l <= start);
    let col = start - lines[line - 1] + 1;
    (format!("{line}:{col}"), kind, url, src.to_string())
}

fn classify<'a>(
    node: &'a AstNode<'a>,
    src: &str,
    start: usize,
    input: &str,
    lines: &[usize],
    shift: usize,
    is_image: bool,
) -> String {
    let open = if is_image { "![" } else { "[" };
    if src.starts_with('<') {
        return "autolink-angle".into();
    }
    if !src.starts_with(open) {
        let text: String = node.children().filter_map(|c| c.data().value.text().map(|t| t.to_string())).collect();
        return if !src.is_empty() && src == text { "autolink-bare".into() } else { format!("unknown (source does not start with `{open}`)") };
    }
    // Where the link text's closing bracket sits: just after the last child,
    // or right after the opening bracket when the text is empty.
    let text_close = match node.last_child() {
        Some(last) => {
            let e = last.data().sourcepos.end;
            match offset(lines, e.line + shift, e.column) {
                Some(o) => o + 1,
                None => return "unknown".into(),
            }
        }
        None => start + open.len(),
    };
    let link_end = start + src.len();
    if input.as_bytes().get(text_close) != Some(&b']') {
        return format!("unknown (expected `]` at byte {text_close})");
    }
    let after = text_close + 1;
    if after >= link_end {
        return "reference-shortcut".into();
    }
    let Some(rest) = input.get(after..link_end) else {
        return "unknown (position off a character boundary)".into();
    };
    if rest.starts_with("[]") {
        "reference-collapsed".into()
    } else if rest.starts_with('[') && rest.ends_with(']') {
        format!("reference-full label={:?}", &rest[1..rest.len() - 1])
    } else if rest.starts_with('(') {
        "inline".into()
    } else {
        format!("unknown (after text: {rest:?})")
    }
}

fn print_node<'a>(node: &'a AstNode<'a>, depth: usize) {
    let ast = node.data();
    let mut line = match &ast.value {
        NodeValue::Text(t) => format!("Text {:?}", t.as_ref()),
        v => format!("{v:?}"),
    };
    if let Some(attrs) = &ast.attrs {
        line.push_str(&format!("  attrs={attrs:?}"));
    }
    println!("{}{}", "  ".repeat(depth), line);
    for child in node.children() {
        print_node(child, depth + 1);
    }
}
