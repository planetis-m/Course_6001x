import std/[random, syncio]

# Write a function that returns the sum of the pairwise products of listA and listB. 
# You should assume that listA and listB have the same length and are two lists of 
# integer numbers. For example, if listA = [1, 2, 3] and listB = [4, 5, 6], the dot 
# product is 1*4 + 2*5 + 3*6, meaning your function should return: 32

proc randIntList(N: static[int]): array[N, int] =
  for i in 0 .. <N:
    result[i] = random(50)

proc dotProduct(listA, listB: openarray[int]): int =
  #
  # listA: a list of numbers
  # listB: a list of numbers of the same length as listA
  #
  for i in 0 .. high(listA):
    result += listA[i] * listB[i]

let
  listA = randIntList(100)
  listB = randIntList(100)

echo dotProduct(listA, listB)
