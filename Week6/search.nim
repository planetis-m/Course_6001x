type
  Iterable[T] = concept c
    for x in items(c): x is T

  Indexable[T] = concept c
    var i: int
    c[i] is T
    c.len is int

proc linearSearch[T](s: Iterable[T]; e: T): bool =
  for v in s:
    if v == e:
      result = true

proc search[T](s: Iterable[T]; e: T): bool =
  for v in s:
    if v == e:
      return true
    if v > e:
      return false

proc bisectionSearch1[T](s: Indexable[T]; e: T): bool =
  if len(s) == 0:
    return false
  elif len(s) == 1:
    return s[0] == e
  else:
    let half = len(s) div 2
    if s[half] > e:
      return bisectionSearch1(s[0 ..< half], e)
    else:
      return bisectionSearch1(s[half .. ^1], e)

proc bisectionSearch2[T](s: Indexable[T]; e: T): bool =
  proc helper(s: Indexable[T]; e: T; low, high: int): bool =
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
    return helper(s, e, 0, len(s) - 1)

when isMainModule:
  let l = @[5, 1, 3, 2]
  let sl = @[1, 2, 3, 5]

  echo l.linearSearch(4)
  echo l.linearSearch(1)
  echo l.linearSearch(6)

  echo sl.search(6)
  echo sl.search(4)
  echo sl.search(2)

  echo sl.bisectionSearch1(4)
  echo sl.bisectionSearch1(1)
  echo sl.bisectionSearch1(6)

  echo sl.bisectionSearch2(4)
  echo sl.bisectionSearch2(1)
  echo sl.bisectionSearch2(6)
