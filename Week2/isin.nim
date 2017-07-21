proc isIn(char: char, aStr: string): bool =
   #
   # char: a single character
   # aStr: an alphabetized string
   #
   # returns: true if char is in aStr; false otherwise
   #
   let n = len(aStr)
   # Base case: If aStr is empty, we did not find the char.
   if n == 0:
      return false

   # Base case: if aStr is of length 1, just see if the chars are equal
   if n == 1:
      return char == aStr[0]

   # Base case: See if the character in the middle of aStr equals the 
   #   test character 
   if char == aStr[n div 2]:
      return true

   # Recursive case: If the test character is smaller than the middle 
   #  character, recursively search on the first half of aStr
   elif char < aStr[n div 2]:
      return isIn(char, aStr[0 .. <n div 2])

   # Otherwise the test character is larger than the middle character,
   #  so recursively search on the last half of aStr
   else:
      return isIn(char, aStr[n div 2 + 1 .. <n])

doAssert isIn('a', "") == false
doAssert isIn('a', "acfjlruxyzz") == true
doAssert isIn('j', "abbghijmquvvw") == true
doAssert isIn('e', "abffllloopvwy") == false
doAssert isIn('h', "dddhlprr") == true
doAssert isIn('a', "begilsvw") == false
doAssert isIn('u', "mquwxz") == true
doAssert isIn('w', "acdeeghimpqrvxx") == false
doAssert isIn('s', "dfno") == false
doAssert isIn('r', "uy") == false
