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

const
    msg0 = "Enter n to deal a new hand, r to replay the last hand, or e to end game: "
    msg1 = "You have not played a hand yet. Please play a new hand first!"
    msg2 = "Current Hand: "
    msg3 = "Enter word, or a . to indicate that you are finished: "
    msg4 = "$1 earned $2 points. Total: $3 points"
    msg5 = "Goodbye! Total score: $1 points."
    msg6 = "Run out of letters. Total score: $1 points."

    err0 = "Invalid word, please try again."
    err1 = "Invalid command."

# Initializes the random number generator
randomize()

# -----------------------------------
# Helper code
# (you don't need to understand this helper code)

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
    result = initCountTable[char]()
    for x in sequence:
        result.inc(x)

# Procedures used by test_ps4.nim

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

proc calculateHandlen(hand: CountTable[char]): int =
    #
    # Returns the length (number of letters) in the current hand.
    #
    # hand: dictionary (string int)
    # returns: integer
    #
    result = 0
    for k in hand.keys():
        result += hand[k]

proc playHand(hand: var CountTable[char], wordList: seq[string], n: int) =
    #
    # Allows the user to play the given hand, as follows:
    #
    # * The hand is displayed.
    # * The user may input a word or a single period (the string ".")
    #   to indicate they're done playing
    # * Invalid words are rejected, and a message is displayed asking
    #   the user to choose another word until they enter a valid word or "."
    # * When a valid word is entered, it uses up letters from the hand.
    # * After every valid word: the score for that word is displayed,
    #   the remaining letters in the hand are displayed, and the user
    #   is asked to input another word.
    # * The sum of the word scores is displayed when the hand finishes.
    # * The hand finishes when there are no more unused letters or the user
    #   inputs a "."
    #
    #   hand: dictionary (string -> int)
    #   wordList: list of lowercase strings
    #   n: integer (HAND_SIZE; i.e., hand size required for additional points)
    #
    var word: string
    # Keep track of the total score
    var totalScore = 0
    # As long as there are still letters left in the hand:
    while calculateHandlen(hand) > 0:
        # Display the hand
        echo msg2, displayHand(hand)

        # Ask user for input
        word = readLineFromStdin(msg3)

        # If the input is a single period:
        if word == ".":
            # End the game (break out of the loop)
            break

        # Otherwise (the input is not a single period):
        else:
            # If the word is not valid:
            if not isValidWord(word, hand, wordList):
                # Reject invalid word (print a message followed by a blank line)
                echo err0, "\n"

            # Otherwise (the word is valid):
            else:
                # Tell the user how many points the word earned, and the updated total score, in one line followed by a blank line
                totalScore += getWordScore(word, n)
                echo msg4 % [$word, $getWordScore(word, n), $totalScore]
                echo ""
                # Update the hand
                hand = updateHand(hand, word)

    # Game is over (user entered a '.' or ran out of letters), so tell user the total score
    if word == ".":
        echo msg5 % [$totalScore]
    else:
        echo msg6 % [$totalScore]

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
    var hand: CountTable[char]
    while true:
        let choice = readLineFromStdin(msg0)
        if choice == "n":
            hand = dealHand(hand_size)
            playHand(hand, wordList, hand_size)
        elif choice == "r":
            if len(hand) == 0:
                echo msg1
            else:
                playHand(hand, wordList, hand_size)
        elif choice != "e":
            echo err1
        else:
            break

proc main() =
    let wordlist = loadWords()
    playGame(wordList)

when isMainModule:
    main()
