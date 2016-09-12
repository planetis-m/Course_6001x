import times, strutils, random

proc randStr(size: int): string =
    result = ""
    # English lower-case letters are 25
    # but random returns in range 0..max-1
    for i in 0 .. size - 1:
        let x = chr(random(26) + 97)
        result.add(x)

let s = randStr(1_000_000)
let key = "bob"

proc find(s, key: string): int =
    let
        m = len(key)
        n = len(s)

    var a: array[char, int]
    for i in 0..0xff: a[chr(i)] = m + 1
    for i in 0..m - 1: a[key[i]] = m - i

    var i = 0
    while i <= n - m:
        block match:
            for k in 0 .. m - 1:
                #echo i + k, s[i + k], key[k]
                if s[i + k] != key[k]:
                    break match
            inc(result)
        inc(i, a[s[i + m]])

let start = cpuTime()
let result = find(s, key)
let duration = cpuTime() - start

let timeStr = formatFloat(duration * 1000, ffDecimal, precision = 3)

echo "Number of times bob occurs is: ", $result, ". Found in ", timeStr, " ms."
