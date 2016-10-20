# The 6.00 Word Game

import os, random, rdstdin, sequtils, strtabs, strutils, tables

const
    vowels = "aeiou"
    consonants = "bcdfghjklmnpqrstvwxyz"
    hand_size = 7

const scrabble_letter_values = {
    'a': 1, 'b': 3, 'c': 3, 'd': 2, 'e': 1, 'f': 4, 'g': 2, 'h': 4, 'i': 1,
    'j': 8, 'k': 5, 'l': 1, 'm': 3, 'n': 1, 'o': 1, 'p': 3, 'q': 10, 'r': 1,
    's': 1, 't': 1, 'u': 1, 'v': 4, 'w': 4, 'x': 8, 'y': 4, 'z': 10
}.toTable

# -----------------------------------
# Helper code
# (you don't need to understand this helper code)

# Initializes the random number generator
randomize()

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

proc loadWords*(): seq[string] =
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

template getFrequencyDictImpl(): untyped =
    result = initCountTable[char]()
    for x in sequence:
        result.inc(x)

proc getFrequencyDict*(sequence: seq[char]): CountTable[char] =
    #
    # Returns a dictionary where the keys are elements of the sequence
    # and the values are integer counts, for the number of times that
    # an element is repeated in the sequence.
    #
    # sequence: string or list
    # return: dictionary
    #

    # freqs: dictionary (char -> int)
    getFrequencyDictImpl()

proc getFrequencyDict*(sequence: string): CountTable[char] =
    getFrequencyDictImpl()

proc `==`*[A](s, t: CountTable[A]): bool =
    let seq1 = toSeq(s.pairs)
    let seq2 = toSeq(t.pairs)
    if len(seq1) == len(seq2):
        for i in seq1:
            if i notin seq2: return false
        return true

proc toCountTable*[A](pairs: openArray[(A, int)]): CountTable[A] =
    ## creates a new hash table that contains the given `pairs`.
    result = initCountTable[A](rightSize(pairs.len))
    for key, val in items(pairs):
        if val > 0: result[key] = val

# (end of helper code)
# -----------------------------------

proc getWordScore*(word: string, n: int): int =
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
        result += scrabble_letter_values[c]
    result *= len(word)
    if len(word) == n:
        result += 50

proc displayHand(hand: CountTable[char]): string =
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
    result = ""
    for letter, times in pairs(hand):
        for i in 0 .. <times:
            result.add(letter & ' ')

proc dealHand(n: int): CountTable[char] =
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

    for i in 0 .. <numVowels:
        let x = vowels[random(len(vowels))]
        result.inc(x)

    for i in numVowels .. <n:
        let x = consonants[random(len(consonants))]
        result.inc(x)

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
        result[letter] -= 1

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
        for key, val in lettersExpected.pairs():
            if not hand.hasKey(key):
                return false
            if hand.getOrDefault(key) < val:
                return false
        return true

proc playGame(wordList: seq[string]) =
    #
    # Allow the user to play an arbitrary number of hands.
    #
    # 1) Asks the user to input 'n' or 'r' or 'e'.
    #   * If the user inputs 'n', let the user play a new (random) hand.
    #   * If the user inputs 'r', let the user play the last hand again.
    #   * If the user inputs 'e', exit the game.
    #   * If the user inputs anything else, tell them their input was invalid.
    #
    # 2) When done playing the hand, repeat from step 1
    #

    const
        msg0 = "Enter n to deal a new hand, r to replay the last hand, or e to end game: "
        msg1 = "Current Hand: "
        msg2 = "Enter word, or a . to indicate that you are finished: "
        msg3 = "$1 earned $2 points. Total: $3 points"
        msg4 = "Total score: "
        msg5 = "Run out of letters. Total score: "

        err0 = "Invalid word, please try again."

proc main() =
    let wordlist = loadWords()

when isMainModule:
    main()
