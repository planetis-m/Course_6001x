
type
   Warm = ref seq[string]

var w: owned Warm
new(w)
w[] = @["red", "yellow", "orange"]
let h = w

h[].add("pink")

echo cast[ByteAddress](w)
echo cast[ByteAddress](h)

echo w[]

