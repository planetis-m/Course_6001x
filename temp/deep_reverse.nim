proc deep_reverse(L: var openarray[int]) =
    #  assumes L is a list of lists whose elements are ints
    # Mutates L such that it reverses its elements and also 
    # reverses the order of the int elements in every element of L. 
    # It does not return anything.
    #
    for i in L:
        for j in L[i]:
            
