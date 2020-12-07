# Package

version       = "0.1.0"
author        = "darkr4y"
description   = "Nim wrapper for wolfssl"
license       = "MIT"
# srcDir        = "src"
skipDirs = @["tests"]

# Dependencies

requires "nim >= 1.4.0"
requires "nimterop >= 0.6.0"

var
  name = "nimwolfssl"

task test, "Run tests":
  exec "nim c -f -r tests/test_" & name & ".nim"
