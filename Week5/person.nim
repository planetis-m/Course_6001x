import times, parseutils

type
  Person = object
    name: string
    birthday: TimeInterval
    lastname: string

proc setLastName(name: string): string =
  result = captureBetween(name, ' ')

proc setBirthDay(self: var Person; month, day, year: int) =
  self.birthday = initInterval(days = day, months = month, years = year)

proc newPerson(name: string): Person =
  result = Person(name: name, birthday: 0.days, lastname: setLastName(name))

proc getLastName(self: Person): string =
  result = self.lastname

proc getAge(self: Person): TimeInterval =
  result = (getTime() - self.birthday).toTimeInterval

proc cmp(a, b: Person): int =
  if a.lastname == b.lastname:
    return cmp(a.name, b.name)
  return cmp(a.lastname, b.lastname)

proc `$`(self: Person): string =
  result = self.name

# example usage

var
  p1 = newPerson("Mark Zuckerberg")
  p2 = newPerson("Drew Houston")
  p3 = newPerson("Bill Gates")
  p4 = newPerson("Andrew Gates")
  p5 = newPerson("Steve Wozniak")

p1.setBirthday(5, 14, 1984)
p2.setBirthday(3, 4, 1983)
p3.setBirthday(10, 28, 1955)

echo p1.getAge()

let personList = [p1, p2, p3, p4, p5]

for e in personList:
  echo e
