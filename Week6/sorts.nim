import algorithm, random

type
   Iterable = concept c
      for x in items(c): discard

   Indexable[T] = concept c
      var i: int
      c[i] is T
      c.len is int

proc bogoSort[T](s: var seq[T]) =
   while not isSorted(s, cmp):
      # nextPermutation(s)
      shuffle(s)

proc bubbleSort[T](s: var Indexable[T]) =
   var swapped = true
   var n = len(s)
   while swapped:
      swapped = false
      for j in 1 ..< n:
         if s[j - 1] > s[j]:
            swap(s[j - 1], s[j])
            swapped = true
      dec(n)

proc selectionSort[T](s: var Indexable[T]) =
   for i in 0 ..< len(s):
      var minIndex = i
      var minVal = s[i]
      # searches for the smallest of all following items
      for j in i + 1 ..< len(s):
         if minVal > s[j]:
            minIndex = j
            minVal = s[j]
      swap(s[i], s[minIndex])

proc insertionSort[T](s: var Indexable[T]) =
   for i in 1 ..< len(s):
      let x = s[i]
      var j = i - 1
      while j >= 0 and s[j] > x:
         s[j + 1] = s[j]
         dec(j)
      s[j + 1] = x

proc merge[T](left, right: seq[T]): seq[T] =
   result = @[]
   var i, j = 0
   while i < len(left) and j < len(right):
      if left[i] < right[j]:
         result.add(left[i])
         inc(i)
      else:
         result.add(right[j])
         inc(j)
   while i < len(left):
      result.add(left[i])
      inc(i)
   while j < len(right):
      result.add(right[j])
      inc(j)

proc mergeSort[T](s: Indexable[T]): seq[T] =
   if len(s) < 2:
      return s
   else:
      let middle = len(s) div 2
      let left = mergeSort(s[0 ..< middle])
      let right = mergeSort(s[middle .. ^1])
      return merge(left, right)


when isMainModule:
   template test(sort) =
      var clist = list
      shuffle(clist)
      sort(clist)
      assert clist == list

   const list = @[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

   test(bubbleSort)
   test(selectionSort)
   test(insertionSort)
   #test(mergeSort)
