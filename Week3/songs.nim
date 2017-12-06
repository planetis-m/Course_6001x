import tables

# Contains the she_loves_you sequence of strings
include loadWords

proc lyricsToFrequencies(lyrics: seq[string]): Table[string, int] =
   result = initTable[string, int]()
   for word in lyrics:
      result.mgetOrPut(word, 0) += 1

proc mostCommonWords(freqs: Table[string, int]): auto =
   var values: seq[int] = @[]
   for value in values(freqs):
      values.add(value)
   let best = max(values)
   var words: seq[string] = @[]
   for key in keys(freqs):
      if freqs[key] == best:
         words.add(key)
   (words, best)

proc wordsOften(freqs: var Table[string, int]; minTimes: int): OrderedTable[seq[string], int] =
   result = initOrderedTable[seq[string], int]()
   var done = false
   while not done:
      let (words, best) = mostCommonWords(freqs)
      if best >= minTimes:
         result[words] = best
         for word in words:
            del(freqs, word)  #remove word from dictionary
      else:
         done = true


var beatles = lyricsToFrequencies(she_loves_you)
echo wordsOften(beatles, 5)

discard """ Output:
{@[you]: 36, @[yeah]: 28, @[she]: 20, @[loves]: 13, @[know]: 11, @[be]: 10, @[and]: 8, @[glad, that, should]: 7, @[love]: 5}
"""
