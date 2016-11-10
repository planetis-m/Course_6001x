import macros

macro init*(p): untyped =
  # remove self from the construction proc
  if p.params[1][0].ident == !"self":
    del(p.params, 1)
  result = p

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

  # Iterate over the statements, adding `this: T`
  # to the parameters of functions
  for node in body.children:
    case node.kind
    of nnkMethodDef, nnkProcDef:
      # inject `self: T` into the arguments
      node.params.insert(1, newIdentDefs(ident("self"), typeName))
      result.add(node)
    of nnkVarSection:
      # variables get turned into fields of the type.
      for n in node.children:
        recList.add(n)
    else:
      result.add(node)

  # Create a constructor procedure
  let consParams = [typeName, recList[0]]
  let consName = newIdentNode("new" & $typeName)
  let consProc = newProc(consName, consParams)

  result.add(consProc)

  # inject recList under objectTy
  result[0][0][2][0][2] = recList


when isMainModule:
  class Animal:
    var age: int

  class Person of Animal:
    var name: string
    method vocalize {.base.} = echo "..."

  let john = newPerson("John", 10)
  john.vocalize()
