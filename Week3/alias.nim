var warm: seq[string]
warm = @["red", "yellow", "orange"]
shallow warm

var hot = warm

warm[2] = "red"
warm.add("pink")

echo hot
