import tables, sequtils

# Contains the she_loves_you sequence of strings
include loadWords

proc lyrics_to_frequencies(lyrics: seq[string]): CountTable[string] =
    result = initCountTable[string]()

    for word in lyrics:
        result.inc(word)

# proc most_common_words(freqs: CountTable[string]): tuple[w: seq[string], b: int] =
#     let
#         values = toSeq(freqs.values)
#         best = max(values)
#     var words: seq[string] = @[]
#     echo best
#     for key in keys(freqs):
#         if freqs[key] == best:
#             words.add(key)
# 
#     return (words, best)
# 
# proc words_often(freqs: var CountTable[string], minTimes: int): seq[tuple[w: seq[string], b: int]] =
#     result = @[]
#     var done = false
#     while not done:
#         var temp = most_common_words(freqs)
#         if temp.b >= minTimes:
#             result.add(temp)
#             for w in temp.w:
#                 del(freqs, w)  #remove word from dictionary
#         else:
#             done = true

proc words_often(freqs: var CountTable[string], minTimes: int): seq[tuple[w: seq[string], b: int]] =
    result = @[]

    freqs.sort()

    var temp: tuple[w: seq[string], b: int]

    var words: seq[string] = @[]
    var previous = largest(freqs).val

    for key, val in pairs(freqs):
        if val >= minTimes:
            if val != previous:
                words = @[key]
            else:
                words.add(key)

            previous = val
            temp = (words, previous)
            result.add(temp)

var beatles = lyrics_to_frequencies(she_loves_you)
echo words_often(beatles, 5)

discard """ Output:
[(['you'], 36), (['yeah'], 28), (['she'], 20), (['loves'], 13), (['know'], 11), (['be'], 10), (['and'], 8), (['that', 'glad', 'should'], 7), (['love'], 5)]
"""
