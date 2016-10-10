import unittest, reverse

template are_reversed(a, b: untyped) =
    new L = a
    deep_reverse(L)
    check L == b

suite "Reversing":
    test "sequencies":
        are_reversed(@[@[0, 1, 2], @[1, 2, 3]],
                     @[@[3, 2, 1], @[2, 1, 0]])

        are_reversed(@[@[0], @[1], @[2], @[3], @[-1]],
                     @[@[-1], @[3], @[2], @[1], @[0]])

        are_reversed(@[@[0, -1, 2, -3, 4, -5]],
                     @[@[-5, 4, -3, 2, -1, 0]])

    test "arrays":
        are_reversed([[0, 1, 2], [1, 2, 3]],
                     [[3, 2, 1], [2, 1, 0]])

        are_reversed([[0], [1], [2], [3], [-1]],
                     [[-1], [3], [2], [1], [0]])

        are_reversed([[0, -1, 2, -3, 4, -5]],
                     [[-5, 4, -3, 2, -1, 0]])
