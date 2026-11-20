//! The role tree: fine-grained token roles with *structural kinship*.
//!
//! Joseph's ruling #2 (2026-07-16): "the works" — not ~15 flat buckets but a
//! tree where a child role's color is *derived from its parent's* with a
//! mild, controlled divergence. North star: in `|element[123]`, a brighter
//! `element` name wants a *dull* same-hue `|` sigil and a different-shade-of-
//! dull pair of brackets. This file is the modern `mapping.udon`
//! (archaeology-2011): each entry states its *relationship* to its parent
//! (kinship primes, dullness, emphasis tier), never its color.
//!
//! Role indices are the wire format of `udon_highlight` (u8 per byte run) and
//! the index into the generated theme CSS. Names become CSS classes
//! (`.udon-hl-<name>`). Append-only where possible; the Obsidian plugin reads
//! the name table from the wasm module, so reordering is safe for the plugin
//! but changes historical scheme colors (kinship draws are per-role in table
//! order) — prefer appending.

/// Where a role's hue comes from.
#[derive(Clone, Copy, Debug)]
pub enum Hue {
    /// One of the scheme's base hue groups (jittered-even spread).
    Group(u8),
    /// Parent's hue, diverged by `primes` steps (2011 `'` marks): mild,
    /// proximate distinctions — the headline feature.
    Kin { primes: u8 },
    /// Neutral: hue follows the theme foreground, chroma near zero.
    Neutral,
}

/// Emphasis tier — the information budget. Each tier is a WCAG-contrast band
/// against the actual theme background; STRUCTURE deliberately *recedes*.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Tier {
    /// Prose and warnings: fully readable, near theme-fg contrast.
    Prose,
    /// Discriminators (element names): the brightest colored things.
    Name,
    /// Values / keys: readable, a step below names.
    Value,
    /// Plumbing (sigils, brackets, quotes): dull kin of their owners.
    Structure,
    /// Comments: legible but receding, italic.
    Comment,
}

impl Tier {
    /// (min, target, max) WCAG contrast ratio vs. the theme background.
    /// Structure's *max* is the load-bearing constraint: schemes where
    /// nothing recedes have failed (the whole 2011 thesis).
    pub fn band(self) -> (f64, f64, f64) {
        match self {
            Tier::Prose => (5.5, 8.5, 21.0),
            Tier::Name => (4.8, 6.8, 15.0),
            Tier::Value => (4.0, 5.6, 12.0),
            Tier::Structure => (1.8, 2.9, 4.4),
            Tier::Comment => (2.4, 3.6, 5.2),
        }
    }
}

pub const STYLE_ITALIC: u8 = 1;
pub const STYLE_BOLD: u8 = 2;
pub const STYLE_UNDERLINE: u8 = 4;

pub struct Role {
    /// CSS class suffix (`.udon-hl-<name>`); kebab-case.
    pub name: &'static str,
    /// Index of parent role (== own index for family roots).
    pub parent: u8,
    pub hue: Hue,
    /// Chroma multiplier vs. parent (roots: vs. family base). Dull kin < 1.
    pub chroma_mul: f64,
    pub tier: Tier,
    /// Multiplier on the tier's target contrast: how sibling kin get their
    /// *different shade* of the same dull hue (north star: `|` vs `[…]`).
    pub contrast_bias: f64,
    pub style: u8,
}

const fn role(
    name: &'static str,
    parent: u8,
    hue: Hue,
    chroma_mul: f64,
    tier: Tier,
    style: u8,
) -> Role {
    Role { name, parent, hue, chroma_mul, tier, contrast_bias: 1.0, style }
}

const fn shade(
    name: &'static str,
    parent: u8,
    hue: Hue,
    chroma_mul: f64,
    tier: Tier,
    contrast_bias: f64,
    style: u8,
) -> Role {
    Role { name, parent, hue, chroma_mul, tier, contrast_bias, style }
}

// Base hue groups (index for Hue::Group). One per semantic family so
// families are maximally separated while kin stay close.
pub const G_ELEMENT: u8 = 0;
pub const G_ATTR: u8 = 1;
pub const G_STRING: u8 = 2;
pub const G_NUMBER: u8 = 3;
pub const G_BOOL: u8 = 4;
pub const G_DYNAMIC: u8 = 5;
pub const G_REFERENCE: u8 = 6;
pub const G_COMMENT: u8 = 7;
pub const G_TYPE: u8 = 8;
pub const HUE_GROUPS: usize = 9;

// Role indices (wire format).
pub const R_DIM: u8 = 0;
pub const R_ELEMENT_NAME: u8 = 1;
pub const R_ELEMENT_SIGIL: u8 = 2;
pub const R_INLINE_SIGIL: u8 = 3;
pub const R_INLINE_CLOSE: u8 = 4;
pub const R_ID_BRACKET: u8 = 5;
pub const R_ID_KEY: u8 = 6;
pub const R_ID_KEY_DOLLAR: u8 = 7;
pub const R_TRAIT_DOT: u8 = 8;
pub const R_TRAIT_NAME: u8 = 9;
pub const R_ATTR_KEY: u8 = 10;
pub const R_ATTR_SIGIL: u8 = 11;
pub const R_ATTR_FLAG: u8 = 12;
pub const R_STRING: u8 = 13;
pub const R_STRING_QUOTE: u8 = 14;
pub const R_ESCAPE: u8 = 15;
pub const R_VALUE_BARE: u8 = 16;
pub const R_NUMBER: u8 = 17;
pub const R_BOOL: u8 = 18;
pub const R_NIL: u8 = 19;
pub const R_TYPE_ANGLE: u8 = 20;
pub const R_TEXT: u8 = 21;
pub const R_COMMENT: u8 = 22;
pub const R_COMMENT_SIGIL: u8 = 23;
pub const R_DYNAMIC: u8 = 24;
pub const R_DYNAMIC_SIGIL: u8 = 25;
pub const R_INTERPOLATION: u8 = 26;
pub const R_RAW_CONTENT: u8 = 27;
pub const R_REFERENCE: u8 = 28;
pub const R_REFERENCE_SIGIL: u8 = 29;
pub const R_ARRAY_BRACKET: u8 = 30;
pub const R_WARNING: u8 = 31;

