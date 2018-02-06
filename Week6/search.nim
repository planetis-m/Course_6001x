proc linear_search[T](s: seq[T]; e: T): bool =
   for v in s:
      if v == e:
         result = true

proc search[T](s: seq[T]; e: T): bool =
   for v in s:
      if v == e:
         return true
      if v > e:
         return false

proc bisection_search1[T](s: seq[T]; e: T): bool =
   if len(s) == 0:
      return false
   elif len(s) == 1:
      return s[0] == e
   else:
      let half = len(s) div 2
      if s[half] > e:
         return bisection_search1(s[0 ..< half], e)
      else:
         return bisection_search1(s[half ..< ^1], e)

proc bisection_search2[T](s: seq[T]; e: T): bool =
   proc helper(s: seq[T]; e: T; low, high: int): bool =
      if high == low:
         return s[low] == e
      let mid = (low + high) div 2
      if s[mid] == e:
         return true
      elif s[mid] > e:
         if low == mid: # nothing left to search
            return false
         else:
            return helper(s, e, low, mid-1)
      else:
         return helper(s, e, mid+1, high)
   if len(s) == 0:
      return false
   else:
      return helper(s, e, 0, len(s)-1)


let l = @[5, 1, 3, 2]
let sl = @[1, 2, 3, 5]

echo l.linear_search(4)
echo l.linear_search(1)
echo l.linear_search(6)

echo sl.search(6)
echo sl.search(4)
echo sl.search(2)

echo sl.bisection_search1(4)
echo sl.bisection_search1(1)
echo sl.bisection_search1(6)

echo sl.bisection_search2(4)
echo sl.bisection_search2(1)
echo sl.bisection_search2(6)
