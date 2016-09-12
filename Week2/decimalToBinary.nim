

proc binary(num: int): string =
    result = ""
    var num = num
    var isNeg: bool
    if num < 0:
        isNeg = true
        num = abs(num)
    else:
        isNeg = false
    if num == 0:
        result = "0"
    while num > 0:
        result = $(num mod 2) & result
        num = num div 2
    if isNeg:
        result = "-" & result

echo binary(19)
