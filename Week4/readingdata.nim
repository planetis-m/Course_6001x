import algorithm, rdstdin, strutils

let file_name = readLine("Provide a name of a file of data: ")

var data: seq[seq[string]] = @[]
var fh: File
var succeeded = true
try:
   fh = open(file_name, fmRead)
except IOError:
   succeeded = false
   echo("cannot open", file_name)
finally:
   if succeeded:
      for line in lines(fh):
         if line != "\n":
            let it = line.strip.split(',') #remove trailing \n
            data.add(it)
   close(fh) # close file even if fail

var gradesData: seq[(seq[string], seq[int])] = @[]
if len(data) != 0:
   for student in data:
      try:
         let name = student[0 .. ^1]
         let grades = parseInt(student[^1])
         gradesData.add((name, @[grades]))
      except ValueError:
         gradesData.add((student, @[]))
