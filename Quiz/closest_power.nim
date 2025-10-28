import std/[math, assertions, syncio]

proc closest_power(base, num: int): int =
  #
  # base: base of the exponential, integer > 1
  # num: number you want to be closest to, integer > 0
  # Find the integer exponent such that base**exponent is closest to num.
  # Note that the base**exponent may be either greater or smaller than num.
  # In case of a tie, return the smaller value.
  # Returns the exponent.
  #

  var
    exp = 0
    last = 0
  while base^exp < num:
    last = exp
    exp += 1
  if abs(base^exp-num) >= abs(base^last-num): last
  else: exp

# Test
assert closest_power(4, 62) == 3
assert closest_power(42, 1) == 0
assert closest_power(9, 75) == 2
assert closest_power(5, 375) == 3
assert closest_power(10, 550) == 2