/// The tree. Parents must precede children (resolution is one forward pass).
pub const ROLES: &[Role] = &[
    // 0: the residue — indentation and anything unclassified. Recedes hard.
    role("dim", 0, Hue::Neutral, 1.0, Tier::Structure, 0),
    // element family: |name[ids].traits and |{inline …}
    role("element-name", 1, Hue::Group(G_ELEMENT), 1.0, Tier::Name, STYLE_BOLD),
    role("element-sigil", 1, Hue::Kin { primes: 0 }, 0.55, Tier::Structure, 0),
    shade("inline-sigil", 2, Hue::Kin { primes: 1 }, 0.9, Tier::Structure, 1.15, 0),
    role("inline-close", 3, Hue::Kin { primes: 0 }, 1.0, Tier::Structure, 0),
    shade("id-bracket", 2, Hue::Kin { primes: 1 }, 0.85, Tier::Structure, 1.3, 0),
    role("id-key", 1, Hue::Kin { primes: 1 }, 0.9, Tier::Value, 0),
    role("id-key-dollar", 6, Hue::Kin { primes: 1 }, 1.0, Tier::Value, STYLE_UNDERLINE),
    shade("trait-dot", 2, Hue::Kin { primes: 2 }, 0.9, Tier::Structure, 0.85, 0),
    role("trait-name", 1, Hue::Kin { primes: 2 }, 0.85, Tier::Value, STYLE_ITALIC),
    // attribute family: :key value / :flag?
    role("attr-key", 10, Hue::Group(G_ATTR), 1.0, Tier::Value, 0),
    role("attr-sigil", 10, Hue::Kin { primes: 0 }, 0.55, Tier::Structure, 0),
    role("attr-flag", 10, Hue::Kin { primes: 1 }, 1.1, Tier::Value, STYLE_BOLD),
    // string / scalar values
    role("string", 13, Hue::Group(G_STRING), 1.0, Tier::Value, 0),
    shade("string-quote", 13, Hue::Kin { primes: 0 }, 0.5, Tier::Structure, 0.9, 0),
    role("escape", 13, Hue::Kin { primes: 2 }, 1.15, Tier::Value, STYLE_UNDERLINE),
    role("value-bare", 13, Hue::Kin { primes: 1 }, 0.85, Tier::Value, 0),
    role("number", 17, Hue::Group(G_NUMBER), 1.0, Tier::Value, 0),
    role("bool", 18, Hue::Group(G_BOOL), 1.0, Tier::Value, 0),
    role("nil", 18, Hue::Kin { primes: 1 }, 0.8, Tier::Value, STYLE_ITALIC),
    role("type-angle", 20, Hue::Group(G_TYPE), 0.9, Tier::Value, 0),
    // prose: the theme's own voice, barely tinted
    role("text", 21, Hue::Neutral, 1.0, Tier::Prose, 0),
    // comments recede, italic
    role("comment", 22, Hue::Group(G_COMMENT), 0.5, Tier::Comment, STYLE_ITALIC),
    role("comment-sigil", 22, Hue::Kin { primes: 0 }, 0.6, Tier::Structure, STYLE_ITALIC),
    // dynamics: !directives, !{{interpolation}}, freeform/raw
    role("dynamic", 24, Hue::Group(G_DYNAMIC), 1.0, Tier::Value, 0),
    role("dynamic-sigil", 24, Hue::Kin { primes: 0 }, 0.55, Tier::Structure, 0),
    role("interpolation", 24, Hue::Kin { primes: 1 }, 1.1, Tier::Value, 0),
    role("raw-content", 24, Hue::Kin { primes: 2 }, 0.45, Tier::Value, 0),
    // references: @spdx[MIT]
    role("reference", 28, Hue::Group(G_REFERENCE), 1.0, Tier::Value, STYLE_UNDERLINE),
    role("reference-sigil", 28, Hue::Kin { primes: 0 }, 0.55, Tier::Structure, 0),
    // arrays
    shade("array-bracket", 13, Hue::Kin { primes: 2 }, 0.5, Tier::Structure, 1.15, 0),
    // warnings: background wash, fixed red family (see scheme.rs)
    role("warning", 31, Hue::Neutral, 1.0, Tier::Prose, 0),
];

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn tree_integrity() {
        assert!(ROLES.len() <= 256);
        for (i, r) in ROLES.iter().enumerate() {
            assert!(
                (r.parent as usize) <= i,
                "role {} parent must precede it",
                r.name
            );
            assert!(r.name.bytes().all(|b| b.is_ascii_lowercase() || b == b'-'));
        }
        // Named indices match table order.
        assert_eq!(ROLES[R_ELEMENT_NAME as usize].name, "element-name");
        assert_eq!(ROLES[R_WARNING as usize].name, "warning");
        assert_eq!(ROLES[R_ARRAY_BRACKET as usize].name, "array-bracket");
        assert_eq!(ROLES[R_TEXT as usize].name, "text");
    }
}
