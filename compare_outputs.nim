import std/[os, osproc, streams, strutils, times, sequtils, strformat]

const
  stError = "\e[31;1m"
  stSuccess = "\e[32;1m"
  stFailure = "\e[33;1m"
  stInfo = "\e[34;1m"
  resetCode = "\e[0m"

proc main =
  let params = commandLineParams()
  
  if "--help" in params or "-h" in params:
    quit("Nimony vs Nim comparison tool\n\n" &
        "Command line syntax: \n\n" &
        "  > nim c -r compare_outputs.nim [directories...]\n")
  
  let
    nimony = "nimony"
    nim = getCurrentCompilerExe()
    curDir = getCurrentDir()
  
  var
    totalFiles = 0
    totalMatches = 0
    totalMismatches = 0
    totalNimonyErrors = 0
    totalNimErrors = 0
  
  let testDirs = if params.len > 0: @params else: @["."]
  
  for testDir in testDirs:
    echo &"{stInfo}[Directory]{resetCode} {testDir}"
    
    for f in walkFiles(testDir / "*.nim"):
      let
        (dir, name, ext) = splitFile(f)
        testName = name & ext
      
      inc(totalFiles)
      echo &"  Testing: {testName}"
      
      # Compile and run with nimony
      let (nimonyOut, nimonyCode) = execCmdEx(&"{nimony} c -r {f}")
      
      # Compile and run with nim
      let (nimOut, nimCode) = execCmdEx(&"{nim} c -r --hints:off -w:off {f}")
      
      if nimonyCode != 0 and nimCode != 0:
        echo &"    {stError}[BOTH ERROR]{resetCode} nimony: {nimonyCode}, nim: {nimCode}"
        inc(totalNimonyErrors)
        inc(totalNimErrors)
      elif nimonyCode != 0:
        echo &"    {stError}[NIMONY ERROR]{resetCode} code: {nimonyCode}"
        inc(totalNimonyErrors)
      elif nimCode != 0:
        echo &"    {stError}[NIM ERROR]{resetCode} code: {nimCode}"
        inc(totalNimErrors)
      elif nimonyOut.strip() == nimOut.strip():
        echo &"    {stSuccess}[MATCH]{resetCode}"
        inc(totalMatches)
      else:
        echo &"    {stFailure}[MISMATCH]{resetCode}"
        echo &"      {stInfo}Nimony output:{resetCode}"
        echo &"      {nimonyOut.strip().indent(6)}"
        echo &"      {stInfo}Nim output:{resetCode}"
        echo &"      {nimOut.strip().indent(6)}"
        inc(totalMismatches)
  
  echo "\n" & "=".repeat(50)
  echo &"{stInfo}SUMMARY:{resetCode}"
  echo &"  Total files: {totalFiles}"
  echo &"  {stSuccess}Matches: {totalMatches}{resetCode}"
  echo &"  {stFailure}Mismatches: {totalMismatches}{resetCode}"
  echo &"  {stError}Nimony errors: {totalNimonyErrors}{resetCode}"
  echo &"  {stError}Nim errors: {totalNimErrors}{resetCode}"
  echo &"  Success rate: {(totalMatches.float / totalFiles.float * 100):.1f}%"
  echo "=".repeat(50)
  
  # Exit with error if there are mismatches or errors
  if totalMismatches > 0 or totalNimonyErrors > 0:
    quit(1)

main()
