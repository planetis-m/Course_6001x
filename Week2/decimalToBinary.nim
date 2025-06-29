
import std/syncio

proc binary(num: int): string =
  result = ""
  var num = num
  if num == 0:
    result = "0"
  while num > 0:
    result = $(num mod 2) & result
    num = num div 2

echo binary(19)
