let L = [[1, 2], [3, 4], [5, 7]]

proc `$`[T](a: openarray[T]): string =
    ## The `$` operator for arrays.
    let n = len(a)
    result = "["
    for i in 0 .. <n - 1:
        result &= $(a[i]) & ", "
    result &= $(a[n - 1]) & "]"

echo L
