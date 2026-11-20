//! A Rust sketch of the lite AST, 2026-10-20.
//!
//! Written to ground the tree-notation discussion in concrete types. Every
//! `OPEN:` comment marks a point no card settles, or one Joseph has reopened.
//! Cards are cited as [[kind:slug]]. Nothing here is a ruling.

/// What a successful parse gives. Errors give no tree at all
/// ([[decision:errors-stop-parsing]]); warnings travel beside the tree.
pub struct Parse {
    pub root: Root,
    pub warnings: Vec<Warning>,
}

pub type ParseResult = Result<Parse, Error>;

/// The implied root ([[rule:one-root-node]]). Never spelled. It holds the
/// top-level attribute lines ([[rule:top-level-attributes]]) and the
/// top-level items, in order.
///
/// OPEN, leaning closed: Joseph, 2026-10-21: the root is "nothing more than
/// an element with some extra metadata attributes and an indentation column
/// … as -1". Under that lean this struct collapses into `Element` (no spelled
/// name, column -1 in meta, parser-supplied facts as `$`-attributes), and
/// `Held` collapses into `Vec<Occurrence>` with cardinality enforced by
/// getters rather than by shape (same day). Kept as written for the record.
pub struct Root {
    pub attributes: Vec<Attribute>,
    pub children: Vec<Node>,
    pub meta: Meta, // e.g. filename ([[rule:root-meta]])
}

/// A child of the root or of an element, in source order.
pub enum Node {
    Element(Element),
    /// Prose under an owner ([[rule:text-lines-join]]).
    Text(Text),
    /// A comment block ([[rule:comment-blocks]]), or a framed comment whose
    /// nearest item was an element: "just the next child" (Joseph, 2026-10-20).
    Comment(Comment),
    Fence(Fence),
}

/// What `|name` makes ([[def:node]]). `$key`, `$traits` and `$main` are
/// ordinary entries in `attributes`, in written order: the tree is the
/// desugared form.
pub struct Element {
    /// `|[k]` and `|.t` have none ([[def:element-name]]).
    pub name: Option<Name>,
    pub attributes: Vec<Attribute>,
    pub children: Vec<Node>,
    pub meta: Meta,
}

/// An identifying name, bare or quoted ([[def:label]], [[def:quoted-name]]).
/// Whether it was quoted is form, kept for round-trip.
pub struct Name {
    pub text: String,
    pub form: NameForm,
}

pub enum NameForm {
    Bare,
    Double,
    Single,
}

/// One attribute of an element or the root: a name and what it holds.
///
/// Stacking ([[def:stacking]]): the same name written again on the same
/// owner. Joseph, 2026-08-09: stacking "turns what was just a simple scalar
/// into a list of scalars"; a single occurrence is not a one-item list.
/// The enum encodes exactly that, so a consumer can't mistake one for the
/// other.
///
/// OPEN: whether `:x 1 :x 2` and `:x [1 2]` read the same is a view, not a
/// tree question (`rule:repeated-attributes` gap). The tree keeps them apart.
pub struct Attribute {
    pub name: Name,
    pub held: Held,
    pub meta: Meta,
}

pub enum Held {
    One(Occurrence),
    /// Two or more, in written order. Never length 0 or 1.
    Stacked(Vec<Occurrence>),
}

/// One written occurrence of an attribute: its value, plus whatever was
/// attached to it on its line. Attachments never change the value's
/// cardinality (Joseph, 2026-10-20).
pub struct Occurrence {
    pub value: Value,
    /// A framed ` ; …` on this occurrence's line attaches here, since the
    /// attribute was the nearest item (Joseph, 2026-10-20). Not a value.
    pub comment: Option<Comment>,
    pub meta: Meta,
}

