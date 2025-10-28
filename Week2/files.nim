import std/[os, rdstdin]

var nameHandle = open("kids.txt", fmWrite)

for i in 0 .. 1:
   let name = readLineFromStdin("Enter name: ")
   nameHandle.writeLine(name)

nameHandle.close()

# var nameHandle = open("kids.txt")
# for line in nameHandle.lines:
#    echo line
# 
# nameHandle.close()
