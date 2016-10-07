import algorithm, unittest

include display_array

template deep_reverse_private(a: untyped) =
    #
    #  assumes L is a list of lists whose elements are ints
    # Mutates L such that it reverses its elements and also 
    # reverses the order of the int elements in every element of L. 
    # It does not return anything.
    #

    for i in 0 .. a.high:
        a[i].reverse()
    a.reverse()

proc deep_reverse(a: var seq[seq[int]]) =
    deep_reverse_private(a)

proc deep_reverse[I, J](a: var array[I, array[J, int]]) =
    deep_reverse_private(a)


var K = @[@[1, 2], @[3, 4], @[5, 6]]
var L = [[1, 2], [3, 4], [5, 6]]

deep_reverse(K)
deep_reverse(L)

echo K, ' ', L


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
