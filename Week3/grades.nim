import tables

var grades = {"Ana": "B", "John": "A+", "Denise", "Katy": "A"}.toTable

echo grades["John"]

grades["Sylvan"] = "A"

assert grades.hasKey("Sylvan")

echo "Daniel" in grades

del(grades, "Ana")

echo grades

for key, value in pairs(grades):
   echo key, ' ', value
