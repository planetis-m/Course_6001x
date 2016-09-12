
proc echoMove(fr, to: string) {.inline.} =
    echo "move from ", fr, " to ", to

proc Towers(n: int, fr, to, spare: string) =
    if n == 1:
        echoMove(fr, to)
    else:
        Towers(n - 1, fr, spare, to)
        Towers(1, fr, to, spare)
        Towers(n - 1, spare, to, fr)

Towers(4, "P1", "P2", "P3")
