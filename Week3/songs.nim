import tables

# Contains the she_loves_you sequence of strings
include loadWords

proc lyrics_to_frequencies(lyrics: seq[string]): CountTable[string] =
    result = initCountTable[string]()

    for word in lyrics:
        result.inc(word)

# proc most_common_words(freqs: CountTable[string]): tuple[w: seq[string], b: int] =


proc words_often(freqs: var CountTable[string], minTimes: int): OrderedTable[seq[string], int] =
    result = initOrderedTable[seq[string], int]()

    var
        words: seq[string] = @[]
        best = largest(freqs).val

    # Destructive, can only iterate through freqs
    freqs.sort()

    for key, val in pairs(freqs):
        if val >= minTimes - 1:
            if val != best:
                result[words] = best
                words = @[key]
                best = val
            else:
                words.add(key)

var beatles = lyrics_to_frequencies(she_loves_you)
echo words_often(beatles, 5)

discard """ Output:
{@[you]: 36, @[yeah]: 28, @[she]: 20, @[loves]: 13, @[know]: 11, @[be]: 10, @[and]: 8, @[glad, that, should]: 7, @[love]: 5}
"""
