import os, strutils

const lyrics_filename = "lyrics.txt"

proc load_words(): seq[string] =
    result = @[]

    var inFile = open(lyrics_filename)
    for line in lines(inFile):
        result.add(line.split({' ', ','}))

    inFile.close()

let she_loves_you = load_words()

echo she_loves_you
