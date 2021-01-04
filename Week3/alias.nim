
type
   Warm = ref seq[string]

var w: Warm
new(w)
w[] = @["red", "yellow", "orange"]
let h = w

h[].add("pink")

echo cast[ByteAddress](w)
echo cast[ByteAddress](h)

echo w[]

