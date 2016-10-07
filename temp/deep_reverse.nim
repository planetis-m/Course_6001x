import algorithm

include display_array

proc deep_reverse[I, J](a: var array[I, array[J, int]]) =
    #
    #  assumes L is a list of lists whose elements are ints
    # Mutates L such that it reverses its elements and also 
    # reverses the order of the int elements in every element of L. 
    # It does not return anything.
    #

    for i in a:
        i.reverse()
    a.reverse()


var L = [[1, 2], [3, 4], [5, 6]]
deep_reverse(L)
echo L
