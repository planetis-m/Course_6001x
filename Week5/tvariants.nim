import std/syncio

type
  ExprKind = enum
    literal, plusExpr
  PExpr = ref object
    case kind: ExprKind
    of literal: x: int
    of plusExpr: a, b: PExpr

proc eval(e: PExpr): int =
  case e.kind:
  of literal: e.x
  of plusExpr: eval(e.a) + eval(e.b)

proc newLit(x: int): PExpr = PExpr(kind: literal, x: x)
proc newPlus(a, b: PExpr): PExpr = PExpr(kind: plusExpr, a: a, b: b)

echo eval(newPlus(newPlus(newLit(1), newLit(2)), newLit(4)))
