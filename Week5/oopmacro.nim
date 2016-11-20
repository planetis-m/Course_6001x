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
  result =
    quote do:
      type `typeName` = ref object of `baseName`

  # mark `typeName` with an asterisk
  if exported:
    result[0][0][0] = newNimNode(nnkPostfix).add(ident("*"), typeName)

  # var declarations will be turned into object fields
  var recList = newNimNode(nnkRecList)

  # expected name of ctor by convention
  let ctorName = newIdentNode("new" & $typeName)

  template injectThis: untyped =
    # make sure it is not the ctor proc
    if node.name.basename != ctorName:
      # inject `self: T` into the arguments
      node.params.insert(1, newIdentDefs(ident("self"), typeName))

  template markAsBase: untyped =
    # find out if user already annotated method with the base pragma
    let exists = findChild(node.pragma, it.ident == !"base")
    # add base pragma for methods belonging to a base class
    if baseName.ident == !"RootObj" and exists.isNil:
      node.addPragma(ident("base"))

  # Iterate over the statements, adding `this: T`
  # to the parameters of functions
  for node in body.children:
    case node.kind
    of nnkMethodDef:
      injectThis()
      markAsBase()
      result.add(node)
    of nnkProcDef:
      injectThis()
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
    method vocalize = echo "..."

  class Person(Animal):
    var name: string
    proc newPerson(name: string, age: int): Person =
      result = Person(name: name, age: age)
    method vocalize = echo "Hey"

  let john = newPerson("John", 10)
  john.vocalize()
