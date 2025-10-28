import std/[tables, syncio]
import loadwords

proc lyricsToFrequencies(lyrics: seq[string]): CountTable[string] =
  for word in lyrics.items:
    result.inc(word)

proc mostCommonWords(freqs: CountTable[string]): (seq[string], int) =
  var values: seq[int]
  for value in values(freqs):
    values.add(value)
  let best = max(values)
  var words: seq[string]
  for (key, value) in pairs(freqs):
    if value == best:
      words.add(key)
  (words, best)

proc wordsOften(freqs: var CountTable[string]; minTimes: int): OrderedTable[
      seq[string], int] =
  var done = false
  while not done:
    let (words, best) = mostCommonWords(freqs)
    if best >= minTimes:
      result[words] = best
      for word in words:
        freqs.del(word) # remove word from dictionary
    else:
      done = true

let sheLovesYou = loadWords()
var beatles = lyricsToFrequencies(sheLovesYou)
echo wordsOften(beatles, 5)

# Output:
# {@[you]: 36, @[yeah]: 28, @[she]: 20, @[loves]: 13, @[know]: 11, @[be]: 10, @[and]: 8, @[glad, that, should]: 7, @[love]: 5}
