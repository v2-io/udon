//! S5 spike: explicit-stack (pushdown) transformation of descent's emission model.
//!
//! Toy grammar (subset of udon.desc shapes, exercising every crux):
//!
//!   |type[Element] BRACKET
//!   |type[Name]    CONTENT
//!   |type[Text]    CONTENT
//!   |type[INT]     INTERNAL
//!
//!   |function[document]                          ; void
//!     |state[:line]
//!       |c['\n']  | ->                       |>>
//!       |c[' ']   | col = /count_indent      |>> :dispatch   ; CRUX 1: call w/ return value
//!       |default  | col = COL - 1            |>> :dispatch
//!     |state[:dispatch]
//!       |c['\n']  | ->                       |>> :line
//!       |c['|']   | -> | /element(col, -1)   |>> :line       ; CRUX 1: call w/ args
//!       |default  | /text(col)               |>> :line
//!
//!   |function[count_indent:INT] | result = 0
//!     |state[:main]
//!       |c[' ']   | -> | result += 1         |>>
//!       |default  |                          |return result
//!
//!   |function[element:Element] :elem_col :parent_col          ; CRUX 3: indent via params
//!     |state[:identity]
//!       |LETTER   | /name                    |>> :after
//!       |default  |                          |>> :after
//!     |state[:after]
//!       |c['\n']  | ->                       |>> :children
//!       |c[' ']   | ->                       |>>
//!       |default  | /text(:elem_col)         |>> :children
//!     |state[:children]
//!       |c['\n']  | ->                       |>>
//!       |c[' ']   | col = /count_indent      |>> :check
//!       |default  | col = COL - 1            |>> :check
//!     |state[:check]
//!       |if[col <= :elem_col]                |return          ; dedent -> cascading pops
//!       |c['|']   | -> | /element(col, :elem_col) |>> :children
//!       |default  | /text(col)               |>> :children
//!
//!   |function[name:Name]                                      ; CRUX 2: MARK/auto-emit
//!     |state[:main]
//!       |LABEL_CONT | ->                     |>>
//!       |default    |                        |return
//!
//!   |function[text:Text] :col                                 ; CRUX 2: TERM(-1) lookahead
//!     |state[:main]
//!       |c['\n']  |                          |return          ; auto-emit, \n not consumed
//!       |c[';']   | ->                       |>> :check_semi
//!       |c[<BS>]  | -> | ->                  |>>              ; escape: MULTI-ADVANCE sequence
//!       |default  | ->                       |>>
//!     |state[:check_semi]
//!       |c[';']   | TERM(-1) | -> |          |return          ; ";;" ends text, drop 1st ';'
//!       |default  |                          |>> :main
//!
//! Implementation A (`rec`) mirrors descent's CURRENT generated code: recursive
//! functions, per-function State enum + loop, mark/term/prepend on self.
//! Implementation B (`pd`) is the PROPOSED explicit-stack machine: same grammar,
//! same events, reified frames, suspendable at any byte boundary (push_chunk/finish).
//! main() differential-tests them across every chunk split.

use std::fmt;

// ============================== Events =====================================

#[derive(Clone, PartialEq)]
enum Ev {
    ElementStart { at: usize },
    ElementEnd { at: usize },
    Name { content: Vec<u8>, span: (usize, usize) },
    Text { content: Vec<u8>, span: (usize, usize) },
}

impl fmt::Debug for Ev {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Ev::ElementStart { at } => write!(f, "ElementStart@{}", at),
            Ev::ElementEnd { at } => write!(f, "ElementEnd@{}", at),
            Ev::Name { content, span } => write!(
                f, "Name({:?})@{}..{}", String::from_utf8_lossy(content), span.0, span.1),
            Ev::Text { content, span } => write!(
                f, "Text({:?})@{}..{}", String::from_utf8_lossy(content), span.0, span.1),
        }
    }
}

