import math

proc asIntegerRatio(f: float): tuple[nu, de: int] =
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

    var
        float_part: float
        exponent: int
        numerator: int
        denominator: int
        p_exponent: int

    let c = classify(f)
    if c == fcNan:
        raise newException(ValueError, "cannot convert NaN to integer ratio")
    elif c == fcNegInf or c == fcInf:
        raise newException(OverFlowError, "cannot convert Infinity to integer ratio")

    float_part = frexp(f, exponent) # f == float_part * 2**exponent exactly

    for i in 0 .. <300:
        if float_part == floor(float_part):
            break
        float_part *= 2.0
        dec(exponent)

    numerator = float_part.int
    denominator = 1
    p_exponent = abs(exponent)

    if exponent > 0:
        echo numerator
        numerator = numerator shl p_exponent
        echo numerator
    else:
        denominator = denominator shl p_exponent
    return (numerator, denominator)

echo asIntegerRatio(3.2)
