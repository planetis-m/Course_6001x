import oopmacro

{.this.}

class Animal(RootObj):
  var age: int
  var name: string
  proc speak = echo "..."
  proc get_age: int = age
  proc get_name: string = name
  proc set_age(newage: int) = age = newage
  proc set_name(newname: string) = name = newname
  proc `$`: string = "animal:" & name & ":" & $age

class Cat(Animal):
  proc newCat(name: string, age: int) =
    result = Cat(name: name, age: age)
  proc speak = echo "Meow"
  proc `$`: string = "cat:" & name & ":" & $age

class Rabbit(Animal):
  proc newRabbit(name: string, age: int) =
    result = Rabbit(name: name, age: age)
  proc speak = echo "Meep"
  proc `$`: string = "rabbit:" & name & ":" & $age

class Person(Animal):
  proc newPerson(name: string, age: int) =
    result = Person(name: name, age: age, friends: @[])
  var friends: seq[Person]
  proc speak = echo "Hello"
  proc get_friends: seq[Person] = friends
  proc add_friend(friend: Person) =
    if friend notin friends:
      friends.add(friend)
  proc age_diff(other: Person) =
    let diff = age - other.age
    if age > other.age:
      echo name, " is ", diff, " years older than ", other.name
    else:
      echo name, " is ", -diff, " years younger than ", other.name
  proc `$`: string = "person:" & name & ":" & $age


let c = Cat(name: "Tom")
c.set_age(2)
echo c.get_name(), " ", c.get_age()

let eric = newPerson("Eric", 45)
eric.speak()

let john = newPerson("John", 55)
eric.age_diff(john)
john.add_friend(eric)
echo john.get_friends()
