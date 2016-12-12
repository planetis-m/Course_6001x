import os, strutils

const
  wordlist_filename = "words.txt"
  Punctuation = {'\x21'..'\x2F', '\x3A'..'\x40', '\x5B'..'\x60', '\x7B'..'\x7E'}

template withFile(f, fn, actions: untyped): untyped =
  var f: File
  if open(f, fn):
    try:
      actions
    finally:
      close(f)
  else:
    quit("cannot open: " & fn)

proc loadWords(filename: string): seq[string] =
  #
  # filename: the name of the file containing
  # the list of words to load
  #
  # Returns: a list of valid words. Words are strings of lowercase letters.
  #
  # Depending on the size of the word list, this function may
  # take a while to finish.
  #
  echo "Loading word list from file..."
  # inFile: file
  withFile(inFile, filename):
    # line: string
    let line = in_file.readLine()
    result = line.split()
  echo "  ", len(result), " words loaded."

proc isWord(wordlist: seq[string], word: string): bool =
  #
  # Determines if word is a valid word, ignoring
  # capitalization and punctuation
  #
  # wordlist: list of words in the dictionary.
  # word: a possible word.
  #
  # Returns: true if word is in word_list, false otherwise
  #
  # Example:
  # >>> is_word(wordlist, 'bat') returns
  # true
  # >>> is_word(wordlist, 'asdf') returns
  # false
  #
  var
    word = word.toLowerAscii()
  word = word.strip(chars = Punctuation + Whitespace)
  return word in wordlist

proc getStory(): string =
  #
  # Returns: a joke in encrypted text.
  #
  result = string(readFile("story.txt"))
