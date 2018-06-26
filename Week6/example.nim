proc intToStr(n: int): string =
   const digits = "0123456789"
   var n = n
   if n == 0:
      return "0"
   result = ""
   while n > 0:
      result = digits[n mod 10] & result
      n = n div 10


echo intToStr(532)
