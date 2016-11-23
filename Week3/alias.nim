type
  Warm = ref WarmObj
  WarmObj = object
    colors: seq[string]

var
  w = Warm(colors: @["red", "yellow", "orange"])
  h = w

h.colors.add("pink")

echo w.colors
echo h.colors
