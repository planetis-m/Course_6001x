import future, sequtils

var testList = @[1, -4, 8, -9]

proc absoluteInt(x: int): int =
    if x < 0: -x else: x

testList = map(testList, (x: int) => absoluteInt(x))
echo testList
