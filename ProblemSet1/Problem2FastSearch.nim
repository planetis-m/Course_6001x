import times, strutils

template times(x: typed, y: untyped): untyped =
   for i in 1 .. x:
      y

let s = "obobbbobbsoboooboobobbobobahoboboobobomobobo"
let key = "bob"

proc find(s, key: string): int =
   let
      m = len(key)
      n = len(s)

   var a: array[char, int]
   for i in 0..0xff: a[chr(i)] = m + 1
   for i in 0..m - 1: a[key[i]] = m - i

   var i = 0
   while i <= n - m:
      block match:
         for k in 0 .. m - 1:
            #echo i + k, s[i + k], key[k]
            if s[i + k] != key[k]:
               break match
         inc(result)
      inc(i, a[s[i + m]])

let start = cpuTime()
1_000_000.times:
   discard find(s, key)
let duration = cpuTime() - start

let timeStr = formatFloat(duration, ffDecimal, precision = 3)

echo "Number of times bob occurs is: plenty. Found in ", timeStr, " s."
