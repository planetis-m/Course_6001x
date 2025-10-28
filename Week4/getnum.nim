import std/[rdstdin, strutils, syncio]

while true:
   try:
      let inp = readLineFromStdin("Please enter an integer: ")
      let num = parseInt(inp)
      break
   except ValueError:
      echo("Input is not an integer; try again")
echo("Correct input of an integer")
