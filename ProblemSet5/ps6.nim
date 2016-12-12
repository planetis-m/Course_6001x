include utils

type
  Message = object
    text: string
    validWords: seq[string]

proc newMessage(text: string): Message =
  result.text = text
  result.validWords = loadWords(wordlist_filename)

proc getMessageText(m: Message): string =
  result = m.text

proc getValidWords(m: Message): seq[string] =
  result = m.validWords










