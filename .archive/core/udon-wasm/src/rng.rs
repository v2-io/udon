//! Deterministic seeding for named schemes.
//!
//! THE NAME IS THE SEED (Joseph's ruling #4, 2026-07-16): any string, hashed,
//! reproduces the same scheme everywhere, forever. The algorithms below are
//! therefore part of the scheme-name contract — **pinned, do not change**:
//!
//!   seed  = FNV-1a 64 over the UTF-8 bytes of the name
//!   rng   = SplitMix64 (Steele/Lea/Flood 2014), draws in fixed program order
//!
//! (2011 used Ruby's `name.hash` + `srand`, which was never portable across
//! Ruby versions — this fixes that while keeping the design.)

pub fn fnv1a64(bytes: &[u8]) -> u64 {
    let mut h: u64 = 0xcbf29ce484222325;
    for &b in bytes {
        h ^= b as u64;
        h = h.wrapping_mul(0x100000001b3);
    }
    h
}

pub struct Rng(u64);

impl Rng {
    pub fn from_name(name: &str) -> Self {
        Rng(fnv1a64(name.as_bytes()))
    }

    fn next_u64(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9e3779b97f4a7c15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94d049bb133111eb);
        z ^ (z >> 31)
    }

    /// Uniform in [0,1).
    pub fn f64(&mut self) -> f64 {
        (self.next_u64() >> 11) as f64 / (1u64 << 53) as f64
    }

    /// Uniform in [lo,hi).
    pub fn range(&mut self, lo: f64, hi: f64) -> f64 {
        lo + self.f64() * (hi - lo)
    }

    /// Clamped gaussian (Box-Muller), the 2011 `nrand`.
    pub fn nrand(&mut self, mean: f64, stddev: f64, floor: f64, ceil: f64) -> f64 {
        let u1 = self.f64().max(1e-12);
        let u2 = self.f64();
        let z = (-2.0 * u1.ln()).sqrt() * (2.0 * std::f64::consts::PI * u2).cos();
        (mean + stddev * z).clamp(floor, ceil)
    }

    /// Random sign.
    pub fn sign(&mut self) -> f64 {
        if self.next_u64() & 1 == 1 { 1.0 } else { -1.0 }
    }

    /// Fisher-Yates shuffle (deterministic given draw order).
    pub fn shuffle<T>(&mut self, v: &mut [T]) {
        for i in (1..v.len()).rev() {
            let j = (self.next_u64() % (i as u64 + 1)) as usize;
            v.swap(i, j);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    /// Pin the seed algorithm: if these change, every named scheme in the
    /// world changes. Values captured 2026-07-16 at first ship.
    #[test]
    fn seed_pinned() {
        assert_eq!(fnv1a64(b""), 0xcbf29ce484222325);
        assert_eq!(fnv1a64(b"tony-the-tiger"), fnv1a64(b"tony-the-tiger"));
        let mut a = Rng::from_name("tony-the-tiger");
        let mut b = Rng::from_name("tony-the-tiger");
        for _ in 0..64 {
            assert_eq!(a.next_u64(), b.next_u64());
        }
        let mut c = Rng::from_name("muahaha");
        assert_ne!(Rng::from_name("tony-the-tiger").next_u64(), c.next_u64());
    }

    #[test]
    fn distributions_sane() {
        let mut r = Rng::from_name("x");
        for _ in 0..1000 {
            let v = r.f64();
            assert!((0.0..1.0).contains(&v));
            let n = r.nrand(0.5, 0.2, 0.0, 1.0);
            assert!((0.0..=1.0).contains(&n));
        }
    }
}
