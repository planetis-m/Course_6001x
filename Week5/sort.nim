import algorithm

proc bogo_sort[T](s: var seq[T]) =
   while not isSorted(s):
      nextPermutation(s)

var v = @[0, 1, 2, 3, 4, 5, 6, 7, 9, 8]
bogo_sort(v)

echo v
