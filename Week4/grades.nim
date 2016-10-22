import tables, math

proc avg(grades: seq[float]): float =
    try:
        return sum(grades) / len(grades).float
    except:
        echo "No grades data"
        return 0.0

proc get_stats(class_list: Table[seq[string], seq[float]]): Table[seq[string], float] =
    result = initTable[seq[string], float]()
    for name, grades in class_list.pairs():
        result.add (name, avg(grades))

let test_grades = {
    @["peter", "parker"]: @[10.0, 5.0, 85.0],
    @["bruce", "wayne"]: @[10.0, 8.0, 74.0],
    @["captain", "america"]: @[8.0, 10.0, 96.0],
    @["deadpool"]: @[]
}.toTable

echo test_grades
echo get_stats(test_grades)
