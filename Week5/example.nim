
type
  Person = ref object of RootObj
    age: int
    name: string

proc newPerson(name: string; age = 0): Person =
  result = Person(name: name, age: age)

proc greet(self: Person) =
  echo "Hello, I am ", self.name, "."
  echo "I\'m ", self.age, " years old."

var
  boys: seq[Person]
  girls: seq[Person]


type
  Boy = ref object of Person

proc newBoy(name: string; age = 0): Boy =
  result = Boy(name: name, age: age)
  boys.add(result)


type
  Girl = ref object of Person

proc newGirl(name: string; age = 0): Girl =
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
