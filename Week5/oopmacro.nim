import macros

macro class*(head, body): untyped =
  # The macro is immediate so that it doesn't
  # resolve identifiers passed to it
  var typeName, baseName: NimNode

  # flag if object should be exported
  var exported: bool

  if head.kind == nnkCall:
    # `head` is expression `typeName(baseClass)`
    typeName = head[0]
    baseName = head[1]
  elif head.kind == nnkInfix and head[0].ident == !"*" and head[2].kind == nnkPar:
    # `head` is expression `typeName*(baseClass)`
    typeName = head[1]
    baseName = head[2][0]
    exported = true

  else:
    quit "Invalid node: " & head.lispRepr

  # create a type section in the result
  template typeDecl(a, b): untyped =
    type a = ref object of b

  template typeDeclExp(a, b): untyped =
    type a* = ref object of b

  if exported:
    result = getAst(typeDeclExp(typeName, baseName))
  else:
    result = getAst(typeDecl(typeName, baseName))

  # var declarations will be turned into object fields
  var recList = newNimNode(nnkRecList)

  # expected name of ctor by convention
  let ctorName = newIdentNode("new" & $typeName)

  # Iterate over the statements, adding `self: T`
  # to the parameters of functions
  for node in body.children:
    case node.kind

    of nnkMethodDef, nnkProcDef:
      # check if it is not the ctor proc
      if node.name.kind != nnkAccQuoted and node.name.basename == ctorName:
        # specify the return type of the ctor proc
        node.params[0] = typeName
      else:
        # inject `self: T` into the arguments
        node.params.insert(1, newIdentDefs(ident("self"), typeName))
      result.add(node)

    of nnkVarSection:
      # variables get turned into fields of the type.
      for n in node.children:
        recList.add(n)

    else:
      result.add(node)

  # inject recList under objectTy
  result[0][0][2][0][2] = recList


when isMainModule:
  class Animal(RootObj):
    var age: int
    method vocalize {.base.} = echo "..."
    proc `$`: string = "animal:" & $self.age

  class Person(Animal):
    var name: string
    proc newPerson(name: string, age: int) =
      result = Person(name: name, age: age)
    method vocalize = echo "Hey"
    proc `$`: string = "person:" & self.name & ":" & $self.age

  let john = newPerson("John", 10)
  john.vocalize()
  echo john
