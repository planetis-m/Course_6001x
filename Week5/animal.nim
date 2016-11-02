
type
  Animal = ref object of RootObj
    age: int
    name: string
  Cat = ref object of Animal
  Rabbit = ref object of Animal
  Person = ref object of Animal

proc get_age(self: Animal): int =
  result = self.age

proc get_name(self: Animal): string =
  result = self.name

proc set_age(self: Animal, newage: int) =
  self.age = newage

proc set_name(self: Animal, newname: string) =
  self.name = newname

proc `$`(self: Animal): string =
  result = "animal:" & self.name & ":" & $self.age


let c = Cat(name: "Tom")
c.set_age(2)
echo c.get_name(), " ", c.get_age()
