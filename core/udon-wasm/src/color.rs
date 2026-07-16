//! Minimal perceptual color math for the autocolors engine.
//!
//! OKLab/OKLCH <-> sRGB (Björn Ottosson's constants) plus WCAG relative
//! luminance / contrast ratio. No dependencies; f64 throughout; all
//! functions pure so scheme generation stays bit-deterministic.
//!
//! 2011 autocolors hand-rolled Lab with a correction table around the
//! non-uniform hues (archaeology-2011/NOTES.md "Hues"); OKLCH is the
//! analytic replacement for that table.

/// A color in OKLab. `l` in [0,1]-ish, `a`/`b` roughly [-0.4, 0.4].
#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Oklab {
    pub l: f64,
    pub a: f64,
    pub b: f64,
}

impl Oklab {
    pub fn from_lch(l: f64, c: f64, h_deg: f64) -> Self {
        let h = h_deg.to_radians();
        Oklab { l, a: c * h.cos(), b: c * h.sin() }
    }
    pub fn chroma(&self) -> f64 {
        (self.a * self.a + self.b * self.b).sqrt()
    }
    pub fn hue_deg(&self) -> f64 {
        let h = self.b.atan2(self.a).to_degrees();
        if h < 0.0 { h + 360.0 } else { h }
    }
    /// Euclidean distance in OKLab (a reasonable ΔE).
    pub fn dist(&self, o: &Oklab) -> f64 {
        let (dl, da, db) = (self.l - o.l, self.a - o.a, self.b - o.b);
        (dl * dl + da * da + db * db).sqrt()
    }
}

fn srgb_to_linear(u: f64) -> f64 {
    if u <= 0.04045 { u / 12.92 } else { ((u + 0.055) / 1.055).powf(2.4) }
}
fn linear_to_srgb(u: f64) -> f64 {
    if u <= 0.0031308 { 12.92 * u } else { 1.055 * u.powf(1.0 / 2.4) - 0.055 }
}

/// sRGB components in [0,1] -> OKLab.
pub fn srgb_to_oklab(r: f64, g: f64, b: f64) -> Oklab {
    let (r, g, b) = (srgb_to_linear(r), srgb_to_linear(g), srgb_to_linear(b));
    let l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b;
    let m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b;
    let s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b;
    let (l, m, s) = (l.cbrt(), m.cbrt(), s.cbrt());
    Oklab {
        l: 0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s,
        a: 1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s,
        b: 0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s,
    }
}

/// OKLab -> linear sRGB (may be out of [0,1] gamut).
fn oklab_to_linear(c: Oklab) -> (f64, f64, f64) {
    let l_ = c.l + 0.3963377774 * c.a + 0.2158037573 * c.b;
    let m_ = c.l - 0.1055613458 * c.a - 0.0638541728 * c.b;
    let s_ = c.l - 0.0894841775 * c.a - 1.2914855480 * c.b;
    let (l, m, s) = (l_ * l_ * l_, m_ * m_ * m_, s_ * s_ * s_);
    (
        4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
        -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
        -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s,
    )
}

/// OKLab -> sRGB in [0,1], or None if out of gamut.
pub fn oklab_to_srgb(c: Oklab) -> Option<(f64, f64, f64)> {
    let (r, g, b) = oklab_to_linear(c);
    let eps = 1e-6;
    if !(-eps..=1.0 + eps).contains(&r)
        || !(-eps..=1.0 + eps).contains(&g)
        || !(-eps..=1.0 + eps).contains(&b)
    {
        return None;
    }
    Some((
        linear_to_srgb(r.clamp(0.0, 1.0)),
        linear_to_srgb(g.clamp(0.0, 1.0)),
        linear_to_srgb(b.clamp(0.0, 1.0)),
    ))
}

/// Reduce chroma (keeping l and hue) until the color fits sRGB.
pub fn fit_gamut(c: Oklab) -> Oklab {
    if oklab_to_srgb(c).is_some() {
        return c;
    }
    let (mut lo, mut hi) = (0.0_f64, 1.0_f64); // chroma scale
    for _ in 0..24 {
        let mid = (lo + hi) / 2.0;
        let t = Oklab { l: c.l, a: c.a * mid, b: c.b * mid };
        if oklab_to_srgb(t).is_some() { lo = mid } else { hi = mid }
    }
    Oklab { l: c.l, a: c.a * lo, b: c.b * lo }
}

/// WCAG relative luminance of an OKLab color (after gamut fit).
pub fn wcag_luminance(c: Oklab) -> f64 {
    let c = fit_gamut(c);
    let (r, g, b) = oklab_to_linear(c);
    0.2126 * r.clamp(0.0, 1.0) + 0.7152 * g.clamp(0.0, 1.0) + 0.0722 * b.clamp(0.0, 1.0)
}

/// WCAG contrast ratio between two colors, >= 1.0.
pub fn contrast(a: Oklab, b: Oklab) -> f64 {
    let (la, lb) = (wcag_luminance(a), wcag_luminance(b));
    let (hi, lo) = if la > lb { (la, lb) } else { (lb, la) };
    (hi + 0.05) / (lo + 0.05)
}

/// Format as a CSS `oklch()` value.
pub fn css_oklch(c: Oklab) -> String {
    format!(
        "oklch({:.2}% {:.4} {:.1})",
        c.l * 100.0,
        c.chroma(),
        c.hue_deg()
    )
}

/// Parse 0xRRGGBB into sRGB floats.
pub fn rgb_u32(v: u32) -> (f64, f64, f64) {
    (
        ((v >> 16) & 0xff) as f64 / 255.0,
        ((v >> 8) & 0xff) as f64 / 255.0,
        (v & 0xff) as f64 / 255.0,
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn roundtrip_srgb() {
        for &(r, g, b) in &[(0.0, 0.0, 0.0), (1.0, 1.0, 1.0), (0.2, 0.5, 0.8), (0.9, 0.1, 0.3)] {
            let lab = srgb_to_oklab(r, g, b);
            let (r2, g2, b2) = oklab_to_srgb(lab).expect("in gamut");
            assert!((r - r2).abs() < 1e-4 && (g - g2).abs() < 1e-4 && (b - b2).abs() < 1e-4);
        }
    }

    #[test]
    fn white_black_extremes() {
        let w = srgb_to_oklab(1.0, 1.0, 1.0);
        let k = srgb_to_oklab(0.0, 0.0, 0.0);
        assert!((w.l - 1.0).abs() < 1e-3);
        assert!(k.l.abs() < 1e-3);
        let cr = contrast(w, k);
        assert!((cr - 21.0).abs() < 0.1, "white/black contrast = {cr}");
    }

    #[test]
    fn gamut_fit_reduces_chroma_only() {
        let wild = Oklab::from_lch(0.6, 0.5, 145.0); // far out of gamut
        let fit = fit_gamut(wild);
        assert!(oklab_to_srgb(fit).is_some());
        assert!((fit.l - wild.l).abs() < 1e-9);
        assert!((fit.hue_deg() - wild.hue_deg()).abs() < 0.5);
        assert!(fit.chroma() < wild.chroma());
    }
}
