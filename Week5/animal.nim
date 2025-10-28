import std/[syncio]
import oopmacro

class Animal(RootObj):
  var age: int
  var name: string

  proc speak = echo "..."
  proc getAge: int = age
  proc getName: string = name
  proc setAge(newage: int) = age = newage
  proc setName(newname: string) = name = newname
  proc `$`: string = "animal:" & name & ":" & $age

class Cat(Animal):
  proc newCat(name: string, age: int) =
    Cat(name: name, age: age)
  proc speak = echo "Meow"
  proc `$`: string = "cat:" & name & ":" & $age

class Rabbit(Animal):
  proc newRabbit(name: string, age: int) =
    Rabbit(name: name, age: age)
  proc speak = echo "Meep"
  proc `$`: string = "rabbit:" & name & ":" & $age

class Person(Animal):
  var friends: seq[Person]

  proc newPerson(name: string, age: int) =
    Person(name: name, age: age, friends: @[])
  proc speak = echo "Hello"
  proc getFriends: seq[Person] = friends
  proc addFriend(friend: Person) =
    if friend notin friends:
      friends.add(friend)
  proc ageDiff(other: Person) =
    let diff = age - other.age
    if age > other.age:
      echo name, " is ", diff, " years older than ", other.name
    else:
      echo name, " is ", -diff, " years younger than ", other.name
  proc `$`: string = "person:" & name & ":" & $age


let c = Cat(name: "Tom")
c.setAge(2)
echo c.getName(), " ", c.getAge()

let eric = newPerson("Eric", 45)
eric.speak()

let john = newPerson("John", 55)
eric.ageDiff(john)
john.addFriend(eric)
echo john.getFriends()
