# Hangman game
#

# -----------------------------------
# Helper code

import os, random, rdstdin, strtabs, strutils

# Initializes the random number generator
randomize()

const wordlist_filename = "words.txt"

type
   MsgKind {.pure.} = enum
      GreetPlayer,
      WordLength,
      RemainingGuesses,
      AvailableLetters,
      PromptGuess,
      GoodGuess,
      WrongGuess,
      UnknownInput,
      RepeatedGuess,
      GameSuccess,
      GameFailure

const
   messages: array[MsgKind, string] = [
      GreetPlayer: "Welcome to the game, Hangman!",
      WordLength: "I am thinking of a word that is $1 letters long.",

      RemainingGuesses: "You have $1 guesses left.",
      AvailableLetters: "Available Letters: ",
      PromptGuess: "Please guess a letter: ",

      GoodGuess: "Good guess: ",
      WrongGuess: "Oops! That letter is not in my word: ",

      UnknownInput: "Sorry, I did not understand your input.",
      RepeatedGuess: "Oops! You've already guessed that letter: ",

      GameSuccess: "Congratulations, you won!",
      GameFailure: "Sorry, you ran out of guesses. The word was $1."
   ]

proc loadWords(): seq[string] =
   #
   # Returns a list of valid words. Words are strings of lowercase letters.
   #
   # Depending on the size of the word list, this function may
   # take a while to finish.
   #
   echo "Loading word list from file..."
   # inFile: file
   var inFile = open(wordlist_filename)
   # line: string
   let line = inFile.readLine()
   # wordlist: sequence of strings
   let wordlist = line.split()
   # Close the file
   inFile.close()
   echo "  ", len(wordlist), " words loaded."
   return wordlist

proc chooseWord(wordlist: seq[string]): string =
   #
   # wordlist (list): list of words (strings)
   #
   # Returns a word from wordlist at random
   #
   return random(wordlist)

# end of helper code
# -----------------------------------

# Load the list of words into the variable wordlist
# so that it can be accessed from anywhere in the program
let wordlist = loadWords()

proc isWordGuessed(secretWord: string, lettersGuessed: seq[char]): bool =
   #
   # secretWord: string, the word the user is guessing
   # lettersGuessed: list, what letters have been guessed so far
   # returns: boolean, true if all the letters of secretWord are in lettersGuessed;
   #   false otherwise
   #
   for c in secretWord:
      if c notin lettersGuessed:
         return false
   return true

proc getGuessedWord(secretWord: string, lettersGuessed: seq[char]): string =
   #
   # secretWord: string, the word the user is guessing
   # lettersGuessed: list, what letters have been guessed so far
   # returns: string, comprised of letters and underscores that represents
   #   what letters in secretWord have been guessed so far.
   #
   result = ""
   for c in secretWord:
      if c notin lettersGuessed:
         result.add("_ ")
      else:
         result.add(c)

proc getAvailableLetters(lettersGuessed: seq[char]): string =
   #
   # lettersGuessed: list, what letters have been guessed so far
   # returns: string, comprised of letters that represents what letters have not
   #   yet been guessed.
   #
   result = ""
   const Lower = {'a' .. 'z'}
   for c in Lower:
      if c notin lettersGuessed:
         result.add(c)

proc hangman(secretWord: string) =
   #
   # secretWord: string, the secret word to guess.
   #
   # Starts up an interactive game of Hangman.
   #
   # * At the start of the game, let the user know how many 
   #   letters the secretWord contains.
   #
   # * Ask the user to supply one guess (i.e. letter) per round.
   #
   # * The user should receive feedback immediately after each guess 
   #   about whether their guess appears in the computers word.
   #
   # * After each round, you should also display to the user the 
   #   partially guessed word so far, as well as letters that the 
   #   user has not yet guessed.
   #
   # Follows the other limitations detailed in the problem write-up.
   #

   echo messages[GreetPlayer]

   let n = len(secretWord)
   echo messages[WordLength] % [$n]

   var mistakesMade = 0
   var availableLetters = "abcdefghijklmnopqrstuvwxyz"
   var lettersGuessed: seq[char] = @[]

   while mistakesMade < 8: # player is given 8 guesses
      echo "-".repeat(13)

      let remainingTries = 8 - mistakesMade
      echo messages[RemainingGuesses] % [$remainingTries]
      echo messages[AvailableLetters], availableLetters

      # get input from the player
      let guess = readLineFromStdin(messages[PromptGuess]).toLowerAscii()

      if guess[0] notin Letters:
         echo messages[UnknownInput]
         continue # continue if guess is invalid

      if guess[0] in lettersGuessed:
         echo messages[RepeatedGuess], getGuessedWord(secretWord, lettersGuessed)
         continue # continue when the player has already guessed that letter

      lettersGuessed.add(guess[0]) # add player's guess to the guessed letters

      if guess[0] in secretWord:
         echo messages[GoodGuess], getGuessedWord(secretWord, lettersGuessed)
      else:
         echo messages[WrongGuess], getGuessedWord(secretWord, lettersGuessed)
         inc(mistakesMade) # player loses a guess when he guesses incorrectly

      if isWordGuessed(secretWord, lettersGuessed):
         break # break the loop when the word is found

      availableLetters = getAvailableLetters(lettersGuessed) # update the available letters

   echo "-".repeat(13)
   if isWordGuessed(secretWord, lettersGuessed):
      echo messages[GameSuccess]
   else:
      echo messages[GameFailure] % [$secretWord]

proc main() =
   let secretWord = chooseWord(wordlist).toLowerAscii()
   hangman(secretWord)

when isMainModule:
   main()
