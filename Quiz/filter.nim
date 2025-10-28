import std/[sequtils, syncio]

proc f(i: int): int =
  i + 2
proc g(i: int): bool =
  i > 5

proc applyF_filterG(s: var seq[int], f: proc(i: int): int, g: proc(i: int): bool): int =
  #
  # Assumes s is a list of integers
  # Assume functions f and g are defined for you. 
  # f takes in an integer, applies a function, returns another integer 
  # g takes in an integer, applies a Boolean function, 
  #     returns either True or False
  # Mutates s such that, for each element i originally in s, s contains  
  #     i if g(f(i)) returns True, and no other elements
  # Returns the largest element in the mutated s or -1 if the list is empty
  #

  s = filterIt(s, g(f(it)))
  if len(s) > 0: max(s) else: -1

var s = @[0, -10, 5, 6, -4]
echo applyF_filterG(s, f, g)
echo s
