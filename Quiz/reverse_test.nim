import unittest, reverse

suite "Reversing":
    test "sequencies":
        var M = @[@[0, 1, 2], @[1, 2, 3]]
        var N = @[@[0], @[1], @[2], @[3], @[-1]]
        var P = @[@[0, -1, 2, -3, 4, -5]]
        deep_reverse(M)
        deep_reverse(N)
        deep_reverse(P)
        check M == @[@[3, 2, 1], @[2, 1, 0]]
        check N == @[@[-1], @[3], @[2], @[1], @[0]]
        check P == @[@[-5, 4, -3, 2, -1, 0]]
    test "arrays":
        var M = [[0, 1, 2], [1, 2, 3]]
        var N = [[0], [1], [2], [3], [-1]]
        var P = [[0, -1, 2, -3, 4, -5]]
        deep_reverse(M)
        deep_reverse(N)
        deep_reverse(P)
        check M == [[3, 2, 1], [2, 1, 0]]
        check N == [[-1], [3], [2], [1], [0]]
        check P == [[-5, 4, -3, 2, -1, 0]]
