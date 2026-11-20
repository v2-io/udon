# Scores are this fork's hypotheses (basis and confidence on the branch pages), not measurements.
W = dict(A1=9,A2=10,A3=10,A5=9,A6=9,A7=8,A9=6,B3=10,B4=8,B5=9,B6=7,C1=10,C5=8,C7=8,C10=7)
S = {
 "C0 bare is text, no reading":            dict(A1=5,A2=3,A3=6,A5=4,A6=8,A7=9,A9=4,B3=9,B4=5,B5=9,B6=8,C1=3,C5=8,C7=7,C10=9),
 "C-view default left open (as carded)":  dict(A1=6,A2=5,A3=6,A5=7,A6=5,A7=8,A9=8,B3=5,B4=6,B5=9,B6=8,C1=6,C5=8,C7=4,C10=9),
 "C-class: text + normative class (S-JSON)": dict(A1=8,A2=8,A3=8,A5=9,A6=7,A7=7,A9=9,B3=9,B4=7,B5=8,B6=8,C1=9,C5=9,C7=8,C10=9),
 "B: class is the kind (S-JSON)":          dict(A1=7,A2=8,A3=6,A5=9,A6=7,A7=7,A9=9,B3=8,B4=7,B5=8,B6=5,C1=9,C5=7,C7=7,C10=8),
 "B-old: kind-first, old line's set":      dict(A1=5,A2=5,A3=4,A5=9,A6=3,A7=3,A9=9,B3=4,B4=5,B5=7,B6=3,C1=9,C5=6,C7=5,C10=8),
}
tot = sum(W.values())
for k,v in S.items():
    print(f"{sum(W[f]*v[f] for f in W)/tot:5.2f}  {k}")
print("weights used:", W, "sum", tot)
