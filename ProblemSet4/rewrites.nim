# -----------------------------------
# Redefinitions
# (used to overload procedures)

import algorithm

proc contains(a: seq[string], item: string): bool {.inline.} =
    # in operator calls the procedure contains, which
    # in its turn is a shortcut to find(a, item) >= 0
    # overload contains to use binary search for wordlist which is ordered
    return binarySearch(a, item) >= 0

proc toCountTable[A](pairs: openArray[(A, int)]): CountTable[A] =
    ## creates a new hash table that contains the given `pairs`.
    result = initCountTable[A](rightSize(pairs.len))
    for key, val in items(pairs):
        if val > 0: result[key] = val
