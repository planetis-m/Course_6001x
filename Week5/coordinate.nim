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

proc sub(a, b: Coordinate): Coordinate =
    (a.x - b.x, a.y - b.y)

echo c.distance(origin)
echo c
echo c is Coordinate
echo sub(c - origin)
