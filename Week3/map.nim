import sequtils

var testList = @[1, -4, 8, -9]

proc absoluteInt(x: int): int =
    if x < 0: -x else: x

proc applyToEach(L: var seq[int], f: proc(x: int): int) =
    for i in 0 .. high(L):
        L[i] = f(L[i])

applyToEach(testList, absoluteInt)
echo testList
