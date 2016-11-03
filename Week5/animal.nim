import oopmacro

class Animal of RootObj:
  var age: int
  var name: string

  method get_age: int {.base.} = this.age
  method get_name: string {.base.} = this.name
  method set_age(newage: int) {.base.} = this.age = newage
  method set_name(newname: string) {.base.} = this.name = newname
  method speak {.base.} = echo ""
  proc `$`: string = "animal:" & this.name & ":" & $this.age

class Cat of Animal:
  method speak = echo "Meow"
  proc `$`: string = "cat:" & this.name & ":" & $this.age

class Rabbit of Animal:
  method speak = echo "Meep"
  proc `$`: string = "rabbit:" & this.name & ":" & $this.age

class Person of Animal:
  var friends: seq[string]
  method speak = echo "Hello"
  method get_friends: seq[string] {.base.} = this.friends
  method add_friend(fname: string) {.base.} =
    if isNil(this.friends): this.friends = newSeq[string]()
    if fname notin this.friends:
      this.friends.add(fname)

  method age_diff(other: Person) {.base.} =
    let diff = this.get_age() - other.get_age()
    if this.age > other.age:
      echo this.name, " is ", diff, " years older than ", other.name
    else:
      echo this.name, " is ", -diff, " years younger than ", other.name

  proc `$`: string = "person:" & this.name & ":" & $this.age


let c = Cat(name: "Tom")
c.set_age(2)
echo c.get_name(), " ", c.get_age()

let eric = Person(name: "Eric", age: 45)
eric.speak()
let john = Person(name: "John", age: 55)
eric.age_diff(john)
john.add_friend("eric")
echo john.get_friends()
