# -----------------------------------
# Redefinitions
# (used to overload procedures)

import std/[algorithm, tables]

proc contains*(a: seq[string], item: string): bool {.inline.} =
   # in operator calls the procedure contains, which
   # in its turn is a shortcut to find(a, item) >= 0
   # overload contains to use binary search for wordlist which is ordered
   result = binarySearch(a, item) >= 0

proc toCountTable*[A](pairs: openArray[(A, int)]): CountTable[A] =
   # Creates a new count table with every member of a container ``pairs``
   # having a count of `val`. Used in test_scrabble, only.
   result = initCountTable[A](pairs.len)
   for key, val in pairs.items: result.inc(key, val)
