import algorithm

include display_array

template deep_reverse_private(a: untyped) =
   for i in 0 .. a.high:
      a[i].reverse()
   a.reverse()

proc deep_reverse*(a: var seq[seq[int]]) =
   #
   #  assumes L is a list of lists whose elements are ints
   # Mutates L such that it reverses its elements and also
   # reverses the order of the int elements in every element of L.
   # It does not return anything.
   #
   deep_reverse_private(a)

proc deep_reverse*[I, J](a: var array[I, array[J, int]]) =
   deep_reverse_private(a)


when isMainModule:
   var K = @[@[1, 2], @[3, 4], @[5, 6]]
   var L = [[1, 2], [3, 4], [5, 6]]

   deep_reverse(K)
   deep_reverse(L)

   echo K, ' ', L
