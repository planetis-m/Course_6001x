import macros

macro class*(head, body): untyped =
  # The macro is immediate so that it doesn't
  # resolve identifiers passed to it
  var typeName, baseName: NimNode
  var exported: bool

  # `head` is expression `typeName of baseClass`
  if head.kind == nnkCall:
    # Object is not exported
    typeName = head[0]
    baseName = head[1]
  elif head.kind == nnkInfix and head[2].kind == nnkPar:
    # Object is exported
    typeName = head[1]
    baseName = head[2][0]
    exported = true
  else:
    quit "Invalid node: " & head.lispRepr

  # create a type section in the result
  result =
    if exported:
      quote do:
        type `typeName`* = ref object of `baseName`
    else:
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
  class Animal*(RootObj):
    var age*: int

  class Person*(Animal):
    var name*: string
    proc newPerson*(name: string, age: int): Person =
      result = Person(name: name, age: age)
    method vocalize* {.base.} = echo "..."

  let john = newPerson("John", 10)
  john.vocalize()
