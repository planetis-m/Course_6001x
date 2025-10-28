import std/[macros, macrocache, syncio]

# Compile-time storage of class fields and inheritance
const classFields = CacheTable"classFields"
const classParents = CacheTable"classParents"

type
  ClassBuilder = ref object
    # Holds the class context
    typeName, baseName, recList: NimNode
    ctorName: string

proc isInheritedField(fieldName: string, className: string): bool =
  # Trace up the inheritance chain to find if field exists
  result = false
  var currentClass = className
  while classParents.hasKey(currentClass):
    let parentClass = classParents[currentClass].strVal
    if classFields.hasKey(parentClass):
      let fieldsNode = classFields[parentClass]
      for field in fieldsNode:
        if eqIdent(fieldName, field.strVal):
          return true
    currentClass = parentClass

proc insertSelf(node: NimNode, b: ClassBuilder): NimNode =
  case node.kind
  of nnkIdent:
    let fieldName = $node
    # Check current class fields
    for r in b.recList:
      for i in 0 .. r.len - 3:
        if eqIdent(fieldName, $r[i]):
          return newDotExpr(ident("self"), node)
    # Check inherited fields by tracing inheritance chain
    if isInheritedField(fieldName, $b.typeName):
      return newDotExpr(ident("self"), node)
    # If no match, return the original identifier
    result = node
  of nnkDotExpr:
    # For dot expressions, don't qualify the right side
    result = newDotExpr(insertSelf(node[0], b), node[1])
  else:
    # For non-identifier nodes, copy and recursively transform children
    result = copyNimNode(node)
    for child in node:
      result.add insertSelf(child, b)

proc transform(node: NimNode, b: ClassBuilder): NimNode =
  case node.kind
  of nnkMethodDef, nnkProcDef:
    # check if it is the ctor proc
    if node.name.kind != nnkAccQuoted and eqIdent(b.ctorName, $node.name.basename):
      node.params[0] = b.typeName
      result = node
    else:
      # inject `self: T` into the arguments
      node.params.insert(1, newIdentDefs(ident("self"), b.typeName))
      # automatic self insertion for object fields
      result = insertSelf(node, b)
  of nnkVarSection:
    # variables get turned into fields of the type.
    node.copyChildrenTo(b.recList)
    # need to return None node
    result = newNimNode(nnkNone)
  else:
    result = copyNimNode(node)
    for n in node:
      let x = transform(n, b)
      # filter out None node kinds
      if x.kind != nnkNone: result.add(x)

macro class*(head, body): untyped =
  let b = ClassBuilder()
  # flag if object should be exported
  var isExported = false
  # `head` is expression `typeName(baseClass)`
  if head.kind == nnkCall:
    b.typeName = head[0]
    b.baseName = head[1]
    # `head` is expression `typeName*(baseClass)`
  elif head.kind == nnkInfix and $head[0] == "*" and head[2].kind == nnkPar:
    b.typeName = head[1]
    b.baseName = head[2][0]
    isExported = true
  else:
    error "Invalid node: " & head.lispRepr

  template declare(a, b): untyped =
    type a = ref object of b

  template declarePub(a, b): untyped =
    type a* = ref object of b

  # create a type section in the result
  let typeDecl =
    if isExported:
      getAst(declarePub(b.typeName, b.baseName))
    else:
      getAst(declare(b.typeName, b.baseName))

  # expected name of ctor by convention
  b.ctorName = "new" & $b.typeName
  # var declarations will be turned into object fields
  b.recList = newNimNode(nnkRecList)
  # inject recList under objectTy
  typeDecl[0][2][0][2] = b.recList

  # Store inheritance relationship
  classParents[$b.typeName] = newLit($b.baseName)

  result = newStmtList(typeDecl, transform(body, b))

  # Store current class fields
  let fieldsArray = newNimNode(nnkBracket)
  for r in b.recList:
    for i in 0 .. r.len - 3:
      fieldsArray.add(newLit($r[i]))
  classFields[$b.typeName] = fieldsArray

when isMainModule:
  class Animal(RootObj):
    var age: int
    method vocalize {.base.} = echo "..."
    proc `$`: string = "animal:" & $age

  class Person(Animal):
    var name: string = ""
    proc newPerson(name: string, age: int) =
      Person(name: name, age: age)
    method vocalize = echo "Hey"
    proc `$`: string = "person:" & name & ":" & $age

  let john = newPerson("John", 10)
  john.vocalize()
  echo john