fn is_letter(b: u8) -> bool { b.is_ascii_alphabetic() }
fn is_label_cont(b: u8) -> bool { b.is_ascii_alphanumeric() || b == b'_' || b == b'-' }

// ================= Implementation A: recursive (current descent model) =====

struct Rec<'a> {
    input: &'a [u8],
    pos: usize,
    mark_pos: usize,
    term_pos: usize, // usize::MAX = unset
    column: u32,
}

impl<'a> Rec<'a> {
    fn new(input: &'a [u8]) -> Self {
        Rec { input, pos: 0, mark_pos: 0, term_pos: usize::MAX, column: 1 }
    }
    fn peek(&self) -> Option<u8> { self.input.get(self.pos).copied() }
    fn advance(&mut self) {
        if self.pos < self.input.len() {
            if self.input[self.pos] == b'\n' { self.column = 1 } else { self.column += 1 }
            self.pos += 1;
        }
    }
    fn col(&self) -> i32 { self.column as i32 }
    fn mark(&mut self) { self.mark_pos = self.pos; self.term_pos = usize::MAX; }
    fn set_term(&mut self, off: i32) {
        let p = self.pos as i64 + off as i64;
        self.term_pos = p.clamp(0, self.input.len() as i64) as usize;
    }
    fn term_end(&self) -> usize {
        if self.term_pos != usize::MAX { self.term_pos } else { self.pos }
    }
    fn take_marked(&self) -> (Vec<u8>, (usize, usize)) {
        let end = self.term_end();
        (self.input[self.mark_pos..end].to_vec(), (self.mark_pos, end))
    }

    // --- document (void) ---
    fn parse_document(&mut self, ev: &mut Vec<Ev>) {
        #[derive(Clone, Copy)] enum St { Line, Dispatch }
        let mut st = St::Line;
        let mut col: i32 = 0;
        loop {
            match st {
                St::Line => match self.peek() {
                    None => return,
                    Some(b'\n') => { self.advance(); }
                    Some(b' ') => { col = self.parse_count_indent(ev); st = St::Dispatch; }
                    Some(_) => { col = self.col() - 1; st = St::Dispatch; }
                },
                St::Dispatch => match self.peek() {
                    None => return,
                    Some(b'\n') => { self.advance(); st = St::Line; }
                    Some(b'|') => { self.advance(); self.parse_element(col, -1, ev); st = St::Line; }
                    Some(_) => { self.parse_text(col, ev); st = St::Line; }
                },
            }
        }
    }

    // --- count_indent (INTERNAL -> i32) ---
    fn parse_count_indent(&mut self, _ev: &mut Vec<Ev>) -> i32 {
        let mut result: i32 = 0;
        loop {
            match self.peek() {
                Some(b' ') => { self.advance(); result += 1; }
                _ => return result,
            }
        }
    }

    // --- element (BRACKET) ---
    fn parse_element(&mut self, elem_col: i32, _parent_col: i32, ev: &mut Vec<Ev>) {
        ev.push(Ev::ElementStart { at: self.pos });
        #[derive(Clone, Copy)] enum St { Identity, After, Children, Check }
        let mut st = St::Identity;
        let mut col: i32 = 0;
        loop {
            match st {
                St::Identity => match self.peek() {
                    None => { ev.push(Ev::ElementEnd { at: self.pos }); return; }
                    Some(b) if is_letter(b) => { self.parse_name(ev); st = St::After; }
                    Some(_) => { st = St::After; }
                },
                St::After => match self.peek() {
                    None => { ev.push(Ev::ElementEnd { at: self.pos }); return; }
                    Some(b'\n') => { self.advance(); st = St::Children; }
                    Some(b' ') => { self.advance(); }
                    Some(_) => { self.parse_text(elem_col, ev); st = St::Children; }
                },
                St::Children => match self.peek() {
                    None => { ev.push(Ev::ElementEnd { at: self.pos }); return; }
                    Some(b'\n') => { self.advance(); }
                    Some(b' ') => { col = self.parse_count_indent(ev); st = St::Check; }
                    Some(_) => { col = self.col() - 1; st = St::Check; }
                },
                St::Check => {
                    if col <= elem_col { ev.push(Ev::ElementEnd { at: self.pos }); return; }
                    match self.peek() {
                        None => { ev.push(Ev::ElementEnd { at: self.pos }); return; }
                        Some(b'|') => { self.advance(); self.parse_element(col, elem_col, ev); st = St::Children; }
                        Some(_) => { self.parse_text(col, ev); st = St::Children; }
                    }
                }
            }
        }
    }

