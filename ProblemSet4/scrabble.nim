# The 6.00 Word Game
import rdstdin, strutils, tables, random, algorithm
import utils, funcs

type
   Message* {.pure.} = enum
      PlayerChoice, MenuChoice, EnterWord, NoHand, InvalidCmd, InvalidWord, TerribleError
      CurrentHand, CurrentScore, ScoreComputer, ScoreEndGame, ScoreNoLetters

const
   handSize* = 7

   messages*: array[Message, string] = [
      PlayerChoice: "Enter u to have yourself play, c to have the computer play: ",
      MenuChoice: "Enter n to deal a new hand, r to replay the last hand, or e to end game: ",
      EnterWord: "Enter word, or a . to indicate that you are finished: ",
      NoHand: "You have not played a hand yet. Please play a new hand first!",
      InvalidCmd: "Invalid command.",
      InvalidWord: "Invalid word, please try again.",
      TerribleError: "This is a terrible error! I need to check my own code!",
      CurrentHand: "\nCurrent Hand: ",
      CurrentScore: "$1 earned $2 points. Total: $3 points",
      ScoreComputer: "\nTotal score: $1 points.",
      ScoreEndGame: "\nGoodbye! Total score: $1 points.",
      ScoreNoLetters: "\nRun out of letters. Total score: $1 points."]

proc playHand*(hand: CountTable[char], wordList: seq[string], n: int) =
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
   var hand = hand
   var endGame = false
   # Keep track of the total score
   var totalScore = 0
   # As long as there are still letters left in the hand:
   while calculateHandlen(hand) > 0 and not endGame:
      # Display the hand
      echo messages[CurrentHand], displayHand(hand)
      # Ask user for input
      let word = readLineFromStdin(messages[EnterWord])
      # If the input is a single period:
      if word == ".":
         endGame = true # End the game (break out of the loop)
      # Otherwise (the input is not a single period):
      else:
         # If the word is not valid:
         if not isValidWord(word, hand, wordList):
            # Reject invalid word (print a message followed by a blank line)
            echo messages[InvalidWord]
         # Otherwise (the word is valid):
         else:
            # Tell the user how many points the word earned, and the updated total score,
            # in one line followed by a blank line
            let score = getWordScore(word, n)
            totalScore += score
            echo messages[CurrentScore].format(word, score, totalScore)
            # Update the hand
            hand = updateHand(hand, word)

   # Game is over (user entered a '.' or ran out of letters), so tell user the total score
   if endGame:
      echo messages[ScoreEndGame].format(totalScore)
   else:
      echo messages[ScoreNoLetters].format(totalScore)

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
   var exitGame = false
   while not exitGame:
      let choice = readLineFromStdin(messages[MenuChoice])
      if choice == "n":
         hand = dealHand(handSize)
         playHand(hand, wordList, handSize)
      elif choice == "r":
         if hand.len == 0:
            echo messages[NoHand]
         else:
            playHand(hand, wordList, handSize)
      elif choice != "e":
         echo messages[InvalidCmd]
      else:
         exitGame = true

proc main() {.used.} =
   # Initializes the random number generator
   randomize()
   var wordlist = loadWords()
   # isValidWord calls binarySearch, so wordList needs to be ordered.
   sort(wordList)
   playGame(wordList)

when isMainModule:
   main()
