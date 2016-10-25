import math

proc asIntegerRatio(f: float, maxden = 10): tuple[nu, de: int] =
    ## Return a pair of integers, whose ratio is exactly equal to the original
    ## float and with a positive denominator.
    ## Raise OverflowError on infinities and a ValueError on NaNs.
    ##
    ## .. code-block::
    ##   as_integer_ratio(10.0)
    ##   # (10, 1)
    ##   as_integer_ratio(0.0)
    ##   # (0, 1)
    ##   as_integer_ratio(-0.25)
    ##   # (-1, 4)

    proc number_decimal_places(f: float): int =
        result = len($f) - 2

    let
        higher = 10^f.number_decimal_places()
        lower = f.int*higher
        gcden = gcd(higher, lower)

    result = (round(lower/gcden).int, round(higher/gcden).int)

echo asIntegerRatio(3.25)
