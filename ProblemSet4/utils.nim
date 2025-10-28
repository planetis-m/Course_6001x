# -----------------------------------
# Helper code
# (you don't need to understand this helper code)

import std/[strutils, syncio]

const wordlistFilename = "words.txt"

template withFile(f, fn, actions: untyped): untyped =
   var f: File
   if open(f, fn):
      try:
         actions
      finally:
         close(f)
   else:
      quit("cannot open: " & fn)

proc loadWords*(): seq[string] =
   #
   # Returns a list of valid words. Words are strings of lowercase letters.
   #
   # Depending on the size of the word list, this function may
   # take a while to finish.
   #
   echo "Loading word list from file..."
   result = newSeqOfCap[string](83667)
   withFile(inFile, wordlistFilename):
      for line in lines(inFile):
         result.add(line.strip().toLowerAscii())
   echo "  ", result.len, " words loaded."
