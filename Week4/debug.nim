import algorithm, rdstdin

proc isPal(x: seq[string]): bool =
   let temp = x.reversed()
   echo(temp, x)
   if temp == x:
      return true
   else:
      return false

proc silly(n: int) =
   var res: seq[string] = @[]
   for i in 1 .. n:
      let elem = readLineFromStdin("Enter element: ")
      res.add(elem)
   if isPal(res):
      echo("Yes")
   else:
      echo("No")

silly(5)
