import oopmacro, algorithm, tables, strutils
include utils

class Message(RootObj):
  var message_text: string
  var valid_words: seq[string]

  proc newMessage(text: string) =
    # text: the message's text
    new(result)
    result.message_text = text
    result.valid_words = loadWords(wordlist_filename)

  proc get_message_text: string =
    result = self.message_text

  proc get_valid_words: seq[string] =
    result = self.valid_words

  proc build_shift_dict(shift: int): Table[char, char] =
    result = initTable[char, char]()
    var
      letters = "abcdefghijklmnopqrstuvwxyz"
      letters_shifted = letters.repeat(2)[shift .. shift + 25]
    letters = letters & letters.toUpperAscii()
    letters_shifted = letters_shifted & letters_shifted.toUpperAscii()

    for i in 0 .. 51:
      result[letters[i]] = letters_shifted[i]

  proc apply_shift(shift: int): string =
    result = ""
    let shift_dictionary = self.build_shift_dict(shift)

    for c in self.message_text:
      if c in Letters:
        let t = shift_dictionary[c]
        result.add t
      else:
        result.add c

class PlaintextMessage(Message):
  var shift: int
  var encrypting_dict: Table[char, char]
  var message_text_encrypted: string

  proc newPlaintextMessage(text: string, shift: int) =
    new(result)
    result.message_text = text
    result.valid_words = loadWords(wordlist_filename)
    result.shift = shift

  proc get_shift: int =
    result = self.shift

  proc get_encrypting_dict: Table[char, char] =
    self.encrypting_dict = self.build_shift_dict(self.shift)
    result = self.encrypting_dict

  proc get_message_text_encrypted: string =
    self.message_text_encrypted = self.apply_shift(self.shift)
    result = self.message_text_encrypted

  proc change_shift(shift: int) =
    self.shift = shift

    self.encrypting_dict = self.build_shift_dict(shift)
    self.message_text_encrypted = self.apply_shift(shift)

class CiphertextMessage(Message):
  proc newCiphertextMessage(text: string) =
    new(result)
    result.message_text = text
    result.valid_words = loadWords(wordlist_filename)

  proc decrypt_message: auto =
    var best_shift = 0
    var best_real_words = 0
    var best_msg = ""

    for s in 0 .. 25:
      let decrypted_text = self.apply_shift(s)
      var real_words: int
      for word in decrypted_text.split():
        if is_word(self.valid_words, word):
          inc(real_words)
      if real_words > best_real_words:
        best_shift = s
        best_real_words = real_words
        best_msg = decrypted_text

    return (best_shift, best_msg)

proc decrypt_story: auto =
  let story = get_story_string()
  let ciphertext = newCiphertextMessage(story)
  return ciphertext.decrypt_message()

echo decrypt_story()
