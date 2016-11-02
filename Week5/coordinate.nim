import math

type Coordinate = ref object
    x: float
    y: float


proc newCoordinate(x, y: float): Coordinate =
    result = Coordinate(x: x, y: y)

proc distance(a, b: Coordinate): float =
    let x_diff_sq = pow(a.x - b.x, 2)
    let y_diff_sq = pow(a.y - b.y, 2)
    return pow(x_diff_sq + y_diff_sq, 0.5)

proc `$`(c: Coordinate): string =
    "<" & $c.x & ", " & $c.y & ">"

proc `-`(a, b: Coordinate): Coordinate =
    result = newCoordinate(a.x - b.x, a.y - b.y)


let c = newCoordinate(3, 4)
let origin = newCoordinate(0, 0)

echo c.distance(origin)
echo c
echo c is Coordinate
echo c - origin
