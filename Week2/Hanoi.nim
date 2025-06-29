import std/syncio

proc echoMove(fr, to: string) {.inline.} =
  echo "move from ", fr, " to ", to

proc towers(n: int, fr, to, spare: string) =
  if n == 1:
    echoMove(fr, to)
  else:
    towers(n - 1, fr, spare, to)
    towers(1, fr, to, spare)
    towers(n - 1, spare, to, fr)

towers(4, "P1", "P2", "P3")
