import oopmacro

class Animal:
  var age: int
  var name: string
  proc speak = echo "..."
  proc get_age: int = self.age
  proc get_name: string = self.name
  proc set_age(newage: int) = self.age = newage
  proc set_name(newname: string) = self.name = newname
  proc `$`: string = "animal:" & self.name & ":" & $self.age

class Cat of Animal:
  proc newCat(name: string, age: int): Cat =
    result = Cat(name: name, age: age)
  proc speak = echo "Meow"
  proc `$`: string = "cat:" & self.name & ":" & $self.age

class Rabbit of Animal:
  proc newRabbit(name: string, age: int): Rabbit =
    result = Rabbit(name: name, age: age)
  proc speak = echo "Meep"
  proc `$`: string = "rabbit:" & self.name & ":" & $self.age

class Person of Animal:
  proc newPerson(name: string, age: int): Person =
    result = Person(name: name, age: age, friends: @[])
  var friends: seq[Person]
  proc speak = echo "Hello"
  proc get_friends: seq[Person] = self.friends
  proc add_friend(friend: Person) =
    if friend notin self.friends:
      self.friends.add(friend)
  proc age_diff(other: Person) =
    let diff = self.age - other.age
    if self.age > other.age:
      echo self.name, " is ", diff, " years older than ", other.name
    else:
      echo self.name, " is ", -diff, " years younger than ", other.name
  proc `$`: string = "person:" & self.name & ":" & $self.age


let c = Cat(name: "Tom")
c.set_age(2)
echo c.get_name(), " ", c.get_age()

let eric = newPerson("Eric", 45)
eric.speak()

let john = newPerson("John", 55)
eric.age_diff(john)
john.add_friend(eric)
echo john.get_friends()