    // --- name (CONTENT: MARK on entry, auto-emit on return) ---
    fn parse_name(&mut self, ev: &mut Vec<Ev>) {
        self.mark();
        loop {
            match self.peek() {
                Some(b) if is_label_cont(b) => self.advance(),
                _ => {
                    let (c, s) = self.take_marked();
                    ev.push(Ev::Name { content: c, span: s });
                    return;
                }
            }
        }
    }

    // --- text (CONTENT with TERM(-1) lookahead) ---
    fn parse_text(&mut self, _col: i32, ev: &mut Vec<Ev>) {
        self.mark();
        #[derive(Clone, Copy)] enum St { Main, CheckSemi }
        let mut st = St::Main;
        loop {
            match st {
                St::Main => match self.peek() {
                    None | Some(b'\n') => {
                        let (c, s) = self.take_marked();
                        ev.push(Ev::Text { content: c, span: s });
                        return;
                    }
                    Some(b';') => { self.advance(); st = St::CheckSemi; }
                    // escape: `| -> | ->` — two advances in one command sequence
                    // (mirrors skip_single_quoted / double_quoted in udon.desc)
                    Some(b'\\') => { self.advance(); self.advance(); }
                    Some(_) => { self.advance(); }
                },
                St::CheckSemi => match self.peek() {
                    None => {
                        let (c, s) = self.take_marked();
                        ev.push(Ev::Text { content: c, span: s });
                        return;
                    }
                    Some(b';') => {
                        self.set_term(-1);
                        self.advance();
                        let (c, s) = self.take_marked();
                        ev.push(Ev::Text { content: c, span: s });
                        return;
                    }
                    Some(_) => { st = St::Main; }
                },
            }
        }
    }
}

// ============ Implementation B: explicit-stack pushdown machine ============
//
// Frames reify (params, locals, continuation) per grammar function.
// Continuation labels: one per state, PLUS one per call site (the point after
// a /call returns, carrying the remainder of the command sequence + transition).

#[derive(Clone, Copy, Debug)]
enum DocSt {
    Line,
    AfterCount,        // continuation of `col = /count_indent` -> reads ret, goto Dispatch
    Dispatch,
    AfterElement,      // continuation after /element returns -> goto Line
    AfterText,         // continuation after /text returns -> goto Line
}

#[derive(Clone, Copy, Debug)]
enum ElSt {
    Identity,
    AfterName,         // continuation after /name -> goto After
    After,
    AfterSamelineText, // continuation after /text -> goto Children
    Children,
    AfterCount,        // continuation of `col = /count_indent` -> goto Check
    Check,
    AfterChild,        // continuation after /element -> goto Children
    AfterChildText,    // continuation after /text -> goto Children
}

#[derive(Clone, Copy, Debug)]
enum TxSt { Main, CheckSemi }

#[derive(Clone, Copy, Debug)]
enum Frame {
    Document { st: DocSt, col: i32 },
    CountIndent { result: i32 },
    Element { st: ElSt, elem_col: i32, _parent_col: i32, col: i32 },
    Name,
    Text { st: TxSt, _col: i32 },
}

#[derive(PartialEq, Debug)]
enum Status { NeedMore, Done }