/// A value: kind by spelling, never by sniffing ([[def:typed-value]]). Each
/// kind carries the form it was written in, so round-trip needs no second
/// lookup. (Joseph's `::kind.form`, 2026-10-20.)
pub enum Value {
    /// `hello`, `"hello"`, `'hello'`: one kind, three forms (Joseph's
    /// 2026-10-20 sketch: `::string.bare`, `::string.delimited`).
    ///
    /// OPEN: the cards still make bare `hello` a one-run `Text`
    /// ([[def:string]], [[def:text]]). This follows his sketch: bare
    /// material with no embeds is a string.
    String { content: String, form: StringForm },
    /// OPEN: the numeric subkinds and spellings (`rule:bare-typing` gap).
    /// Joseph leans toward what the old parser already had.
    Number { spelling: String, kind: NumberKind },
    Bool(bool),
    /// Only `nil` spells it ([[rule:nil-spelling]]).
    Nil,
    /// `[a "b c" 3]` ([[rule:list-items-whitespace-separated]]).
    /// OPEN: comments or embeds as items; nesting.
    List(Vec<Value>),
    /// Unquoted material holding at least one embed
    /// ([[rule:embeds-in-text]]).
    Text(Text),
    /// `<…>` whose interior lite attaches no meaning to
    /// ([[rule:opaque-span-raw-text]]).
    ///
    /// OPEN: reopened 2026-10-20. If `<3>`, `<nil>`, `<"hi">` become values
    /// of those kinds, `Raw` keeps only interiors that match no primitive,
    /// and the matching ones carry `explicit: true` below.
    Raw { content: String },
    /// `:x |em hi` ([[rule:element-values]]).
    Element(Box<Element>),
}

pub enum StringForm {
    Bare,
    Double,
    Single,
}

/// OPEN: placeholder; the real set is `rule:bare-typing`'s to settle.
pub enum NumberKind {
    Int,
    Float,
}

/// A text: an ordered sequence of string-reducible pieces (Joseph's iolist,
/// 2026-10-20). Never promised collapsed: two adjacent `Run`s are legal,
/// and a run may end anywhere, including mid-word. Line endings are
/// characters inside runs.
pub struct Text {
    pub pieces: Vec<Piece>,
    pub meta: Meta,
}

pub enum Piece {
    Run(String),
    /// `|{…}`. OPEN: embeds are undesigned (Joseph, 2026-10-09); the
    /// interior is carried as written until they are.
    InlineElement { raw: String },
    /// `@{…}`, raw interior ([[rule:opaque-span-raw-text]]).
    Reference { raw: String },
    /// `;{…}` ([[rule:inline-comments-kept]]). Reduces to "" when the text
    /// is reduced to a string.
    InlineComment(Comment),
    // OPEN: a `;` comment *line* inside prose. [[rule:comments-in-tree]]
    // makes it a sibling `Node::Comment` that splits the text in two;
    // Joseph's 2026-10-20 remark that a «text» "explicitly allows comments
    // attached at exactly the right places" points to a `CommentLine`
    // piece here instead. Not decided.
}

/// Comment content, kept and never interpreted ([[rule:comments-in-tree]]).
/// OPEN: whether the space after `;` is content.
pub struct Comment {
    pub text: String,
    pub meta: Meta,
}

/// A fence: Joseph's 2026-10-20 lean, "element-like but with a different
/// node-type". The rest is `awaiting-implementers`
/// ([[rule:fence-opener-line]]).
pub struct Fence {
    /// The word after the backticks, a label ([[rule:fence-opener-line]]).
    pub name: Option<Name>,
    /// `$key`, `$traits` (`exact`), and whatever the handler accepts
    /// ([[rule:fence-default-handler]]).
    pub attributes: Vec<Attribute>,
    pub opener_comment: Option<Comment>,
    /// One `Run` per source line, each keeping its line ending
    /// ([[rule:fence-body-line-endings]]), dedented unless `exact`
    /// ([[rule:fence-body-dedent]]). The indentation removed from each line
    /// is in `meta` ([[rule:fence-dedent-in-meta]]).
    pub body: Text,
    pub closer_comment: Option<Comment>,
    pub meta: Meta,
}

/// Facts beside content: positions, removed indentation, blank lines at
/// edges, the opener's backtick count. OPEN: the vocabulary ([[def:meta]]),
/// and whether ornament is a layer of its own.
pub struct Meta {
    pub span: Option<Span>,
    pub entries: Vec<(String, String)>,
}

pub struct Span {
    pub start: Position,
    pub end: Position,
}

pub struct Position {
    pub line: u32,
    /// OPEN: code points, bytes or display cells after non-ASCII
    /// ([[def:column]]).
    pub column: u32,
}

pub struct Warning {
    pub code: String, // OPEN: placeholders until [[view:anomalies]]
    pub at: Position,
    pub default_on: bool, // [[rule:warnings-can-be-toggled]]
}

pub struct Error {
    pub code: String,
    pub at: Position,
}
