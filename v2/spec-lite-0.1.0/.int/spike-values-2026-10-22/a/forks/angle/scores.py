# Hypothesis scores (0-10) for the <...> branches, by the fork agent's judgment.
# Only factors that discriminate between branches are listed; the rest are equal and omitted.
W = dict(A1=9,A2=10,A3=10,A4=10,A5=9,A6=9,A7=8,A8=8,A9=6,A10=5,A11=5,
         B3=10,B4=8,B6=7,C1=10,C2=10,C4=8,C5=8,C6=8,C7=8)
S = {
 #            A1 A2 A3 A4 A5 A6 A7 A8 A9 A10 A11 B3 B4 B6 C1s C1c C2 C4 C5 C6 C7
 'ANG-1 raw box':                [5,5,5,7,6,8,9,7,7,5,6, 8,4,9, 2,8, 5,5,5,6,6],
 'ANG-2 std else raw':           [5,6,6,7,6,5,5,7,7,4,6, 6,4,6, 8,8, 5,5,5,5,5],
 'ANG-3 closed, no notations':   [6,6,7,8,5,7,7,7,7,3,6, 9,8,8, 8,8, 7,3,5,3,8],
 'ANG-4o value fence, open':     [7,6,6,7,7,7,6,6,6,8,7, 7,5,5, 8,8, 5,9,7,9,7],
 'ANG-4c value fence, closed':   [8,7,7,8,7,7,6,6,6,8,7, 9,9,7, 8,8, 7,9,7,9,8],
 'ANG-5 embed as notation':      [4,5,6,5,4,5,7,9,4,7,4, 6,5,10,2,8, 8,7,5,7,5],
}
keys = ['A1','A2','A3','A4','A5','A6','A7','A8','A9','A10','A11','B3','B4','B6','C1s','C1c','C2','C4','C5','C6','C7']
for name, v in S.items():
    d = dict(zip(keys, v))
    tot = {}
    for world in ('s','c'):
        t = 0
        for k, w in W.items():
            t += w * (d['C1'+world] if k == 'C1' else d[k])
        tot[world] = t
    print(f"{name:30s} strict-bare: {tot['s']:4d}   classified-bare: {tot['c']:4d}")
print("max possible:", 10*sum(W.values()))
