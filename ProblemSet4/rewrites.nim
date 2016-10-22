# -----------------------------------
# Redefinitions
# (used to overload procedures)

import algorithm, sequtils

proc contains(a: seq[string], item: string): bool {.inline.} =
    # in operator calls the procedure contains, which
    # in its turn is a shortcut to find(a, item) >= 0
    # overload contains to use binary search for wordlist which is ordered
    return binarySearch(a, item) >= 0

proc `==`[A](s, t: CountTable[A]): bool =
    let seq1 = toSeq(s.pairs)
    let seq2 = toSeq(t.pairs)
    if len(seq1) == len(seq2):
        for i in seq1:
            if i notin seq2: return false
        return true

proc toCountTable[A](pairs: openArray[(A, int)]): CountTable[A] =
    ## creates a new hash table that contains the given `pairs`.
    result = initCountTable[A](rightSize(pairs.len))
    for key, val in items(pairs):
        if val > 0: result[key] = val
