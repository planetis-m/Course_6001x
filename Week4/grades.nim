import std/[math, syncio]
{.floatChecks: on.}

proc avg(grades: seq[float]): float =
   try:
      result = sum(grades) / len(grades).float
   except FloatInvalidOpError:
      echo("No grades data")
      result = 0.0

# proc avg(grades: seq[float]): float =
#    assert len(grades) != 0, "No grades data"
#    sum(grades) / len(grades).float

proc getStats(classList: seq[(seq[string], seq[float])]): auto =
   result = newSeq[(seq[string], seq[float], float)]()
   for name, grades in items(classList):
      result.add (name, grades, avg(grades))

let testGrades = @{
   @["peter", "parker"]: @[10.0, 5.0, 85.0],
   @["bruce", "wayne"]: @[10.0, 8.0, 74.0],
   @["captain", "america"]: @[8.0, 10.0, 96.0],
   @["deadpool"]: @[]
}

echo testGrades
echo getStats(testGrades)
