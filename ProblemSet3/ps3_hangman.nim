# Hangman game
#
import random, rdstdin, strutils

type
   Message {.pure.} = enum
      GreetPlayer, WordLength, RemainingGuesses, AvailableLetters, PromptGuess,
      GoodGuess, WrongGuess, UnknownInput, RepeatedGuess, GameSuccess, GameFailure

const
   wordlistFilename = "words.txt"

   messages: array[Message, string] = [
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
      GameFailure: "Sorry, you ran out of guesses. The word was $1."]

# -----------------------------------
# Helper code

proc loadWords(): seq[string] =
   # Returns a list of valid words. Words are strings of lowercase letters.
   #
   # Depending on the size of the word list, this function may
   # take a while to finish.
   let inFile = open(wordlistFilename)
   try:
      echo "Loading word list from file..."
      let line = inFile.readLine()
      result = line.split()
      echo "  ", len(result), " words loaded."
   finally:
      # Close the file
      inFile.close()

proc chooseWord(wordlist: seq[string]): string =
   # wordlist (list): list of words (strings)
   #
   # Returns a word from wordlist at random
   result = sample(wordlist)

# end of helper code
# -----------------------------------

proc isWordGuessed(secretWord: string, lettersGuessed: set[char]): bool =
   # secretWord: string, the word the user is guessing
   # lettersGuessed: list, what letters have been guessed so far
   # returns: boolean, true if all the letters of secretWord are in lettersGuessed;
   #   false otherwise
   result = true
   for c in secretWord:
      if c notin lettersGuessed:
         return false

proc getGuessedWord(secretWord: string, lettersGuessed: set[char]): string =
   # secretWord: string, the word the user is guessing
   # lettersGuessed: list, what letters have been guessed so far
   # returns: string, comprised of letters and underscores that represents
   #   what letters in secretWord have been guessed so far.
   result = ""
   for c in secretWord:
      if c notin lettersGuessed:
         result.add("_ ")
      else:
         result.add(c)

proc getAvailableLetters(lettersGuessed: set[char]): string =
   # lettersGuessed: list, what letters have been guessed so far
   # returns: string, comprised of letters that represents what letters have not
   #   yet been guessed.
   result = ""
   const Lower = {'a' .. 'z'}
   for c in Lower:
      if c notin lettersGuessed:
         result.add(c)

proc hangman(secretWord: string) =
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
   echo messages[GreetPlayer]

   let n = len(secretWord)
   echo messages[WordLength].format(n)

   var mistakesMade = 0
   var availableLetters = "abcdefghijklmnopqrstuvwxyz"
   var lettersGuessed: set[char]
   var wordGuessed = false

   while mistakesMade < 8 and not wordGuessed: # player is given 8 guesses
      echo "-".repeat(13)

      let remainingTries = 8 - mistakesMade
      echo messages[RemainingGuesses].format(remainingTries)
      echo messages[AvailableLetters], availableLetters

      # get input from the player
      let input = readLineFromStdin(messages[PromptGuess])
      let guess = input[0].toLowerAscii()

      if guess notin Letters:
         echo messages[UnknownInput]
         # continue if guess is invalid
      elif guess in lettersGuessed:
         echo messages[RepeatedGuess], getGuessedWord(secretWord, lettersGuessed)
         # continue when the player has already guessed that letter
      else:
         lettersGuessed.incl(guess) # add player's guess to the guessed letters
         availableLetters = getAvailableLetters(lettersGuessed) # update the available letters

         if guess in secretWord:
            echo messages[GoodGuess], getGuessedWord(secretWord, lettersGuessed)
            # break the loop when the word is found
            wordGuessed = isWordGuessed(secretWord, lettersGuessed)
         else:
            echo messages[WrongGuess], getGuessedWord(secretWord, lettersGuessed)
            mistakesMade.inc # player loses a guess when he guesses incorrectly

   echo "-".repeat(13)
   if wordGuessed:
      echo messages[GameSuccess]
   else:
      echo messages[GameFailure].format(secretWord)

proc main() =
   # Initializes the random number generator
   randomize()
   # Load the list of words into the variable wordlist
   let wordlist = loadWords()
   let secretWord = chooseWord(wordlist).toLowerAscii()
   hangman(secretWord)

main()
