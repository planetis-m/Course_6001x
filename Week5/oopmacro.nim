import macros

type
   ClassBuilder = ref object
      # Holds the class context 
      typeName, baseName, recList: NimNode
      ctorName: string

iterator dfTraversal(n: NimNode): NimNode =
   var stack = newSeq[tuple[n: NimNode, i: int]]()
   stack.add((n: n, i: 0))
   yield stack[^1].n
   while stack.len > 0:
      template i: untyped = stack[^1].i
      template n: untyped = stack[^1].n
      while i < n.len:
         let child = n[i]
         i.inc
         stack.add((n: child, i: 0))
         yield stack[^1].n
      discard stack.pop

proc insertSelf(node: NimNode, b: ClassBuilder): NimNode =
#    for n in node.dfTraversal:
#       if n.kind == nnkIdent:
#          echo n.repr

   case node.kind
   of nnkIdent:
#       echo node.repr
      for r in b.recList:
         for i in 0 .. r.len - 3:
            if eqIdent($node, $r[i]):
               return newDotExpr(ident("self"), node)
      result = node
   else:
      result = copyNimNode(node)
      for n in node:
         result.add insertSelf(n, b)

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
         discard insertSelf(node, b)
         result = node
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

   result = newStmtList(typeDecl, transform(body, b))
   # echo result.treeRepr

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
