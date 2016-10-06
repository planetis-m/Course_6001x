let L = [[1, 2], [3, 4], [5, 7]]

proc `$`[T](a: openarray[T]): string =
    ## The `$` operator for arrays.
    result = "["
    for val in a:
        if result.len > 1: result.add(", ")
        result.add($val)
    result.add("]")

echo L
