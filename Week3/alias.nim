type List = ref object
    warm: seq[string]

var hot: List
new hot

hot.warm = @["red", "yellow", "orange"]
hot.warm.add("pink")

echo hot[].warm
