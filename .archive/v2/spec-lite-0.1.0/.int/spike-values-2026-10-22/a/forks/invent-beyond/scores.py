"""Differential scores for the invent-beyond fork: each invention's change (-2..+2) per
CTQ factor relative to the parent's lead composition (Cc + closed <...> + <name: body>),
weighted by CTQ-FACTORS.md. Hypotheses, not measurements; factors not listed are 0.
Beauty (group A) is shown first and separately, as the coordinator's note asks."""
W = dict(A1=9,A2=10,A3=10,A4=10,A5=9,A6=9,A7=8,A8=8,A9=6,A10=5,A11=5,A12=2,
         B3=10,B4=8,B5=9,B6=7,B7=3,C1=10,C2=10,C3=9,C4=8,C5=8,C6=8,C7=8,C8=8,C9=7,C10=7)
D = {
 "I1 reading after the value": dict(A1=1,A2=1,A3=1,A5=1,A6=1,B3=-1,C4=1),
 "I2 gloss tier":              dict(A1=1,A2=-2,A3=1,A4=-1,A5=2,A6=-1,A7=-1,A8=-1,A9=-1,B4=1,B6=-1,C3=1,C10=-1),
 "I3 legend (alone)":dict(A1=1,A3=1,A5=2,A10=1,B3=-0.5,C5=2,C9=1),
 "I4a numero sign":            dict(A1=0.5,A2=-1,A3=1,A5=1,A8=-1),
 "I4b number-system letters":  dict(A1=1,A2=-1,A3=1,A8=-2,A12=-1,B4=1),
 "I4b empty set as nil":       dict(A1=1,A3=1,A8=-0.5),
}
for name, d in D.items():
    a = sum(W[k]*v for k,v in d.items() if k.startswith("A"))
    t = sum(W[k]*v for k,v in d.items())
    print(f"{name:30s} beauty(A) {a:+6.1f}   all {t:+6.1f}")
