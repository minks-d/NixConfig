file:
let
  fileContent = builtins.readFile file;
  fileLines = builtins.split "\n" fileContent;
in builtins.trace {out = fileLines;} null

