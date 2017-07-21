
proc `$`[T](a: openarray[T]): string =
   ## The `$` operator for arrays.
   result = "["
   for val in a:
      if result.len > 1: result.add(", ")
      result.add($val)
   result.add("]")
