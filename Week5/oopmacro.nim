import macros

macro class*(head, body): untyped =
  # The macro is immediate so that it doesn't
  # resolve identifiers passed to it
  var typeName, baseName: NimNode

  if head.kind == nnkIdent:
    # `head` is expression `typeName`
    typeName = head
    baseName = newIdentNode("RootObj")
  elif head.kind == nnkInfix and head[0].ident == !"of":
    # `head` is expression `typeName of baseClass`
    typeName = head[1]
    baseName = head[2]
  else:
    quit "Invalid node: " & head.lispRepr

  # create a type section in the result
  result =
    quote do:
      type `typeName` = ref object of `baseName`

  # var declarations will be turned into object fields
  var recList = newNimNode(nnkRecList)

  # expected name of ctor by convention
  let ctorName = newIdentNode("new" & $typeName)

  # Iterate over the statements, adding `this: T`
  # to the parameters of functions
  for node in body.children:
    case node.kind
    of nnkMethodDef, nnkProcDef:
      # make sure it is not the ctor proc
      if node.name.basename != ctorName:
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
  class Animal:
    var age: int

  class Person of Animal:
    var name: string
    proc newPerson(name: string, age: int): Person =
      result = Person(name: name, age: age)
    method vocalize {.base.} = echo "..."

  let john = newPerson("John", 10)
  john.vocalize()
