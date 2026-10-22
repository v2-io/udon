# Hypothesis scores (0-10) for the wildcard fork; weights from CTQ-FACTORS.md. Not measured.
W = dict(A1=9,A2=10,A3=10,A4=10,A5=9,A6=9,A7=8,A8=8,A9=6,A10=5,A11=5,A12=2,
         B3=10,B4=8,B5=9,B6=7,B7=3,C1=10,C2=10,C3=9,C4=8,C5=8,C6=8,C7=8,C10=7)
S = {
 # R: <...> carries notations (unlabeled undetermined/raw, labeled <name:body>), standard set inside commits
 "R":   dict(A1=6,A2=6,A3=6,A4=7,A5=6,A6=5,A7=5,A8=5,A9=8,A10=6,A11=7,A12=7,
             B3=6,B4=7,B5=8,B6=4,B7=7,C1=7,C2=6,C3=7,C4=5,C5=5,C6=6,C7=6,C10=7),
 # W1a: notations are elements |{date ...}; <...> kept only to assert the standard set (and <> nil)
 "W1a": dict(A1=7,A2=6,A3=7,A4=6,A5=7,A6=7,A7=7,A8=7,A9=6,A10=7,A11=6,A12=6,
             B3=8,B4=7,B5=8,B6=6,B7=6,C1=6,C2=6,C3=8,C4=8,C5=7,C6=8,C7=6,C10=7),
 # W1b: notations are elements; no <...> at all (reserved)
 "W1b": dict(A1=7,A2=5,A3=7,A4=6,A5=7,A6=8,A7=8,A8=8,A9=5,A10=7,A11=6,A12=6,
             B3=8,B4=4,B5=8,B6=8,B7=5,C1=5,C2=6,C3=8,C4=8,C5=7,C6=8,C7=6,C10=7),
}
tot = sum(W.values())
for k,s in S.items():
    print(k, round(sum(W[f]*s[f] for f in W)/tot,2))
