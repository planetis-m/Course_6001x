

type
  Animal = ref object of RootObj
    age: int
    name: string
    speakImpl: proc(a: Animal)
    dollarImpl: proc(a: Animal): string

  Cat = ref object of Animal
  Rabbit = ref object of Animal
  Person = ref object of Animal
    friends: seq[Person]


# -----------
# Animal Impl
# -----------

proc defaultSpeak(a: Animal) = echo "..."

proc defaultDollar(a: Animal): string = "animal:" & a.name & ":" & $a.age

template newAnimal[T](t: typeDesc[T];
              name: string, age: int,
              speak: proc(a: Animal) = defaultSpeak,
              dollar: (proc(a: Animal): string) = defaultDollar): T =
  ## Use this template to create new animals.
  T(name: name, age: age,
    speakImpl: speak, dollarImpl: dollar)

proc `$`(a: Animal): string =
  assert a.dollarImpl != nil
  a.dollarImpl(a)

proc speak(a: Animal) =
  if a.speakImpl != nil: a.speakImpl(a)

proc getName(a: Animal): string = a.name
proc getAge(a: Animal): int = a.age

proc setName(a: Animal, newname: string) = a.name = newname
proc setAge(a: Animal, newage: int) = a.age = newage

# --------
# Cat Impl
# --------

proc catSpeak(a: Animal) = echo "Meow"
proc catDollar(a: Animal): string = "cat:" & a.name & ":" & $a.age

proc newCat(name: string, age: int): Cat =
  newAnimal(Cat, name, age, catSpeak, catDollar)

# -----------
# Rabbit Impl
# -----------

proc rabbitSpeak(a: Animal) = echo "Meep"
proc rabbitDollar(a: Animal): string = "rabbit:" & a.name & ":" & $a.age

proc newRabbit(name: string, age: int): Rabbit =
  newAnimal(Rabbit, name, age, rabbitSpeak, rabbitDollar)

# -----------
# Person Impl
# -----------

proc personSpeak(a: Animal) = echo "Hello"
proc personDollar(a: Animal): string = "person:" & a.name & ":" & $a.age

proc newPerson(name: string, age: int): Person =
  result = newAnimal(Person, name, age, personSpeak, personDollar)
  result.friends = @[]

proc getFriends(p: Person): seq[Person] = p.friends

proc addFriend(p, friend: Person) =
  if friend notin p.friends:
    p.friends.add(friend)

proc ageDiff(p, other: Person) =
  let diff = p.age - other.age
  if p.age > other.age:
    echo p.name, " is ", diff, " years older than ", other.name
  else:
    echo p.name, " is ", -diff, " years younger than ", other.name


let c = newCat("Tom", 1)
c.setAge(2)
echo c.getName(), " ", c.getAge()

let eric = newPerson("Eric", 45)
eric.speak()

let john = newPerson("John", 55)
eric.ageDiff(john)
john.addFriend(eric)
echo john.getFriends()
