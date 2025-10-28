# -----------------------------------
# Common functions
# (shared by both games)

import std/[random, tables]
import rewrites

const
   vowels = "aeiou"
   consonants = "bcdfghjklmnpqrstvwxyz"

   scrabbleLetterValues = {
      'a': 1, 'b': 3, 'c': 3, 'd': 2, 'e': 1, 'f': 4, 'g': 2,
      'h': 4, 'i': 1, 'j': 8, 'k': 5, 'l': 1, 'm': 3, 'n': 1,
      'o': 1, 'p': 3, 'q': 10, 'r': 1, 's': 1, 't': 1, 'u': 1,
      'v': 4, 'w': 4, 'x': 8, 'y': 4, 'z': 10}.toTable

proc getFrequencyDict*(sequence: string): CountTable[char] =
   #
   # Returns a dictionary where the keys are elements of the sequence
   # and the values are integer counts, for the number of times that
   # an element is repeated in the sequence.
   #
   # sequence: string
   # return: dictionary
   #
   # freqs: dictionary (char -> int)
   result = toCountTable[char](sequence)

proc getWordScore*(word: string, n: int): Natural =
   #
   # Returns the score for a word. Assumes the word is a valid word.
   #
   # The score for a word is the sum of the points for letters in the
   # word, multiplied by the length of the word, PLUS 50 points if all n
   # letters are used on the first turn.
   #
   # Letters are scored as in Scrabble; A is worth 1, B is worth 3, C is
   # worth 3, D is worth 2, E is worth 1, and so on (see SCRABBLE_LETTER_VALUES)
   #
   # word: string (lowercase letters)
   # n: integer (HAND_SIZE; i.e., hand size required for additional points)
   # returns: int >= 0
   #
   for c in word:
      result += scrabbleLetterValues[c]
   result *= word.len
   if word.len == n:
      result += 50

proc displayHand*(hand: CountTable[char]): string =
   #
   # Displays the letters currently in the hand.
   #
   # For example:
   # >>> displayHand({'a':1, 'x':2, 'l':3, 'e':1})
   # Should print out something like:
   #    a x x l l l e
   # The order of the letters is unimportant.
   #
   # hand: dictionary (string -> int)
   #
   for letter, times in hand.pairs:
      for i in 1 .. times:
         result.add(letter)
         result.add(' ')

proc dealHand*(n: int): CountTable[char] =
   #
   # Returns a random hand containing n lowercase letters.
   # At least n/3 the letters in the hand should be VOWELS.
   #
   # Hands are represented as dictionaries. The keys are
   # letters and the values are the number of times the
   # particular letter is repeated in that hand.
   #
   # n: int >= 0
   # returns: dictionary (string -> int)
   #
   result = initCountTable[char]()
   let numVowels = n div 3
   for i in 0 ..< numVowels:
      result.inc(sample(vowels))
   for i in numVowels ..< n:
      result.inc(sample(consonants))

#
# Problem #2: Update a hand by removing letters
#
proc updateHand*(hand: CountTable[char], word: string): CountTable[char] =
   #
   # Assumes that 'hand' has all the letters in word.
   # In other words, this assumes that however many times
   # a letter appears in 'word', 'hand' has at least as
   # many of that letter in it.
   #
   # Updates the hand: uses up the letters in the given word
   # and returns the new hand, without those letters in it.
   #
   # Has no side effects: does not modify hand.
   #
   # word: string
   # hand: dictionary (string -> int)
   # returns: dictionary (string -> int)
   #
   result = hand
   for letter in word:
      result.inc(letter, -1)

#
# Problem #3: Test word validity
#
proc isValidWord*(word: string, hand: CountTable[char], wordList: seq[string]): bool =
   #
   # Returns True if word is in the wordList and is entirely
   # composed of letters in the hand. Otherwise, returns False.
   #
   # Does not mutate hand or wordList.
   #
   # word: string
   # hand: dictionary (string -> int)
   # wordList: list of lowercase strings
   #
   if word in wordList:
      let lettersExpected = getFrequencyDict(word)
      for letter, times in lettersExpected.pairs:
         if not hand.hasKey(letter):
            return false
         elif hand[letter] < times:
            return false
      result = true

proc calculateHandlen*(hand: CountTable[char]): Natural =
   #
   # Returns the length (number of letters) in the current hand.
   #
   # hand: dictionary (string int)
   # returns: integer
   #
   result = 0
   for letter, times in hand.pairs:
      result += times
