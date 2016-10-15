import tables

# Contains the she_loves_you sequence of strings
include loadWords

proc lyrics_to_frequencies(lyrics: seq[string]): CountTable[string] =
    result = initCountTable[string]()

    for word in lyrics:
        result.inc(word)

proc common_words(freqs: CountTable[string], count: int): auto =
    var words: seq[string] = @[]
    for key, val in pairs(freqs):
        if val == count:
            words.add(key)
    return (words, count)

proc words_often(freqs: var CountTable[string], minTimes: int): OrderedTable[seq[string], int] =
    result = initOrderedTable[seq[string], int]()

    # Destructive, can only iterate through freqs
    freqs.sort()

    var prev = 0
    for key, val in pairs(freqs):
        if val >= minTimes and val != prev:
            let (words, best) = common_words(freqs, val)
            prev = val
            result.add(words, best)

var beatles = lyrics_to_frequencies(she_loves_you)
echo words_often(beatles, 5)

discard """ Output:
{@[you]: 36, @[yeah]: 28, @[she]: 20, @[loves]: 13, @[know]: 11, @[be]: 10, @[and]: 8, @[glad, that, should]: 7, @[love]: 5}
"""
