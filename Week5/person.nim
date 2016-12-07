import times, parseutils

type
  Person = object
    name: string
    birthday: Time
    lastname: string

proc setLastName(name: string): string =
  result = captureBetween(name, ' ')

proc setBirthDay(self: var Person, day: string) =
  self.birthday = times.parse(day, "d/M/yy").toTime

proc newPerson(name: string): Person =
  result = Person(name: name, birthday: 0.Time, lastname: setLastName(name))

# example usage

var
  p1 = newPerson("Mark Zuckerberg")
  p2 = newPerson("Drew Houston")
  p3 = newPerson("Bill Gates")
  p4 = newPerson("Andrew Gates")
  p5 = newPerson("Steve Wozniak")

p1.setBirthday("5/14/84")
p2.setBirthday("3/4/83")
p3.setBirthday("10/28/55")


let personList = [p1, p2, p3, p4, p5]

for e in personList:
  echo e
