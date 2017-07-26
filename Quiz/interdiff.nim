# Write a function called dict_interdiff that takes in two dictionaries (d1 and d2). 
# The function will return a tuple of two dictionaries: a dictionary of the intersect 
# of d1 and d2 and a dictionary of the difference of d1 and d2, calculated as follows:
# 
# intersect: The keys to the intersect dictionary are keys that are common in both d1 
# and d2. To get the values of the intersect dictionary, look at the common keys in d1 
# and d2 and apply the function f to these keys' values -- the value of the common key 
# in d1 is the first parameter to the function and the value of the common key in d2 
# is the second parameter to the function. Do not implement f inside your dict_interdiff 
# code -- assume it is defined outside.
# 
# difference: a key-value pair in the difference dictionary is (a) every key-value pair 
# in d1 whose key appears only in d1 and not in d2 or (b) every key-value pair in d2 
# whose key appears only in d2 and not in d1.

import tables

let
   d1 = {1:30, 2:20, 3:30, 5:80}.toTable()
   d2 = {1:40, 2:50, 3:60, 4:70, 6:90}.toTable()

proc f(a, b: int): int =
   a + b

proc dict_interdiff(d1, d2: Table[int, int]): auto =
   ##
   ## d1, d2: dicts whose keys and values are integers
   ## Returns a tuple of dictionaries according to the instructions above
   ##

   proc intersect(d1, d2: Table[int, int]): Table[int, int] =
      result = initTable[int, int]()
      for key in keys(d1):
         if key in d2:
            result[key] = f(d1[key], d2[key])

   proc difference(d1, d2: Table[int, int]): Table[int, int] =
      result = initTable[int, int]()
      for key, val in pairs(d1):
         if key notin d2:
            result[key] = val
      for key, val in pairs(d2):
         if key notin d1:
            result[key] = val

   (inter: intersect(d1, d2), diff: difference(d1, d2))

echo dict_interdiff(d1, d2)
