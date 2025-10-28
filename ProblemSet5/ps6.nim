import std/[tables, strutils, syncio]
include utils

type
   Message = ref object of RootObj
      message_text: string
      valid_words: seq[string]

proc newMessage(text: string): Message =
   new(result)
   result.message_text = text
   result.valid_words = loadWords(wordlist_filename)

proc get_message_text(self: Message): string =
   result = self.message_text

proc get_valid_words(self: Message): seq[string] =
   result = self.valid_words

proc build_shift_dict(self: Message; shift: int): Table[char, char] =
   #
   # Creates a dictionary that can be used to apply a cipher to a letter.
   # The dictionary maps every uppercase and lowercase letter to a
   # character shifted down the alphabet by the input shift. The dictionary
   # should have 52 keys of all the uppercase letters and all the lowercase
   # letters only.
   #
   # shift (integer): the amount by which to shift every letter of the
   # alphabet. 0 <= shift < 26
   # Returns: a dictionary mapping a letter (string) to
   #           another letter (string).
   #
   result = initTable[char, char]()
   var
      letters = "abcdefghijklmnopqrstuvwxyz"
      letters_shifted = letters.repeat(2)[shift .. shift + 25]
   letters.add letters.toUpperAscii()
   letters_shifted.add letters_shifted.toUpperAscii()
   for i in 0 .. 51:
      result[letters[i]] = letters_shifted[i]

proc apply_shift(self: Message; shift: int): string =
   #
   # Applies the Caesar Cipher to self.message_text with the input shift.
   # Creates a new string that is self.message_text shifted down the
   # alphabet by some number of characters determined by the input shift
   #
   # shift (integer): the shift with which to encrypt the message.
   # 0 <= shift < 26
   # Returns: the message text (string) in which every character is shifted
   #       down the alphabet by the input shift
   #
   result = ""
   let shift_dictionary = self.build_shift_dict(shift)
   for c in self.message_text:
      if c in Letters:
         let t = shift_dictionary[c]
         result.add t
      else:
         result.add c


type
   PlaintextMessage = ref object of Message
      shift: int
      encrypting_dict: Table[char, char]
      message_text_encrypted: string

proc newPlaintextMessage(text: string; shift: int): PlaintextMessage =
   new(result)
   result.message_text = text
   result.valid_words = loadWords(wordlist_filename)
   result.shift = shift

proc get_shift(self: PlaintextMessage): int =
   result = self.shift

proc get_encrypting_dict(self: PlaintextMessage): Table[char, char] =
   self.encrypting_dict = self.build_shift_dict(self.shift)
   result = self.encrypting_dict

proc get_message_text_encrypted(self: PlaintextMessage): string =
   self.message_text_encrypted = self.apply_shift(self.shift)
   result = self.message_text_encrypted

proc change_shift(self: PlaintextMessage; shift: int) =
   #
   # Changes self.shift of the PlaintextMessage and updates other
   # attributes determined by shift (ie. self.encrypting_dict and
   # message_text_encrypted).
   #
   # shift (integer): the new shift that should be associated with this message.
   # 0 <= shift < 26
   # Returns: nothing
   #
   self.shift = shift
   self.encrypting_dict = self.build_shift_dict(shift)
   self.message_text_encrypted = self.apply_shift(shift)


type
   CiphertextMessage = ref object of Message

proc newCiphertextMessage(text: string): CiphertextMessage =
   new(result)
   result.message_text = text
   result.valid_words = loadWords(wordlist_filename)

proc decrypt_message(self: CiphertextMessage): (int, string) =
   #
   # Decrypt self.message_text by trying every possible shift value
   # and find the "best" one. We will define "best" as the shift that
   # creates the maximum number of real words when we use apply_shift(shift)
   # on the message text. If s is the original shift value used to encrypt
   # the message, then we would expect 26 - s to be the best shift value
   # for decrypting it.
   # Note: if multiple shifts are  equally good such that they all create
   # the maximum number of you may choose any of those shifts (and their
   # corresponding decrypted messages) to return
   # Returns: a tuple of the best shift value used to decrypt the message
   # and the decrypted message text using that shift value
   #
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
   #   return ciphertext.apply_shift(16)

echo decrypt_story()
