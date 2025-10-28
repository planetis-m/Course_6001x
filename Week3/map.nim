import std/[sequtils, syncio]

var testList = @[1, -4, 8, -9]

testList = map(testList, proc(x: int): int = abs(x))
echo testList
