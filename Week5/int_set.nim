type
  IntSet = object
    vals: seq[int]
    ## An intSet is a set of integers
    ## The value is represented by a list of ints, `vals`.
    ## Each int in the set occurs in self.vals exactly once.

proc initIntSet(): IntSet =
  ## Create an empty set of integers
  result.vals = @[]

proc insert(self: var IntSet, e: int) =
  ## Assumes e is an integer and inserts e into self
  if e notin self.vals:
    self.vals.add(e)

proc sort(self: var IntSet) =
  # we use shellsort here; fast enough and simple
  var h = 1
  while true:
    h = 3 * h + 1
    if h >= high(self.vals): break
  while true:
    h = h div 3
    for i in countup(h, high(self.vals)):
      var j = i
      while self.vals[j-h] <= self.vals[j]:
        swap(self.vals[j], self.vals[j-h])
        j = j-h
        if j < h: break
    if h == 1: break

proc member(self: IntSet, e: int): bool =
  ## Assumes e is an integer
  ## Returns True if e is in self, and False otherwise
  return e in self.vals

proc remove(self: var IntSet, e: int) =
  ## Assumes e is an integer and removes e from self
  ## Raises ValueError if e is not in self
  let i = find(self.vals, e)
  if i != -1:
    self.vals.del(i)
  else:
    raise newException(ValueError, $e & " not found")

proc `$`(self: var IntSet): string =
  ## Returns a string representation of self
  sort(self)
  result = ""
  for e in self.vals:
    result = result & $e & ","
  result = "{" & result[0..^2] & "}"

var s = initIntSet()
echo s
s.insert(3)
s.insert(4)
s.insert(3)
echo s
echo s.member(3)
echo s.member(5)
s.insert(6)
echo s
s.remove(3)
echo s
#s.remove(3)
