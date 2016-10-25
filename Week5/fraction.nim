type
    Fraction = object
        numerator, denominator: int
    FractionRef = ref Fraction

proc initFraction(a, b: int): Fraction =
    result.numerator = a
    result.denominator = b

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

proc toDecimal(f: Fraction): float =
    f.numerator / f.denominator


when isMainModule:
    let oneHalf = initFraction(1, 2)
    let twoThirds = initFraction(2, 3)
    let fourSixths = initFraction(4, 6)

    echo oneHalf
    echo twoThirds.denominator
    echo twoThirds == fourSixths

    echo oneHalf + twoThirds
    let threeQuarters = Fraction(numerator: 3, denominator: 4)

    echo threeQuarters.toDecimal()
