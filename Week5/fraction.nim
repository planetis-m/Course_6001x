import std/[math, syncio]

type
   Fraction = object
      numerator, denominator: int
   FractionRef = ref Fraction

proc initFraction(a, b: int): Fraction =
   result.numerator = a
   result.denominator = b

proc newFraction(a, b: int): FractionRef =
   new result
   result[] = initFraction(a, b)

proc `$`(f: Fraction): string =
   $f.numerator & "/" & $f.denominator

proc `+`(a, b: Fraction): Fraction =
   result = initFraction(a.numerator * b.denominator + a.denominator * b.numerator,
      a.denominator * b.denominator)

proc `-`(a, b: Fraction): Fraction =
   result = initFraction(a.numerator * b.denominator - a.denominator * b.numerator,
      a.denominator * b.denominator)

proc `==`(a, b: Fraction): bool =
   a.numerator * b.denominator == b.numerator * a.denominator

proc toFloat(f: Fraction): float =
   f.numerator / f.denominator

proc `$`(f: FractionRef): string =
   $f[].numerator & "/" & $f[].denominator

proc `+`(a, b: FractionRef): FractionRef =
   new result
   result[] = a[] + b[]

proc `-`(a, b: FractionRef): FractionRef =
   new result
   result[] = a[] - b[]

proc `==`(a, b: FractionRef): bool =
   result = a[] == b[]

proc toFloat(f: FractionRef): float =
   f[].numerator / f[].denominator


when isMainModule:
   let oneHalf = initFraction(1, 2)
   let twoThirds = initFraction(2, 3)
   let fourSixths = initFraction(4, 6)

   echo oneHalf
   echo twoThirds.denominator
   echo twoThirds == fourSixths

   echo oneHalf + twoThirds

   let threeQuarters = newFraction(3, 4)
   let oneQuarter = newFraction(1, 4)

   echo oneQuarter + threeQuarters
   echo threeQuarters.toFloat()
