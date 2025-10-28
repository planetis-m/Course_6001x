import std/[rdstdin, strtabs, syncio]

const
  msg1 = "Please think of a number between 0 and 100!"
  msg2 = "Enter h to indicate the guess is too high. Enter l to indicate the guess is too low. Enter c to indicate I guessed correctly. "
  msg3 = "Is your secret number $1?"
  msg4 = "Game over. Your secret number was: $1"
  msg5 = "Sorry, I did not understand your input."

echo msg1

var
  high = 100
  low = 0
  guess: int

while true:
  guess = (high + low) div 2
  echo msg3 % [$guess]

  let fdbk = readLineFromStdin(msg2)
  if fdbk == "l":
    low = guess
  elif fdbk == "h":
    high = guess
  elif fdbk == "c":
    break
  else:
    echo msg5
    continue

echo msg4 % [$guess]
