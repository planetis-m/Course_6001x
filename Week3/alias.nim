
block:
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

block:
   var w = @["red", "yellow", "orange"]
   shallow(w)
   var h = w # or shallowCopy(w)

   h.add("pink") # one must not modify the copy
   echo h
   echo w
