import algorithm, rdstdin, strutils

let file_name = readLineFromStdin("Provide a name of a file of data: ")

var data: seq[seq[string]] = @[]
var fh: File
var succeeded: bool

try:
   fh = open(file_name, fmRead)
   succeeded = true
   for line in lines(fh):
      if line != "\n":
         let it = line.strip.split(", ") #remove trailing \n
         data.add(it)
except IOError:
   echo("cannot open ", file_name)
finally:
   if succeeded:
      close(fh)

var gradesData: seq[(seq[string], seq[int])] = @[]

for student in data:
   try:
      let name = student[0 .. ^2]
      let grades = parseInt(student[^1])
      gradesData.add((name, @[grades]))
   except ValueError:
      echo student
      gradesData.add((student, @[]))
