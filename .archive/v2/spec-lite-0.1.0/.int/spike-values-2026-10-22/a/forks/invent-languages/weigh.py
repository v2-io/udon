# Hypothesis scores (0-10) on the factors where the notation designs differ; weights from CTQ-FACTORS.md.
# Factors where they don't differ are left out (they add the same to every row).
W = {"A1":9,"A2":10,"A3":10,"A4":10,"A5":9,"A6":9,"A7":8,"A8":8,"A9":6,
     "B3":10,"B4":8,"B6":7,"C3":9,"C4":8,"C8":8}
S = {
 "ANG-4c <date: …>":        dict(A1=6,A2=5,A3=7,A4=7,A5=7,A6=6,A7=6,A8=6,A9=6,B3=8,B4=9,B6=5,C3=8,C4=8,C8=6),
 "N1 date`…`":              dict(A1=9,A2=7,A3=8,A4=7,A5=7,A6=8,A7=8,A8=9,A9=8,B3=8,B4=6,B6=9,C3=7,C4=8,C8=9),
 "N1 + closed <…> (ANG-3)": dict(A1=8,A2=7,A3=8,A4=7,A5=7,A6=7,A7=7,A8=7,A9=8,B3=8,B4=9,B6=6,C3=7,C4=8,C8=9),
 "N2 date\"…\" / rgb[…]":   dict(A1=7,A2=8,A3=8,A4=6,A5=7,A6=7,A7=7,A8=7,A9=8,B3=7,B4=6,B6=7,C3=8,C4=7,C8=6),
 "N1 + N2[…]":              dict(A1=8,A2=7,A3=8,A4=7,A5=8,A6=7,A7=7,A8=8,A9=8,B3=8,B4=6,B6=8,C3=7,C4=9,C8=9),
 "N3 2026-07-21<date>":     dict(A1=6,A2=4,A3=6,A4=5,A5=8,A6=5,A7=5,A8=5,A9=7,B3=6,B4=5,B6=4,C3=7,C4=6,C8=4),
}
tot=sum(W.values())
rows=sorted(((sum(W[f]*v for f,v in s.items())/tot,n) for n,s in S.items()),reverse=True)
for sc,n in rows: print(f"{sc:5.2f}  {n}")
beauty=[f for f in W if f.startswith("A")]
print("\nBeauty group only (A1-A9):")
bt=sum(W[f] for f in beauty)
for sc,n in sorted(((sum(W[f]*S[n][f] for f in beauty)/bt,n) for n in S),reverse=True): print(f"{sc:5.2f}  {n}")
