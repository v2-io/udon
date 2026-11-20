//! The autocolors scheme generator: 2011's generative model, modern math.
//!
//! Structure (proven by years of use — archaeology-2011/colorscheme.rb):
//!   1. Three seeded personality parameters: contrast, chromaticity,
//!      colorfulness.
//!   2. A base-hue spread: jittered-even hues, shuffled, one per family.
//!   3. Kinship derivation: a child role's color is its parent's, diverged
//!      mildly (hue step per prime, chroma dulling) — the north-star feature.
//!   4. Constraints, not aspirations (fitness.md):
//!      - contrast-vs-ideal: every role's lightness is *solved* so its WCAG
//!        contrast against the actual theme background lands in its tier
//!        band (structure recedes by construction: its band has a low max);
//!      - parent-similarity: bounded hue divergence + shared chroma lineage;
//!      - sibling-difference: a repair pass pushes too-close siblings apart.
//!   5. Anchoring: the theme's real background/foreground are inputs, so a
//!      scheme is native in any Obsidian theme, light or dark.
//!
//! Determinism: seeded from the scheme *name* (rng.rs, pinned) and all draws
//! happen in fixed order (personality, hues, then one draw pair per role in
//! table order). Same name + same anchors => identical CSS, forever.

use crate::color::{self, Oklab};
use crate::rng::Rng;
use crate::roles::{self, Hue, ROLES};

pub struct Scheme {
    /// One resolved fg color per role, role-table order.
    pub colors: Vec<Oklab>,
    pub bg: Oklab,
    pub fg: Oklab,
}

/// Solve for the lightness at which `oklch(l, c, h)` hits `target` WCAG
/// contrast against `bg`, searching away from the background's lightness.
/// Monotone in the search direction, so bisection converges.
fn solve_lightness(bg: Oklab, chroma: f64, hue: f64, target: f64, lighter: bool) -> Oklab {
    let extreme = if lighter { 1.0 } else { 0.0 };
    let mk = |l: f64| color::fit_gamut(Oklab::from_lch(l, chroma, hue));
    // If even the extreme can't reach the target, take the extreme.
    if color::contrast(mk(extreme), bg) < target {
        return mk(extreme);
    }
    let (mut lo, mut hi) = (bg.l, extreme);
    for _ in 0..28 {
        let mid = (lo + hi) / 2.0;
        if color::contrast(mk(mid), bg) < target { lo = mid } else { hi = mid }
    }
    mk(hi)
}

fn wrap_hue(h: f64) -> f64 {
    h.rem_euclid(360.0)
}

