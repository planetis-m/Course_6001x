
var
    warm: seq[string]
    hot = addr warm

warm = @["red", "yellow", "orange"]

warm.add("pink")
echo hot[]