struct Pd {
    stack: Vec<Frame>,
    ret: i32, // return-value register for INTERNAL functions
    // chunked input
    chunk: Vec<u8>,
    pos: usize,      // position within current chunk
    global: usize,   // global offset of chunk start
    at_eof: bool,
    column: u32,
    /// Bytes still to be consumed blindly from a multi-advance command
    /// sequence (`| -> | ->`) interrupted by a chunk boundary.
    pending_skip: u8,
    // content capture (CRUX 2)
    mark_active: bool,
    mark_start: usize,        // within current chunk
    carry: Vec<u8>,           // marked bytes carried across chunk boundaries
    mark_global_start: usize, // global span start of the active mark
}

impl Pd {
    fn new() -> Self {
        Pd {
            stack: vec![Frame::Document { st: DocSt::Line, col: 0 }],
            ret: 0,
            chunk: Vec::new(),
            pos: 0,
            global: 0,
            at_eof: false,
            column: 1,
            pending_skip: 0,
            mark_active: false,
            mark_start: 0,
            carry: Vec::new(),
            mark_global_start: 0,
        }
    }

    // ---- input primitives ----
    fn peek(&self) -> Option<u8> { self.chunk.get(self.pos).copied() }
    fn advance(&mut self) {
        if self.pos < self.chunk.len() {
            if self.chunk[self.pos] == b'\n' { self.column = 1 } else { self.column += 1 }
            self.pos += 1;
        }
    }
    fn col(&self) -> i32 { self.column as i32 }
    fn gpos(&self) -> usize { self.global + self.pos }

    // ---- capture primitives ----
    fn mark(&mut self) {
        self.mark_active = true;
        self.mark_start = self.pos;
        self.carry.clear();
        self.mark_global_start = self.gpos();
    }
    /// Emit-marked with a term offset (0 = up to pos). Handles offsets that
    /// reach back across the chunk boundary into `carry` (the TERM(-1) case).
    fn take_marked(&mut self, off: i32) -> (Vec<u8>, (usize, usize)) {
        let end_i = self.pos as i64 + off as i64; // may be < mark_start, even < 0
        let gend = (self.gpos() as i64 + off as i64).max(self.mark_global_start as i64) as usize;
        let mut content = std::mem::take(&mut self.carry);
        if end_i >= self.mark_start as i64 {
            content.extend_from_slice(&self.chunk[self.mark_start..end_i as usize]);
        } else {
            // deficit reaches into carried bytes: drop them from the tail
            let deficit = (self.mark_start as i64 - end_i) as usize;
            let keep = content.len().saturating_sub(deficit);
            content.truncate(keep);
        }
        self.mark_active = false;
        (content, (self.mark_global_start, gend))
    }
    /// Called when suspending: preserve the in-flight marked region.
    fn flush_mark_to_carry(&mut self) {
        if self.mark_active && self.mark_start < self.pos {
            self.carry.extend_from_slice(&self.chunk[self.mark_start..self.pos]);
        }
        self.mark_start = self.pos; // will be reset to 0 with the new chunk
    }

    // ---- frame primitives ----
    fn set_top(&mut self, f: Frame) { *self.stack.last_mut().unwrap() = f; }

    // ---- public chunked API ----
    fn push_chunk(&mut self, data: &[u8], ev: &mut Vec<Ev>) -> Status {
        assert!(!self.at_eof, "push_chunk after finish");
        self.global += self.chunk.len();
        self.chunk = data.to_vec();
        self.pos = 0;
        self.mark_start = 0;
        self.run(ev)
    }
    fn finish(&mut self, ev: &mut Vec<Ev>) {
        self.at_eof = true;
        let st = self.run(ev);
        assert_eq!(st, Status::Done, "finish must drain the stack");
    }

