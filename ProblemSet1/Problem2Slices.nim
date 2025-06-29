import std/syncio

let s = "bobblbobecbobboboohoboborlifs"
let key = "bob"

proc countOccr(s, key: string): int =
  #
  # Input: `s` the string to be searched and
  # `key` the substring to search for.
  #
  # Returns the number of times the `key`
  # occurs in `s`.
  #
  let
    m = len(key)
    n = len(s)
  for i in 0 .. n - m:
    if s[i ..< i + m] == key:
      inc(result)

let result = countOccr(s, key)

echo "Number of times bob occurs is: ", $result
