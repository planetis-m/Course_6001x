import rdstdin, strtabs, strutils, tables
import scrabble

#
#
# Computer chooses a word
#
#
proc compChooseWord(hand: CountTable[char], wordList: seq[string], n: int): string =
    #
    # Given a hand and a wordList, find the word that gives 
    # the maximum value score, and return it.
    #
    # This word should be calculated by considering all the words
    # in the wordList.
    #
    # If no words in the wordList can be made from the hand, return None.
    #
    # hand: dictionary (string -> int)
    # wordList: list (string)
    # n: integer (HAND_SIZE; i.e., hand size required for additional points)
    #
    # returns: string or None
    #
    # Create a new variable to store the maximum score seen so far (initially 0)
    var bestScore = 0
    # Create a new variable to store the best word seen so far (initially None)
    var bestWord: string
    # For each word in the wordList
    for word in wordList:
        # If you can construct the word from your hand
        if isValidWord(word, hand, wordList):
            # find out how much making that word is worth
            let score = getWordScore(word, n)
            # If the score for that word is higher than your best score
            if score > bestScore:
                # update your best score, and best word accordingly
                bestScore = score
                bestWord = word
    # return the best word you found.
    return bestWord

#
# Computer plays a hand
#
proc compPlayHand(hand: CountTable[char], wordList: seq[string], n: int) =
    #
    # Allows the computer to play the given hand, following the same procedure
    # as playHand, except instead of the user choosing a word, the computer 
    # chooses it.
    #
    # 1) The hand is displayed.
    # 2) The computer chooses a word.
    # 3) After every valid word: the word and the score for that word is 
    # displayed, the remaining letters in the hand are displayed, and the 
    # computer chooses another word.
    # 4)  The sum of the word scores is displayed when the hand finishes.
    # 5)  The hand finishes when the computer has exhausted its possible
    # choices (i.e. compChooseWord returns None).
    #
    # hand: dictionary (string -> int)
    # wordList: list (string)
    # n: integer (HAND_SIZE; i.e., hand size required for additional points)
    #
    var hand = hand
    # Keep track of the total score
    var totalScore = 0
    # As long as there are still letters left in the hand:
    while calculateHandlen(hand) > 0:
        # Display the hand
        echo "Current Hand: ", displayHand(hand)
        # computer's word
        let word = compChooseWord(hand, wordList, n)
        # If the input is a single period:
        if isNil(word):
            # End the game (break out of the loop)
            break

        # Otherwise (the input is not a single period):
        else:
            # If the word is not valid:
            if not isValidWord(word, hand, wordList):
                echo "This is a terrible error! I need to check my own code!"
                break
            # Otherwise (the word is valid):
            else:
                # Tell the user how many points the word earned, and the updated total score 
                let score = getWordScore(word, n)
                totalScore += score
                echo "$1 earned $2 points. Total: $3 points" % [$word, $score, $totalScore]
                echo ""
                # Update hand and show the updated hand to the user
                hand = updateHand(hand, word)
    # Game is over (user entered a '.' or ran out of letters), so tell user the total score
    echo "Total score: $1 points." % [$totalScore]

#
# Problem #6: Playing a game
#
proc playGame(wordList: seq[string]) =
    #
    # Allow the user to play an arbitrary number of hands.
    #
    # 1) Asks the user to input 'n' or 'r' or 'e'.
    #     * If the user inputs 'e', immediately exit the game.
    #     * If the user inputs anything that's not 'n', 'r', or 'e', keep asking them again.
    #
    # 2) Asks the user to input a 'u' or a 'c'.
    #     * If the user inputs anything that's not 'c' or 'u', keep asking them again.
    #
    # 3) Switch functionality based on the above choices:
    #     * If the user inputted 'n', play a new (random) hand.
    #     * Else, if the user inputted 'r', play the last hand again.
    #
    #     * If the user inputted 'u', let the user play the game
    #       with the selected hand, using playHand.
    #     * If the user inputted 'c', let the computer play the 
    #       game with the selected hand, using compPlayHand.
    #
    # 4) After the computer or user has played the hand, repeat from step 1
    #
    # wordList: list (string)
    var hand: CountTable[char]

    proc playerChoice() =
        var player: string
        while player != "u" or player != "c":
            player = readLineFromStdin("Enter u to have yourself play, c to have the computer play: ")
            if player == "u":
                playHand(hand, wordList, hand_size)
                break
            elif player == "c":
                compPlayHand(hand, wordList, hand_size)
                break
            else:
                echo "Invalid command."

    while true:
        let choice = readLineFromStdin("Enter n to deal a new hand, r to replay the last hand, or e to end game: ")
        if choice == "n":
            hand = dealHand(hand_size)
            playerChoice()
        elif choice == "r":
            if len(hand) == 0:
                echo "You have not played a hand yet. Please play a new hand first!"
            else:
                playerChoice()
        elif choice != "e":
            echo "Invalid command."
        else:
            break

#
# Build data structures used for entire session and play game
#
proc main() =
    let wordlist = loadWords()
    playGame(wordList)

when isMainModule:
    main()