    /// The trampoline. Executes until input is exhausted (suspend) or the
    /// stack empties (done). This is what a `descent` pushdown backend would
    /// generate: one dispatch site per (function, continuation) pair.
    fn run(&mut self, ev: &mut Vec<Ev>) -> Status {
        macro_rules! need {
            ($self:ident) => {
                match $self.peek() {
                    Some(b) => Some(b),
                    None if $self.at_eof => None, // genuine EOF
                    None => { $self.flush_mark_to_carry(); return Status::NeedMore; }
                }
            };
        }

        loop {
            // Drain any advance-sequence interrupted by a chunk boundary
            // BEFORE dispatching the current state (the state itself is
            // unchanged; only raw consumption was pending).
            while self.pending_skip > 0 {
                if self.pos < self.chunk.len() {
                    self.advance();
                    self.pending_skip -= 1;
                } else if self.at_eof {
                    self.pending_skip = 0; // advance-at-EOF is a no-op (matches rec)
                } else {
                    self.flush_mark_to_carry();
                    return Status::NeedMore;
                }
            }
            let Some(&top) = self.stack.last() else { return Status::Done };
            match top {
                // ---------------- document ----------------
                Frame::Document { st, col } => match st {
                    DocSt::Line => match need!(self) {
                        None => { self.stack.pop(); } // void return
                        Some(b'\n') => { self.advance(); }
                        Some(b' ') => {
                            // col = /count_indent : push frame, resume at AfterCount
                            self.set_top(Frame::Document { st: DocSt::AfterCount, col });
                            self.stack.push(Frame::CountIndent { result: 0 });
                        }
                        Some(_) => {
                            let c = self.col() - 1;
                            self.set_top(Frame::Document { st: DocSt::Dispatch, col: c });
                        }
                    },
                    DocSt::AfterCount => {
                        let c = self.ret;
                        self.set_top(Frame::Document { st: DocSt::Dispatch, col: c });
                    }
                    DocSt::Dispatch => match need!(self) {
                        None => { self.stack.pop(); }
                        Some(b'\n') => {
                            self.advance();
                            self.set_top(Frame::Document { st: DocSt::Line, col });
                        }
                        Some(b'|') => {
                            self.advance();
                            self.set_top(Frame::Document { st: DocSt::AfterElement, col });
                            let at = self.gpos();
                            ev.push(Ev::ElementStart { at }); // BRACKET: Start on entry
                            self.stack.push(Frame::Element {
                                st: ElSt::Identity, elem_col: col, _parent_col: -1, col: 0,
                            });
                        }
                        Some(_) => {
                            self.set_top(Frame::Document { st: DocSt::AfterText, col });
                            self.mark(); // CONTENT: MARK on entry
                            self.stack.push(Frame::Text { st: TxSt::Main, _col: col });
                        }
                    },
                    DocSt::AfterElement | DocSt::AfterText => {
                        self.set_top(Frame::Document { st: DocSt::Line, col });
                    }
                },

                // ---------------- count_indent (INTERNAL) ----------------
                Frame::CountIndent { result } => match need!(self) {
                    Some(b' ') => {
                        self.advance();
                        self.set_top(Frame::CountIndent { result: result + 1 });
                    }
                    _ => { // default or EOF: return result
                        self.ret = result;
                        self.stack.pop();
                    }
                },

                // ---------------- element (BRACKET) ----------------
                Frame::Element { st, elem_col, _parent_col, col } => match st {
                    ElSt::Identity => match need!(self) {
                        Some(b) if is_letter(b) => {
                            self.set_top(Frame::Element { st: ElSt::AfterName, elem_col, _parent_col, col });
                            self.mark();
                            self.stack.push(Frame::Name);
                        }
                        Some(_) => { self.set_top(Frame::Element { st: ElSt::After, elem_col, _parent_col, col }); }
                        None => { let at = self.gpos(); ev.push(Ev::ElementEnd { at }); self.stack.pop(); }
                    },
                    ElSt::AfterName => {
                        self.set_top(Frame::Element { st: ElSt::After, elem_col, _parent_col, col });
                    }
                    ElSt::After => match need!(self) {
                        None => { let at = self.gpos(); ev.push(Ev::ElementEnd { at }); self.stack.pop(); }
                        Some(b'\n') => {
                            self.advance();
                            self.set_top(Frame::Element { st: ElSt::Children, elem_col, _parent_col, col });
                        }
                        Some(b' ') => { self.advance(); }
                        Some(_) => {
                            self.set_top(Frame::Element { st: ElSt::AfterSamelineText, elem_col, _parent_col, col });
                            self.mark();
                            self.stack.push(Frame::Text { st: TxSt::Main, _col: elem_col });
                        }
                    },
                    ElSt::AfterSamelineText | ElSt::AfterChild | ElSt::AfterChildText => {
                        self.set_top(Frame::Element { st: ElSt::Children, elem_col, _parent_col, col });
                    }
                    ElSt::Children => match need!(self) {
                        None => { let at = self.gpos(); ev.push(Ev::ElementEnd { at }); self.stack.pop(); }
                        Some(b'\n') => { self.advance(); }
                        Some(b' ') => {
                            self.set_top(Frame::Element { st: ElSt::AfterCount, elem_col, _parent_col, col });
                            self.stack.push(Frame::CountIndent { result: 0 });
                        }
                        Some(_) => {
                            let c = self.col() - 1;
                            self.set_top(Frame::Element { st: ElSt::Check, elem_col, _parent_col, col: c });
                        }
                    },
                    ElSt::AfterCount => {
                        let c = self.ret;
                        self.set_top(Frame::Element { st: ElSt::Check, elem_col, _parent_col, col: c });
                    }
                    ElSt::Check => {
                        // CRUX 3: dedent check needs NO input byte -> unwind is
                        // always executable regardless of chunk state.
                        if col <= elem_col {
                            let at = self.gpos();
                            ev.push(Ev::ElementEnd { at });
                            self.stack.pop();
                            continue;
                        }
                        match need!(self) {
                            None => { let at = self.gpos(); ev.push(Ev::ElementEnd { at }); self.stack.pop(); }
                            Some(b'|') => {
                                self.advance();
                                self.set_top(Frame::Element { st: ElSt::AfterChild, elem_col, _parent_col, col });
                                let at = self.gpos();
                                ev.push(Ev::ElementStart { at });
                                self.stack.push(Frame::Element {
                                    st: ElSt::Identity, elem_col: col, _parent_col: elem_col, col: 0,
                                });
                            }
                            Some(_) => {
                                self.set_top(Frame::Element { st: ElSt::AfterChildText, elem_col, _parent_col, col });
                                self.mark();
                                self.stack.push(Frame::Text { st: TxSt::Main, _col: col });
                            }
                        }
                    }
                },

                // ---------------- name (CONTENT) ----------------
                Frame::Name => match need!(self) {
                    Some(b) if is_label_cont(b) => { self.advance(); }
                    _ => {
                        let (c, s) = self.take_marked(0);
                        ev.push(Ev::Name { content: c, span: s });
                        self.stack.pop();
                    }
                },

                // ---------------- text (CONTENT, TERM(-1)) ----------------
                Frame::Text { st, _col } => match st {
                    TxSt::Main => match need!(self) {
                        None | Some(b'\n') => {
                            let (c, s) = self.take_marked(0);
                            ev.push(Ev::Text { content: c, span: s });
                            self.stack.pop();
                        }
                        Some(b';') => {
                            self.advance();
                            self.set_top(Frame::Text { st: TxSt::CheckSemi, _col });
                        }
                        Some(b'\\') => {
                            // `| -> | ->`: first advance has its byte (just peeked);
                            // the second is deferred through pending_skip so a chunk
                            // boundary between them suspends cleanly.
                            self.advance();
                            self.pending_skip += 1;
                        }
                        Some(_) => { self.advance(); }
                    },
                    TxSt::CheckSemi => match need!(self) {
                        None => {
                            let (c, s) = self.take_marked(0);
                            ev.push(Ev::Text { content: c, span: s });
                            self.stack.pop();
                        }
                        Some(b';') => {
                            // TERM(-1) may reach across the chunk boundary into carry
                            let (c, s) = self.take_marked(-1);
                            self.advance();
                            ev.push(Ev::Text { content: c, span: s });
                            self.stack.pop();
                        }
                        Some(_) => { self.set_top(Frame::Text { st: TxSt::Main, _col }); }
                    },
                },
            }
        }
    }
}

