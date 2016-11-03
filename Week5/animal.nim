import oopmacro

class Animal:
  var age: int
  var name: string

  method get_age: int {.base.} = self.age
  method get_name: string {.base.} = self.name
  method set_age(newage: int) {.base.} = self.age = newage
  method set_name(newname: string) {.base.} = self.name = newname
  method speak {.base.} = echo ""
  proc `$`: string = "animal:" & self.name & ":" & $self.age

class Cat of Animal:
  method speak = echo "Meow"
  proc `$`: string = "cat:" & self.name & ":" & $self.age

class Rabbit of Animal:
  method speak = echo "Meep"
  proc `$`: string = "rabbit:" & self.name & ":" & $self.age

class Person of Animal:
  var friends: seq[string]
  method speak = echo "Hello"
  method get_friends: seq[string] {.base.} = self.friends
  method add_friend(fname: string) {.base.} =
    if isNil(self.friends): self.friends = newSeq[string]()
    if fname notin self.friends:
      self.friends.add(fname)

  method age_diff(other: Person) {.base.} =
    let diff = self.get_age() - other.get_age()
    if self.age > other.age:
      echo self.name, " is ", diff, " years older than ", other.name
    else:
      echo self.name, " is ", -diff, " years younger than ", other.name

  proc `$`: string = "person:" & self.name & ":" & $self.age


let c = Cat(name: "Tom")
c.set_age(2)
echo c.get_name(), " ", c.get_age()

let eric = Person(name: "Eric", age: 45)
eric.speak()
let john = Person(name: "John", age: 55)
eric.age_diff(john)
john.add_friend("eric")
echo john.get_friends()
