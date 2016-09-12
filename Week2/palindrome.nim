import strutils

const Lower = {'a' .. 'z'}

proc isPalindrome(s: string): bool =

    proc toChars(s: string): string =
        let s = s.toLower()
        result = ""
        for c in s:
            if c in Lower:
                result.add(c)

    proc isPal(s: string): bool =
        if len(s) <= 1:
            return true
        else:
            return s[0] == s[^1] and isPal(s[1 .. ^2])

    return isPal(toChars(s))

echo isPalindrome("eve")
echo isPalindrome("Able was I, ere I saw Elba")
echo isPalindrome("evabve")