// ============================== Test harness ===============================

fn run_rec(input: &[u8]) -> Vec<Ev> {
    let mut ev = Vec::new();
    Rec::new(input).parse_document(&mut ev);
    ev
}

fn run_pd_chunked(input: &[u8], chunk_size: usize) -> (Vec<Ev>, usize) {
    let mut ev = Vec::new();
    let mut pd = Pd::new();
    let mut suspensions = 0;
    if input.is_empty() {
        pd.finish(&mut ev);
        return (ev, 0);
    }
    for chunk in input.chunks(chunk_size) {
        match pd.push_chunk(chunk, &mut ev) {
            Status::NeedMore => suspensions += 1,
            Status::Done => unreachable!("Done before finish"),
        }
    }
    pd.finish(&mut ev);
    (ev, suspensions)
}

fn main() {
    let docs: Vec<(&str, &[u8])> = vec![
        ("review defect-1 case", b"|parent\n  |child\n"),
        ("nesting + dedent cascade", b"|a\n  |b hello\n  |c\n    |d\ntext\n"),
        ("plain prose + ;; term(-1)", b"plain prose\nmore ;; after\n"),
        ("semi at chunk edge", b"|a\n   deep text with ; semi\n|b\n"),
        ("prose ending in ;", b"trailing;"),
        ("double-semi only", b";;\n"),
        ("empty", b""),
        ("blank lines", b"\n\n\n"),
        ("indented doc", b"   |x1 name-2 here\n     child text\n   |y\n"),
        ("deep unwind at eof", b"|a\n  |b\n    |c\n      |d"),
        ("no trailing newline", b"|a\n  |b tail"),
        ("ws only line", b"|a\n \n  |b\n"),
        ("escape mid-text", b"escape \\; not term ;; yes\n"),
        ("trailing backslash", b"trailing \\"),
        ("escaped newline", b"a\\\nb;;x\n"),
        ("escaped semi pair", b"keep \\;; and ;\\; both\n"),
    ];

    let mut total = 0;
    let mut failed = 0;
    let mut max_susp = 0;
    for (label, doc) in &docs {
        let expected = run_rec(doc);
        let sizes: Vec<usize> = (1..=doc.len().max(1)).collect();
        for &sz in &sizes {
            let (got, susp) = run_pd_chunked(doc, sz);
            max_susp = max_susp.max(susp);
            total += 1;
            if got != expected {
                failed += 1;
                if failed <= 3 {
                    println!("FAIL [{}] chunk_size={}", label, sz);
                    println!("  input:    {:?}", String::from_utf8_lossy(doc));
                    println!("  expected: {:?}", expected);
                    println!("  got:      {:?}", got);
                }
            }
        }
        // show the 1-byte event stream for the defect-1 case
        if *label == "review defect-1 case" {
            let (got, susp) = run_pd_chunked(doc, 1);
            println!("defect-1 case, 1-byte chunks ({} suspensions):", susp);
            for e in &got { println!("  {:?}", e); }
            println!();
        }
    }
    println!("{} chunking configurations tested, {} failed (max suspensions in one run: {})",
             total, failed, max_susp);
    if failed == 0 {
        println!("OK: explicit-stack machine is event-identical to recursive parser at every byte boundary");
    }
    std::process::exit(if failed == 0 { 0 } else { 1 });
}
