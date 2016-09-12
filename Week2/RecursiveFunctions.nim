
proc mult*(a, b: int): int =
    if b == 1:
        return a
    else:
        return a + mult(a, b - 1)

proc fact*(n: int): int =
    if n == 1:
        return 1
    else:
        return n * fact(n - 1)

proc pow*(base, exp: int): int =
    # 
    # base: int or float.
    # exp: int >= 0
    # 
    # returns: int or float, base^exp
    # 
    doAssert exp >= 0
    if exp == 0:
        return 1
    else:
        return base * pow(base, exp - 1)

proc gcd*(a, b: int): int =
    # 
    # a, b: positive integers
    # 
    # returns: a positive integer, the greatest common divisor of a & b.
    # 
    doAssert a >= 0 and b >= 0
    if b == 0:
        return a
    else:
        return gcd(b, a mod b)

proc fib*(x: int): int =
    #
    # assumes x an int >= 0
    # 
    # returns Fibonacci of x
    #
    if x == 0 or x == 1:
        return 1
    else:
        return fib(x - 1) + fib(x - 2)

proc decToBin*(num: int): string =
    #
    # num, positive integer
    #
    # Returns the binary representation of `num`
    #
    if num == 0:
        return ""
    else:
        return decToBin(num div 2) & $(num mod 2)

when false:
    assert mult(5, 12) == 60
    assert fact(4) == 24
    assert pow(2, 3) == 8
    assert gcd(9, 12) == 3
    assert fib(40) == 165580141
    assert decToBin(72) == "1001000"
