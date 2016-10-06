proc dotProduct(listA, listB: openarray[int]): int =
    #
    # listA: a list of numbers
    # listB: a list of numbers of the same length as listA
    #
    result = 0
    let
        m = len(listA)
    for i in 0 .. <m:
        result += listA[i] * listB[i]

let
    listA = [1, 2, 3]
    listB = [4, 5, 6]

echo dotProduct(listA, listB)
