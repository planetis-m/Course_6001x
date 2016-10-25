type Fraction = object
    numer, denom: int

proc initFraction(a, b: int): Fraction =
    result.numer = a
    result.denom = b

proc `$`(f: Fraction): string =
    $f.numer & "/" & $f.denom

proc `+`(a, b: Fraction): Fraction =
    result.numer = a.numer * b.denom + a.denom * b.numer
    result.denom = a.denom * b.denom

proc `-`(a, b: Fraction): Fraction =
    result.numer = a.numer * b.denom - a.denom * b.numer
    result.denom = a.denom * b.denom

proc `==`(a, b: Fraction): bool =
    a.numer * b.denom == b.numer * a.denom and 
        a.denom * b.denom == b.denom * a.denom

proc toDecimal(f: Fraction): float =
    f.numer / f.denom


let oneHalf = initFraction(1, 2)
let twoThirds = initFraction(2, 3)
let fourSixths = initFraction(4, 6)

echo oneHalf
echo twoThirds.denom
echo twoThirds == fourSixths

echo oneHalf + twoThirds
let threeQuarters = Fraction(numer: 3, denom: 4)

echo threeQuarters.toDecimal()
