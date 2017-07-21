# square root of a number x is y, such as y*y = x

const x = 16.0

proc sqrt(x, g: float, n: int = 12, tol: float = 1e-6): float =
   var g = g
   for i in 1 .. n:
      if abs(g * g - x) <= tol:
         return g
      echo g, " ", x/g
      g = (g + x / g) / 2

proc f(x: float): float =
   return x * x - 16

proc f_deriv(x: float): float =
   return 2 * x

proc newton(x: float, n: int = 12, tol: float = 1e-6): float =
   var x = x
   for i in 0 .. n:
      assert f_deriv(x) != 0
      echo f(x)
      x -= f(x) / f_deriv(x)
      if abs(f(x)) <= tol:
         return x

echo newton(5, tol = 1e-4)
echo sqrt(x, 10, tol = 1e-4)