pub fn generate(name: &str, bg: Oklab, fg: Oklab) -> Scheme {
    let mut rng = Rng::from_name(name);
    let lighter = fg.l > bg.l; // dark theme => content is lighter than bg

    // --- personality (2011 ranges, lightly retuned) --------------------
    // contrast: scales every tier's target ratio (1.0 = the tier tables).
    let p_contrast = rng.nrand(0.97, 0.07, 0.82, 1.12);
    // chromaticity: global colorfulness-of-each-color.
    let p_chroma = rng.nrand(0.78, 0.22, 0.40, 1.10);
    // colorfulness: how far kin may wander from their parents.
    let p_colorful = rng.nrand(0.75, 0.20, 0.45, 1.05);

    // --- base hues: jittered-even spread, shuffled ----------------------
    let n = roles::HUE_GROUPS;
    let start = rng.range(0.0, 360.0);
    let step = 360.0 / n as f64;
    let mut hues: Vec<f64> = (0..n)
        .map(|i| {
            let jitter = rng.nrand(0.0, step * 0.16, -step * 0.4, step * 0.4);
            wrap_hue(start + i as f64 * step + jitter)
        })
        .collect();
    rng.shuffle(&mut hues);

    // Family base chroma: content families vivid-ish, comments muted.
    let base_chroma: Vec<f64> = (0..n)
        .map(|_| (0.075 + 0.055 * rng.f64()) * p_chroma)
        .collect();

    // --- resolve roles (parents first; one fwd pass) --------------------
    // Per-role deterministic draws happen for EVERY role in table order so
    // adding constraints never shifts later roles' randomness.
    let mut colors: Vec<Oklab> = Vec::with_capacity(ROLES.len());
    let mut hue_of: Vec<f64> = Vec::with_capacity(ROLES.len());
    let mut chroma_of: Vec<f64> = Vec::with_capacity(ROLES.len());

    for (i, r) in ROLES.iter().enumerate() {
        let dir = rng.sign();
        let jitter = rng.f64();
        let (hue, chroma) = match r.hue {
            Hue::Group(g) => (hues[g as usize], base_chroma[g as usize] * r.chroma_mul),
            Hue::Kin { primes } => {
                let ph = hue_of[r.parent as usize];
                let pc = chroma_of[r.parent as usize];
                // Mild proximate distinction: 8–20 degrees per prime,
                // scaled by colorfulness. primes==0 => same hue, dull.
                let step = (8.0 + 12.0 * jitter) * p_colorful;
                (wrap_hue(ph + dir * step * primes as f64), pc * r.chroma_mul)
            }
            Hue::Neutral => (fg.hue_deg(), (0.012 * r.chroma_mul).min(0.02)),
        };
        let (min_c, target, max_c) = r.tier.band();
        let want =
            (1.0 + (target * r.contrast_bias - 1.0) * p_contrast).clamp(min_c, max_c);
        let mut c = solve_lightness(bg, chroma, hue, want, lighter);
        // Hard floor: never below the tier minimum (legibility), never above
        // its max (structure must recede) when the max is reachable.
        let cr = color::contrast(c, bg);
        if cr > max_c {
            c = solve_lightness(bg, chroma, hue, max_c, lighter);
        }
        hue_of.push(hue);
        chroma_of.push(c.chroma().max(chroma)); // lineage keeps intended chroma
        colors.push(c);
        debug_assert!(i == colors.len() - 1);
    }

    // Prose reads in the theme's own voice: exactly the theme foreground,
    // with the tiny tint already applied via Neutral hue if fg is achromatic.
    colors[roles::R_TEXT as usize] = fg;

    // --- sibling-difference repair (fitness criterion 2) ----------------
    // Children of the same parent that landed too close get pushed apart by
    // an extra hue step. Deterministic order; second sibling moves.
    for i in 0..ROLES.len() {
        for j in (i + 1)..ROLES.len() {
            if ROLES[j].parent != ROLES[i].parent || i == ROLES[i].parent as usize {
                continue;
            }
            let same_style = ROLES[i].style == ROLES[j].style;
            let too_close = colors[i].dist(&colors[j]) < 0.045;
            if same_style && too_close && ROLES[i].tier == ROLES[j].tier {
                let hue = wrap_hue(hue_of[j] + 16.0 * p_colorful);
                let (min_c, target, max_c) = ROLES[j].tier.band();
                let want = (1.0 + (target * ROLES[j].contrast_bias - 1.0) * p_contrast)
                    .clamp(min_c, max_c);
                colors[j] = solve_lightness(bg, chroma_of[j], hue, want, lighter);
                hue_of[j] = hue;
            }
        }
    }

    Scheme { colors, bg, fg }
}

