import oopmacro

class Animal of RootObj:
  var age: int
  var name: string

  method get_age: int = this.age
  method get_name: string = this.name
  method set_age(newage: int) = this.age = newage
  method set_name(newname: string) = this.name = newname
  method `$`: string = "animal:" & this.name & ":" & $this.age

class Cat of Animal:
  discard
class Rabbit of Animal:
  discard
class Person of Animal:
  discard

let c = Cat(name: "Tom")
c.set_age(2)
echo c.get_name(), " ", c.get_age()
