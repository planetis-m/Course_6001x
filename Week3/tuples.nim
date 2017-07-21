proc quotient_reminder(x, y: int): auto =
   return (x div y, x mod y)

var (x, y) = (2, 3)
(x, y) = (y, x)

let (q, r) = quotient_reminder(x, y)

echo q, ' ', r
