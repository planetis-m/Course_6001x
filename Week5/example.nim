{.this: self.}
import oopmacro

class Person(RootObj):
  var
    age: int
    name: string

  proc newPerson(name:string, age = 0): Person =
    result = Person(name: name, age: age)

  proc greet =
    echo "Hello, I am ", name, "."
    echo "I'm ", age, " years old."

var
  boys: seq[Person]
  girls: seq[Person]

class Boy(Person):
  proc newBoy(name:string, age = 0): Boy =
    result = Boy(name: name, age: age)
    boys.add(result)

class Girl(Person):
  proc newGirl(name:string, age = 0): Girl =
    result = Girl(name: name, age: age)
    girls.add(result)

proc setup =
  boys = @[]
  girls = @[]

proc greetKids =
  echo "Boys:"
  for boy in boys: boy.greet()
  echo "Girls:"
  for girl in girls: girl.greet()

# ---

setup()

var bob = newPerson("Bob", 45)
var joe = newBoy("Joe", 12)
var mat = newBoy("Mat", 10)
var sue = newGirl("Sue", 9)

bob.greet()
greetKids()
