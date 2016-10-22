# The 6.00 Word Game

import rdstdin, strtabs, strutils, tables

include utils
include rewrites
include funcs

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
    var word: string
    # Keep track of the total score
    var totalScore = 0
    # As long as there are still letters left in the hand:
    while calculateHandlen(hand) > 0:
        # Display the hand
        echo "Current Hand: ", displayHand(hand)

        # Ask user for input
        word = readLineFromStdin("Enter word, or a . to indicate that you are finished: ")

        # If the input is a single period:
        if word == ".":
            # End the game (break out of the loop)
            break

        # Otherwise (the input is not a single period):
        else:
            # If the word is not valid:
            if not isValidWord(word, hand, wordList):
                # Reject invalid word (print a message followed by a blank line)
                echo "Invalid word, please try again."
                echo ""

            # Otherwise (the word is valid):
            else:
                # Tell the user how many points the word earned, and the updated total score, in one line followed by a blank line
                let score = getWordScore(word, n)
                totalScore += score
                echo "$1 earned $2 points. Total: $3 points" % [$word, $score, $totalScore]
                echo ""
                # Update the hand
                hand = updateHand(hand, word)

    # Game is over (user entered a '.' or ran out of letters), so tell user the total score
    if word == ".":
        echo "Goodbye! Total score: $1 points." % [$totalScore]
        echo ""
    else:
        echo "Run out of letters. Total score: $1 points." % [$totalScore]
        echo ""

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
        let choice = readLineFromStdin("Enter n to deal a new hand, r to replay the last hand, or e to end game: ")
        if choice == "n":
            hand = dealHand(hand_size)
            playHand(hand, wordList, hand_size)
        elif choice == "r":
            if len(hand) == 0:
                echo "You have not played a hand yet. Please play a new hand first!"
            else:
                playHand(hand, wordList, hand_size)
        elif choice != "e":
            echo "Invalid command."
        else:
            break

proc main() =
    let wordlist = loadWords()
    playGame(wordList)

when isMainModule:
    main()
