import tables

# Contains the she_loves_you sequence of strings
include loadWords

proc lyrics_to_frequencies(lyrics: seq[string]): Table[string, int] =
    result = initTable[string, int]()

    for word in lyrics:
        if word in result:
            result[word] += 1
        else:
            result[word] = 1

proc values[A, B](t: Table[A, B]): seq[B] =
    result = @[]

    for key in keys(t):
        result.add(t[key])

proc most_common_words(freqs: Table[string, int]): tuple[w: seq[string], b: int] =
    let
        values = values(freqs)
        best = max(values)
    var words: seq[string] = @[]
    echo best
    for key in keys(freqs):
        if freqs[key] == best:
            words.add(key)

    return (words, best)

proc words_often(freqs: var Table[string, int], minTimes: int): seq[tuple[w: seq[string], b: int]] =
    result = @[]
    var done = false
    while not done:
        var temp = most_common_words(freqs)
        if temp.b >= minTimes:
            result.add(temp)
            for w in temp.w:
                del(freqs, w)  #remove word from dictionary
        else:
            done = true


var beatles = lyrics_to_frequencies(she_loves_you)
echo words_often(beatles, 5)

discard """ Output:
[(['you'], 36), (['yeah'], 28), (['she'], 20), (['loves'], 13), (['know'], 11), (['be'], 10), (['and'], 8), (['that', 'glad', 'should'], 7), (['love'], 5)]
"""
