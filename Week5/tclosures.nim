type
   PExpr = ref object of RootObj ## abstract base class for an expression
      evalImpl: proc(e: PExpr): int
   PLiteral = ref object of PExpr
      x: int
   PPlusExpr = ref object of PExpr
      a, b: PExpr

proc eval(e: PExpr): int =
   assert e.evalImpl != nil
   e.evalImpl(e)

proc evalLit(e: PExpr): int = PLiteral(e).x
proc evalPlus(e: PExpr): int = eval(PPlusExpr(e).a) + eval(PPlusExpr(e).b)

proc newLit(x: int): PLiteral = PLiteral(evalImpl: evalLit, x: x)
proc newPlus(a, b: PExpr): PPlusExpr = PPlusExpr(evalImpl: evalPlus, a: a, b: b)

echo eval(newPlus(newPlus(newLit(1), newLit(2)), newLit(4)))
