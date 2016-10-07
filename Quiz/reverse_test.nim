import unittest, reverse

template avoid_typing(a, b: untyped) =
    var L = a
    deep_reverse(L)
    check L == b

suite "Reversing":
    test "sequencies":
        avoid_typing(@[@[0, 1, 2], @[1, 2, 3]], 
                     @[@[3, 2, 1], @[2, 1, 0]])

        avoid_typing(@[@[0], @[1], @[2], @[3], @[-1]],
                     @[@[-1], @[3], @[2], @[1], @[0]])

        avoid_typing(@[@[0, -1, 2, -3, 4, -5]], 
                     @[@[-5, 4, -3, 2, -1, 0]])

    test "arrays":
        avoid_typing([[0, 1, 2], [1, 2, 3]], 
                     [[3, 2, 1], [2, 1, 0]])

        avoid_typing([[0], [1], [2], [3], [-1]],
                     [[-1], [3], [2], [1], [0]])

        avoid_typing([[0, -1, 2, -3, 4, -5]], 
                     [[-5, 4, -3, 2, -1, 0]])
