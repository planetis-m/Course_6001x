import std/[assertions, syncio]

proc mult*[T: SomeNumber](a, b: T): T =
  if b == 1:
    return a
  else:
    return a + mult(a, b - 1)

proc fact*(n: int): int =
  if n == 1:
    return 1
  else:
    return n * fact(n - 1)

proc pow*[T: SomeNumber](base: T, exp: int): T =
  #
  # base: int or float.
  # exp: int >= 0
  #
  # returns: int or float, base^exp
  #
  assert exp >= 0
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
  assert a >= 0 and b >= 0
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

proc intToBin*(num: int): string =
  #
  # num, positive integer
  #
  # Returns the binary representation of `num`
  #
  if num == 0:
    return ""
  else:
    return intToBin(num div 2) & $(num mod 2)

when isMainModule:
  assert mult(5, 12) == 60
  assert mult(5.0, 12.0) == 60.0
  assert fact(4) == 24
  assert pow(2, 3) == 8
  assert pow(2.0, 3) == 8.0
  assert gcd(9, 12) == 3
  assert fib(40) == 165580141
  assert intToBin(72) == "1001000"
