# Write a program that prints the number of times the string 'bob' occurs in 
# s. For example, if s = 'azcbobobegghakl', then your program should print:
# 
# Number of times bob occurs is: 2

import std/syncio

let s = "azcbobobegghakl"
let key = "bob"

var result = 0
let m = len(key)
let n = len(s)
for i in 0 .. n - m:
  block match:
    for k in 0 .. m - 1:
      #echo i + k, s[i + k], key[k]
      if s[i + k] != key[k]:
        break match
    inc(result)

echo "Number of times ", key, " occurs is: ", $result
