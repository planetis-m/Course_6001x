import macros

macro class*(head, body: untyped): untyped =
  var typeName, baseName: NimNode
  if head.kind == nnkIdent:
    typeName = head
  elif head.kind == nnkInfix and head[0].ident == !"of":
    typeName = head[1]
    baseName = head[2]
  else:
    quit "Invalid node: " & head.lispRepr

  result = newStmtList()
  result.add newNimNode(nnkTypeSection).add(
    newNimNode(nnkTypeDef).add(
      newIdentNode(typeName.ident),
      newEmptyNode(),
      newNimNode(nnkRefTy).add(
        newNimNode(nnkObjectTy).add(
          newEmptyNode(),
          newNimNode(nnkOfInherit).add(
            if baseName == nil: newIdentNode("RootObj")
            else: newIdentNode(baseName.ident)),
          newEmptyNode()))))

  var recList = newNimNode(nnkRecList)

  for node in body.children:
    case node.kind:
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

  result[0][0][2][0][2] = recList
  #echo treeRepr(result[0][0][2][0][2])
  #echo repr(result)

when isMainModule:
  class Animal:
    var age: int

  class Person of Animal:
    var name: string
    method vocalize {.base.} = echo "..."

  let john = Person(name: "John", age: 10)
  john.vocalize()
