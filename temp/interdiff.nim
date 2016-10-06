import tables

let
    d1 = {1:30, 2:20, 3:30, 5:80}.toTable()
    d2 = {1:40, 2:50, 3:60, 4:70, 6:90}.toTable()

proc dict_interdiff(d1, d2: Table[int, int]): auto =

    return (intersect, difference)

echo dict_interdiff(d1, d2)
