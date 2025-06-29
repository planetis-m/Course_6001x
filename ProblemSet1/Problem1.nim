# Write a program that counts up the number of vowels contained 
# in the string s. Valid vowels are: 'a', 'e', 'i', 'o', and 'u'. 
# For example, if s = 'azcbobobegghakl', your program should print:
# 
# Number of vowels: 5

import std/syncio

let s = "azcbobobegghakl"
let vowels = "aeiou"
var result = 0

for letter in s:
  if letter in vowels:
    inc(result)

echo "Number of vowels: ", $result
