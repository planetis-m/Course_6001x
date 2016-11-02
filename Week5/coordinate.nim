import math

type Coordinate = ref object
    x: float
    y: float


proc distance(a, b: Coordinate): float =
    let x_diff_sq = pow(a.x - b.x, 2)
    let y_diff_sq = pow(a.y - b.y, 2)
    return pow(x_diff_sq + y_diff_sq, 0.5)

proc `$`(c: Coordinate): string =
    "<" & $c.x & ", " & $c.y & ">"

proc `-`(a, b: Coordinate): Coordinate =
    result = Coordinate(x: a.x - b.x, y: a.y - b.y)


let c = Coordinate(x: 3, y: 4)

let origin = new Coordinate
origin.x = 0
origin.y = 0

echo c.distance(origin)
echo c
echo c is Coordinate
echo c - origin
