import math

proc polysum(n, s: float): float =
    # 
    # Input : n, s - positive integers where `n` is the number of sides and `s`
    # is the length of each side.
    # 
    # Returns the sum of the perimeter squared and the area.
    # 

    # This variable is the total area of the polygon.
    let area = 0.25 * n * pow(s, 2) / tan(PI / n)

    # This variable is the total length of the boundary of the polygon.
    let perimeter = n * s

    return round(pow(perimeter, 2) + area, 4)

# Not working
#let t = 0.25 * 6^2

echo polysum(4, 90)
echo polysum(14, 79)
