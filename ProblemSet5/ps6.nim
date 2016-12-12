include utils

type
  Message = object
    messageText: string
    validWords: seq[string]

proc getValidWords(m: Message): seq[string] =
  result = m.validWords

proc getMessageText(m: Message): string =
  result = m.messageText









let word_list = loadWords(wordlist_filename)
