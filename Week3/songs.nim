import tables, sequtils

# Contains the she_loves_you sequence of strings
include loadWords


proc lyrics_to_frequencies(lyrics: seq[string]): Table[string, int] =
   result = initTable[string, int]()

   for word in lyrics:
      result.mgetOrPut(word, 0) += 1

proc most_common_words(freqs: Table[string, int]): auto =
   var words: seq[string] = @[]
   let
      values = toSeq(freqs.values)
      best = max(values)

   for key in keys(freqs):
      if freqs[key] == best:
         words.add(key)
   return (words, best)

proc words_often(freqs: var Table[string, int], minTimes: int): OrderedTable[seq[string], int] =
   result = initOrderedTable[seq[string], int]()
   var done = false
   while not done:
      let (words, best) = most_common_words(freqs)
      if best >= minTimes:
         result[words] = best
         for word in words:
            del(freqs, word)  #remove word from dictionary
      else:
         done = true


var beatles = lyrics_to_frequencies(she_loves_you)
echo words_often(beatles, 5)

discard """ Output:
{@[you]: 36, @[yeah]: 28, @[she]: 20, @[loves]: 13, @[know]: 11, @[be]: 10, @[and]: 8, @[glad, that, should]: 7, @[love]: 5}
"""
