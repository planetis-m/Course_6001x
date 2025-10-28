import std/[algorithm, tables, strutils, assertions, syncio]

type
   StudentKind = enum
      Grad, Ug
   Student = object
      name: string
      idNum: int # a unique ID number
      case kind: StudentKind
      of Ug:
         year: int
      else: discard

var nextIdNum = 0 # next ID number to assign

# ---------------------
# Student type routines
# ---------------------

template studentImpl() =
   result.name = name
   result.idNum = nextIdNum
   inc(nextIdNum)

proc initGrad(name: string): Student =
   studentImpl()

proc initUG(name: string, classYear: int): Student =
   studentImpl()
   result.kind = Ug
   result.year = classYear

proc getIdNum(self: Student): int =
   self.idNum

# sorting Students uses their ID number, not name!
proc cmp(self, other: Student): int =
   self.idNum - other.idNum

proc ` == `(self, other: Student): bool =
   self.idNum == other.idNum

proc `$`(self: Student): string =
   self.name

proc getClass(self: Student): int =
   assert self.kind == Ug
   self.year

type
   Grades = object ## A mapping from students to a list of grades
      students: seq[Student]         ## list of Student objects
      grades: Table[int, seq[float]] ## maps idNum -> list of grades
      isSorted: bool                 ## true if self.students is sorted

# -------------------
# Grade type routines
# -------------------

proc initGrades(): Grades =
   ## Create empty grade book
   result.isSorted = true

proc addStudent(self: var Grades, student: Student) =
   ## Assumes: student is of type Student
   ## Add student to the grade book
   if student in self.students:
      raise newException(ValueError, "Duplicate student")
   self.students.add(student)
   self.grades[student.getIdNum()] = @[]
   self.isSorted = false

proc addGrade(self: var Grades, student: Student, grade: float) =
   ## Assumes: grade is a float
   ## Add grade to the list of grades for student
   try:
      self.grades[student.getIdNum()].add(grade)
   except KeyError:
      raise newException(ValueError, "Student not in grade book")

proc getGrades(self: Grades, student: Student): seq[float] =
   ## Return a list of grades for student
   try:  # return copy of student's grades
      result = self.grades[student.getIdNum()]
   except KeyError:
      raise newException(ValueError, "Student not in grade book")

proc allStudents(self: var Grades): seq[Student] =
   ## Return a list of the students in the grade book
   if not self.isSorted:
      self.students.sort(cmp)
      self.isSorted = true
   result = self.students
   #return list of students

proc gradeReport(course: var Grades): string =
   # Assumes: course if of type grades
   var report: seq[string]
   for s in course.allStudents():
      var tot = 0.0
      var numGrades = 0
      for g in course.getGrades(s):
         tot += g
         inc(numGrades)
      if numGrades != 0:
         let average = tot / float(numGrades)
         report.add($s & "\'s mean grade is " & $average)
      else:
         report.add($s & " has no grades")
   result = join(report, "\n")

# -----------
# Course Code
# -----------

var ug1 = initUG("Matt Damon", 2018)
var ug2 = initUG("Ben Affleck", 2019)
var ug3 = initUG("Drew Houston", 2017)
var ug4 = initUG("Mark Zuckerberg", 2017)
var g1 = initGrad("Bill Gates")
var g2 = initGrad("Steve Wozniak")

var six00 = initGrades()
six00.addStudent(g1)
six00.addStudent(ug2)
six00.addStudent(ug1)
six00.addStudent(g2)
six00.addStudent(ug4)
six00.addStudent(ug3)

six00.addGrade(g1, 100)
six00.addGrade(g2, 25)
six00.addGrade(ug1, 95)
six00.addGrade(ug2, 85)
six00.addGrade(ug3, 75)

#echo(gradeReport(six00))

six00.addGrade(g1, 90)
six00.addGrade(g2, 45)
six00.addGrade(ug1, 80)
six00.addGrade(ug2, 75)

echo(gradeReport(six00))
