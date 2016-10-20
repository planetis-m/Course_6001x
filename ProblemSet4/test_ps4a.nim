import tables, strutils
import ps4a

#
# Test code
# You don't need to understand how this test code works (but feel free to look it over!)

# To run these tests, simply run this file (open up in your IDE, then run the file as normal)

proc test_getWordScore() =
    #
    # Unit test for getWordScore
    #
    var failure = false
    # dictionary of words and scores
    let words = {("", 7):0, ("it", 7):4, ("was", 7):18, ("scored", 7):54, ("waybill", 7):155, ("outgnaw", 7):127, ("fork", 7):44, ("fork", 4):94}.toTable
    for word, n in words.keys():
        let score = getWordScore(word, n)
        if score != words[(word, n)]:
            echo "FAILURE: test_getWordScore()"
            echo "\tExpected ", $words[(word, n)], " points but got '", $score, "' for word '", $word, "', n=", n
            failure = true
    if not failure:
        echo "SUCCESS: test_getWordScore()"

# end of test_getWordScore


proc test_updateHand() =
    #
    # Unit test for updateHand
    #
    # test 1
    block test1:
        let handOrig = {'a':1, 'q':1, 'l':2, 'm':1, 'u':1, 'i':1}.toCountTable
        let handCopy = handOrig
        let word = "quail"

        let hand2 = updateHand(handCopy, word)
        let expectedHand = {'l':1, 'm':1}.toCountTable
        if hand2 != expectedHand:
            echo "FAILURE: test_updateHand('", $word, "', ", $handOrig, ")"
            echo "\tReturned: ", $hand2, "\n\t-- but expected: ", $expectedHand

            return # exit function
        if handCopy != handOrig:
            echo "FAILURE: test_updateHand('", $word, "', ", $handOrig, ")"
            echo "\tOriginal hand was ", $handOrig
            echo "\tbut implementation of updateHand mutated the original hand!"
            echo "\tNow the hand looks like this: ", $handCopy

            return # exit function

    # test 2
    block test2:
        let handOrig = {'e':1, 'v':2, 'n':1, 'i':1, 'l':2}.toCountTable
        let handCopy = handOrig
        let word = "evil"

        let hand2 = updateHand(handCopy, word)
        let expectedHand = {'v':1, 'n':1, 'l':1}.toCountTable
        if hand2 != expectedHand:
            echo "FAILURE: test_updateHand('", $word, "', ", $handOrig, ")"
            echo "\tReturned: ", $hand2, "\n\t-- but expected: ", $expectedHand

            return # exit function

        if handCopy != handOrig:
            echo "FAILURE: test_updateHand('", $word, "', ", $handOrig, ")"
            echo "\tOriginal hand was ", $handOrig
            echo "\tbut implementation of updateHand mutated the original hand!"
            echo "\tNow the hand looks like this: ", $handCopy

            return # exit function

    # test 3
    block test3:
        let handOrig = {'h': 1, 'e': 1, 'l': 2, 'o': 1}.toCountTable
        let handCopy = handOrig
        let word = "hello"

        let hand2 = updateHand(handCopy, word)
        let expectedHand = initCountTable[char]()
        if hand2 != expectedHand:
            echo "FAILURE: test_updateHand('", $word, "', ", $handOrig, ")"
            echo "\tReturned: ", $hand2, "\n\t-- but expected: ", $expectedHand

            return # exit function

        if handCopy != handOrig:
            echo "FAILURE: test_updateHand('", $word, "', ", $handOrig, ")"
            echo "\tOriginal hand was ", $handOrig
            echo "\tbut implementation of updateHand mutated the original hand!"
            echo "\tNow the hand looks like this: ", $handCopy

            return # exit function

    echo "SUCCESS: test_updateHand()"

# end of test_updateHand

proc test_isValidWord(wordList: seq[string]) =
    #
    # Unit test for isValidWord
    #
    var failure = false
    # test 1
    block test1:
        let word = "hello"
        let handOrig = getFrequencyDict(word)
        let handCopy = handOrig

        if not isValidWord(word, handCopy, wordList):
            echo "FAILURE: test_isValidWord()"
            echo "\tExpected true, but got false for word: '", $word, "' and hand: ", $handOrig

            failure = true

        # Test a second time to see if wordList or hand has been modified
        if not isValidWord(word, handCopy, wordList):
            echo "FAILURE: test_isValidWord()"

            if handCopy != handOrig:
                echo "\tTesting word ", $word, " for a second time - be sure you're not modifying hand."
                echo "\tAt this point, hand ought to be ", $handOrig, " but it is ", $handCopy

            else:
                echo "\tTesting word ", $word, " for a second time - have you modified wordList?"
                let wordInWL = word in wordList
                echo "The word ", $word, " should be in wordList - is it? ", $wordInWL

            echo "\tExpected true, but got false for word: '", $word, "' and hand: ", $handCopy

            failure = true

    # test 2
    block test2:
        let hand = {'r': 1, 'a': 3, 'p': 2, 'e': 1, 't': 1, 'u':1}.toCountTable
        let word = "rapture"

        if  isValidWord(word, hand, wordList):
            echo "FAILURE: test_isValidWord()"
            echo "\tExpected false, but got true for word: '", $word, "' and hand: ", $hand

            failure = true

    # test 3
    block test3:
        let hand = {'n': 1, 'h': 1, 'o': 1, 'y': 1, 'd':1, 'w':1, 'e': 2}.toCountTable
        let word = "honey"

        if  not isValidWord(word, hand, wordList):
            echo "FAILURE: test_isValidWord()"
            echo "\tExpected true, but got false for word: '", $word, "' and hand: ", $hand

            failure = true

    # test 4
    block test4:
        let hand = {'r': 1, 'a': 3, 'p': 2, 't': 1, 'u':2}.toCountTable
        let word = "honey"

        if  isValidWord(word, hand, wordList):
            echo "FAILURE: test_isValidWord()"
            echo "\tExpected false, but got true for word: '", $word, "' and hand: ", $hand

            failure = true

    # test 5
    block test5:
        let hand = {'e':1, 'v':2, 'n':1, 'i':1, 'l':2}.toCountTable
        let word = "evil"

        if  not isValidWord(word, hand, wordList):
            echo "FAILURE: test_isValidWord()"
            echo "\tExpected true, but got false for word: '", $word, "' and hand: ", $hand

            failure = true

    # test 6
    block test6:
        let hand = {'e':1, 'v':2, 'n':1, 'i':1, 'l':2}.toCountTable
        let word = "even"

        if  isValidWord(word, hand, wordList):
            echo "FAILURE: test_isValidWord()"
            echo "\tExpected false, but got true for word: '", $word, "' and hand: ", $hand
            echo "\t(If this is the only failure, make sure isValidWord() isn't mutating its inputs)"

            failure = true

    if not failure:
        echo "SUCCESS: test_isValidWord()"


let wordList = loadWords()
echo "-".repeat(40)
echo "Testing getWordScore..."
test_getWordScore()
echo "-".repeat(40)
echo "Testing updateHand..."
test_updateHand()
echo "-".repeat(40)
echo "Testing isValidWord..."
test_isValidWord(wordList)
echo "-".repeat(40)
echo "All done!"
