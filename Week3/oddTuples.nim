
proc oddArrays[T](anArray: seq[T]): seq[T] =
    #
    # aArray: a sequence
    #
    # returns: sequence, every other element of aArray.
    #

    # Iterate over the elements in aArray, counting by 2
    #  (every other element) and adding that element to 
    #  the result
    result = @[]
    var i = 0
    while i < len(anArray):
        result.add(anArray[i])
        i += 2

echo oddArrays(@[2, 3, 6, 16, 7])
echo oddArrays(@[20, 5, 6, 20])
echo oddArrays(@["I", "am", "a", "test", "tuple"])
