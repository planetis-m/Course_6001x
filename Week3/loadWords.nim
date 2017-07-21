import os, strutils


const lyrics_filename = "lyrics.txt"

template withFile(f, fn, actions: untyped): untyped =
   var f: File
   if open(f, fn):
      try:
         actions
      finally:
         close(f)
   else:
      quit("cannot open: " & fn)

proc load_words(): seq[string] =
   withFile(inFile, lyrics_filename):
      let content = inFile.readAll()
      result = content.splitWhitespace()

let she_loves_you = load_words()
