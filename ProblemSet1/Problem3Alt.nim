const s = "azcbobobegghakl"

proc longest(a: seq[string]): string =
    result = a[0]
    for i in 1 .. high(a):
        if len(result) < len(a[i]):
            result = a[i]

proc alphBetOrder(s: string): seq[string] =
    result = @[]
    var temp = ""
    var m = 'a'
    for i in s:
        if i < m:
            result.add(temp)
            temp = ""
        m = i
        temp.add(i)

let result = longest alphBetOrder s

echo "Longest substring in alphabetical order is: ", $result
