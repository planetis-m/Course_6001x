# -----------------------------------
# Redefinitions
# (used to overload procedures)

import algorithm

proc contains*(a: seq[string], item: string): bool {.inline.} =
   # in operator calls the procedure contains, which
   # in its turn is a shortcut to find(a, item) >= 0
   # overload contains to use binary search for wordlist which is ordered
   return binarySearch(a, item) >= 0
