import math

type Coordinate = object
    x: float
    y: float

let c = Coordinate(x: 3, y: 4)
let origin = Coordinate(x: 0, y: 0)

proc distance(a, b: Coordinate): float =
    let x_diff_sq = pow(a.x - b.x, 2)
    let y_diff_sq = pow(a.y - b.y, 2)
    return pow(x_diff_sq + y_diff_sq, 0.5)

proc `$`(c: Coordinate): string =
    "<" & $c.x & ", " & $c.y & ">"

proc `-`(a, b: Coordinate): Coordinate =
    Coordinate(x: a.x - b.x, y: a.y - b.y)

echo c.distance(origin)
echo c
echo c is Coordinate
echo c - origin

type Coord = tuple[x, y: float]

let d: Coord = (x: 6.0, y: 9.0)
let orig: Coord = (x: 0.0, y: 0.0)

proc `$`(c: Coord): string =
    "<" & $c.x & ", " & $c.y & ">"

proc `-`(a, b: Coord): Coord =
    (x: a.x - b.x, y: a.y - b.y)

echo d
echo d is Coord
echo d - orig
