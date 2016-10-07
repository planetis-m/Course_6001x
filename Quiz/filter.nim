
proc f(i: int): int =
    i + 2
proc g(i: int): bool =
    i > 5

proc applyF_filterG(L: var seq[int], f: proc(i: int): int, g: proc(i: int): bool): int =
    #
    # Assumes L is a list of integers
    # Assume functions f and g are defined for you. 
    # f takes in an integer, applies a function, returns another integer 
    # g takes in an integer, applies a Boolean function, 
    #     returns either True or False
    # Mutates L such that, for each element i originally in L, L contains  
    #     i if g(f(i)) returns True, and no other elements
    # Returns the largest element in the mutated L or -1 if the list is empty
    #

    var L_new: seq[int] = @[]
    for i in L:
        if g(f(i)):
            L_new.add(i)
    L = L_new
    return if len(L) > 0: max(L) else: -1

var L = @[0, -10, 5, 6, -4]
echo applyF_filterG(L, f, g)
echo L
