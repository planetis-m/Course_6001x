import macros

type
   ClassBuilder = ref object
      # Holds the class context 
      typeName, baseName, recList: NimNode
      ctorName: string

proc transform(node: NimNode, b: ClassBuilder): NimNode =
   case node.kind
   of nnkMethodDef, nnkProcDef:
      if node.name.kind != nnkAccQuoted and eqIdent(b.ctorName, $node.name.basename):
         node.params[0] = b.typeName
      else:
         node.params.insert(1, newIdentDefs(ident("self"), b.typeName))
      result = node
   of nnkVarSection:
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

   var isExported = false
   if head.kind == nnkCall:
      b.typeName = head[0]
      b.baseName = head[1]
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

   let typeDecl =
      if isExported:
         getAst(declarePub(b.typeName, b.baseName))
      else:
         getAst(declare(b.typeName, b.baseName))

   b.recList = newNimNode(nnkRecList)
   # a NimNode is a reference type so this is possible
   typeDecl[0][2][0][2] = b.recList

   b.ctorName = "new" & $b.typeName

   # this alias is modified by the transform proc
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
