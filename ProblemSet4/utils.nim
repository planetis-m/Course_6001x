# -----------------------------------
# Helper code
# (you don't need to understand this helper code)

import os, strutils

const
   vowels = "aeiou"
   consonants = "bcdfghjklmnpqrstvwxyz"
   hand_size = 7

const scrabble_letter_values = {
   'a': 1, 'b': 3, 'c': 3, 'd': 2, 'e': 1, 'f': 4, 'g': 2, 'h': 4, 'i': 1,
   'j': 8, 'k': 5, 'l': 1, 'm': 3, 'n': 1, 'o': 1, 'p': 3, 'q': 10, 'r': 1,
   's': 1, 't': 1, 'u': 1, 'v': 4, 'w': 4, 'x': 8, 'y': 4, 'z': 10
}.toTable

const wordlist_filename = "words.txt"

template withFile(f, fn, actions: untyped): untyped =
   var f: File
   if open(f, fn):
      try:
         actions
      finally:
         close(f)
   else:
      quit("cannot open: " & fn)

proc loadWords(): seq[string] =
   #
   # Returns a list of valid words. Words are strings of lowercase letters.
   #
   # Depending on the size of the word list, this function may
   # take a while to finish.
   #
   echo "Loading word list from file..."
   result = @[]
   withFile(inFile, wordlist_filename):
      for line in lines(inFile):
         result.add(line.strip().toLowerAscii())
   echo "  ", len(result), " words loaded."

proc getFrequencyDict(sequence: string): CountTable[char] =
   #
   # Returns a dictionary where the keys are elements of the sequence
   # and the values are integer counts, for the number of times that
   # an element is repeated in the sequence.
   #
   # sequence: string
   # return: dictionary
   #
   # freqs: dictionary (char -> int)
   result = initCountTable[char]()
   for x in sequence:
      result.inc(x)