/// Emit the scheme as CSS rules over the `.udon-hl-<role>` classes.
pub fn css(name: &str, bg: Oklab, fg: Oklab) -> String {
    let s = generate(name, bg, fg);
    let mut out = String::with_capacity(4096);
    out.push_str(&format!(
        "/* autocolors scheme \"{}\" — generated, deterministic (name = seed) */\n",
        name.replace('*', "").replace('/', "")
    ));
    for (i, r) in ROLES.iter().enumerate() {
        let c = s.colors[i];
        out.push_str(&format!(".udon-hl-{} {{ ", r.name));
        if i == roles::R_WARNING as usize {
            // Warnings must read as warnings in every scheme: a stable
            // red-family background wash, fg left to the underlying role.
            let wash = color::fit_gamut(Oklab::from_lch(
                if fg.l > bg.l { 0.45 } else { 0.72 },
                0.09,
                25.0,
            ));
            let (rr, gg, bb) = color::oklab_to_srgb(wash).unwrap_or((0.8, 0.2, 0.2));
            out.push_str(&format!(
                "background: rgba({}, {}, {}, 0.22); ",
                (rr * 255.0) as u8,
                (gg * 255.0) as u8,
                (bb * 255.0) as u8
            ));
        } else {
            out.push_str(&format!("color: {}; ", color::css_oklch(c)));
        }
        if r.style & roles::STYLE_ITALIC != 0 {
            out.push_str("font-style: italic; ");
        }
        if r.style & roles::STYLE_BOLD != 0 {
            out.push_str("font-weight: 600; ");
        }
        if r.style & roles::STYLE_UNDERLINE != 0 {
            out.push_str("text-decoration: underline; text-underline-offset: 2px; ");
        }
        out.push_str("}\n");
    }
    out
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::color::{contrast, srgb_to_oklab};

    fn dark_bg() -> Oklab {
        srgb_to_oklab(0.117, 0.117, 0.117) // #1e1e1e
    }
    fn dark_fg() -> Oklab {
        srgb_to_oklab(0.855, 0.855, 0.855) // #dadada
    }
    fn light_bg() -> Oklab {
        srgb_to_oklab(1.0, 1.0, 1.0)
    }
    fn light_fg() -> Oklab {
        srgb_to_oklab(0.13, 0.13, 0.13)
    }

    #[test]
    fn deterministic_name_is_seed() {
        let a = css("tony-the-tiger", dark_bg(), dark_fg());
        let b = css("tony-the-tiger", dark_bg(), dark_fg());
        assert_eq!(a, b);
        let c = css("muahaha", dark_bg(), dark_fg());
        assert_ne!(a, c);
    }

    /// The constraints are real, not aspirational: check tier contrast
    /// bands hold for many seeds on both a dark and a light anchor.
    #[test]
    fn contrast_bands_hold() {
        for seed in ["tony-the-tiger", "muahaha", "a", "zebra-42", "udon", "x9"] {
            for (bg, fg) in [(dark_bg(), dark_fg()), (light_bg(), light_fg())] {
                let s = generate(seed, bg, fg);
                for (i, r) in ROLES.iter().enumerate() {
                    if i == roles::R_WARNING as usize {
                        continue; // background wash, not a fg color
                    }
                    let cr = contrast(s.colors[i], bg);
                    let (min_c, _, max_c) = r.tier.band();
                    assert!(
                        cr >= min_c - 0.15 && cr <= max_c + 0.15,
                        "{seed}: role {} contrast {cr:.2} outside [{min_c},{max_c}]",
                        r.name
                    );
                }
            }
        }
    }

    /// Structure recedes relative to its owner: sigils must have strictly
    /// lower contrast than the names they serve (the livability property).
    #[test]
    fn sigils_recede_and_stay_kin() {
        for seed in ["tony-the-tiger", "muahaha", "udon"] {
            let s = generate(seed, dark_bg(), dark_fg());
            let pairs = [
                (roles::R_ELEMENT_SIGIL, roles::R_ELEMENT_NAME),
                (roles::R_ATTR_SIGIL, roles::R_ATTR_KEY),
                (roles::R_STRING_QUOTE, roles::R_STRING),
                (roles::R_DYNAMIC_SIGIL, roles::R_DYNAMIC),
                (roles::R_REFERENCE_SIGIL, roles::R_REFERENCE),
            ];
            for (sig, owner) in pairs {
                let cs = contrast(s.colors[sig as usize], s.bg);
                let co = contrast(s.colors[owner as usize], s.bg);
                assert!(cs < co, "{seed}: {} not receding vs {}", sig, owner);
                // Kinship: same hue lineage (primes==0 kin share the hue).
                let dh = (s.colors[sig as usize].hue_deg()
                    - s.colors[owner as usize].hue_deg())
                .abs();
                let dh = dh.min(360.0 - dh);
                assert!(
                    dh < 30.0,
                    "{seed}: sigil {} hue {dh:.0}deg from owner — not kin",
                    sig
                );
            }
        }
    }

    /// North star: |element[123] — name bright, sigil dull same-hue,
    /// brackets a *different* dull shade (distinct from the sigil).
    #[test]
    fn north_star_bracket_shading() {
        for seed in ["tony-the-tiger", "muahaha", "udon", "zebra-42"] {
            let s = generate(seed, dark_bg(), dark_fg());
            let sigil = s.colors[roles::R_ELEMENT_SIGIL as usize];
            let bracket = s.colors[roles::R_ID_BRACKET as usize];
            assert!(
                sigil.dist(&bracket) > 0.015,
                "{seed}: bracket indistinguishable from sigil"
            );
            let dh = (sigil.hue_deg() - bracket.hue_deg()).abs();
            assert!(dh.min(360.0 - dh) < 45.0, "{seed}: bracket not kin to sigil");
        }
    }

    #[test]
    fn css_emits_all_roles() {
        let out = css("tony-the-tiger", dark_bg(), dark_fg());
        for r in ROLES {
            assert!(out.contains(&format!(".udon-hl-{} ", r.name)), "missing {}", r.name);
        }
        assert!(out.contains("background: rgba(")); // warning wash
        assert!(out.contains("text-decoration: underline")); // $-keys etc.
    }
}
