import std/[algorithm, syncio]

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
  self.vals.sort(cmp[int])
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
