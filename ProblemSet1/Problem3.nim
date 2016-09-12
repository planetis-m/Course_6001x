# Write a program that prints the longest substring of s in 
# which the letters occur in alphabetical order. For example, 
# if s = 'azcbobobegghakl', then your program should print:
# 
# Longest substring in alphabetical order is: beggh
# 
# In the case of ties, print the first substring. For example, 
# if s = 'abcbcd', then your program should print:
# 
# Longest substring in alphabetical order is: abc

const s = "azcbobobegghakl"

var result = ""
var temp = ""
var m = 'a'
for i in s:
    #echo i, m, '\t', result, '\t', temp
    if i < m:
        if len(result) < len(temp):
            result = temp
        temp = ""
    m = i
    temp.add(i)

if len(result) < len(temp):
    result = temp

echo "Longest substring in alphabetical order is: ", $result
