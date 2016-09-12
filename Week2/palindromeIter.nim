import strutils

const Lower = {'a' .. 'z'}

proc isPalindrome(s: string): bool =

    proc toChars(s: string): string =
        let s = s.toLower()
        result = ""
        for c in s:
            if c in Lower:
                result.add(c)

    proc reversed(s: string): string =
        result = newString(s.len)
        for i, c in s:
            result[s.high - i] = c

    let s = s.toChars
    if s == s.reversed:
        return true
    return false

echo isPalindrome("eve")
echo isPalindrome("Able was I, ere I saw Elba")
echo isPalindrome("evabve")
