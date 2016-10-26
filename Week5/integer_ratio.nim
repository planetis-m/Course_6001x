const
    EPS = 1.0e-12

proc as_integer_ratio(f: float, maxden = 10): tuple[nu, de: int] =
    ## Find rational approximation to given real number
    ## David Eppstein / UC Irvine / 8 Aug 1993
    ##
    ## With corrections from Arno Formella, May 2008
    ##
    ## based on the theory of continued fractions
    ## if x = a1 + 1/(a2 + 1/(a3 + 1/(a4 + ...)))
    ## then best approximation is found by truncating this series
    ## (with some adjustments in the last term).
    ##
    ## Note the fraction can be recovered as the first column of the matrix
    ##  ( a1 1 ) ( a2 1 ) ( a3 1 ) ...
    ##  ( 1  0 ) ( 1  0 ) ( 1  0 )
    ## Instead of keeping the sequence of continued fraction terms,
    ## we just keep the last partial product of these matrices.
    ##
    ## .. code-block::
    ##   echo as_integer_ratio(10.0)
    ##   # (nu: 10, de: 1)
    ##   echo as_integer_ratio(0.0)
    ##   # (nu: 0, de: 1)
    ##   echo as_integer_ratio(-0.25)
    ##   # (nu: -1, de: 4)
    var
        m11 = 1
        m22 = 1
        m12 = 0
        m21 = 0
    var x = f
    var ai = x.int
    while m21 * ai + m22 <= maxden:
        swap m12, m11
        swap m22, m21
        m11 = m12 * ai + m11
        m21 = m22 * ai + m21
        if x == ai.float:
            break
        if abs(x - ai.float) < EPS:
            break
        x = 1.0 / (x - ai.float)
        ai = x.int

    # let error = f - m11/m21
    result = (m11, m21)

when isMainModule:
    assert as_integer_ratio(0.0) == (0, 1)
    assert as_integer_ratio(-0.25) == (1, -4)
    assert as_integer_ratio(3.2) == (16, 5)
    assert as_integer_ratio(0.33) == (1, 3)
    assert as_integer_ratio(0.22) == (2, 9)
    assert as_integer_ratio(10.0) == (10, 1)
