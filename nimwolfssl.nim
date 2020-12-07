import os, strutils

import nimterop/[build, cimport ]

static:
  cDebug()
  cDisableCaching()                                   

const
  baseDir = getProjectCacheDir("nimwolfssl")   
  include_wolfssl_Dir = baseDir & os.DirSep & "wolfssl"
  include_wolfcrypt_Dir = baseDir & os.DirSep & "wolfssl" & os.DirSep & "wolfcrypt"
  defs = """
    sslStatic
    sslStd
    sslDL
    sslSetVer=4.5.0
  """

setDefines(defs.splitLines())

getHeader(
    #  "user_settings.h", "wolfssl/wolfcrypt/settings.h", "wolfssl/ssl.h", "wolfssl/options.h",
    "ssl.h",
    giturl = "https://github.com/wolfSSL/wolfssl",
    dlurl = "https://github.com/wolfSSL/wolfssl/archive/v$1-stable.zip",
    outdir = baseDir,
    # conFlags = "",
    cmakeFlags = "-DBUILD_TESTS=NO",
    altNames = "wolfssl",
)

cPlugin:
  import strutils
  # Strip leading and trailing underscores
  proc onSymbol*(sym: var Symbol) {.exportc, dynlib.} =
    sym.name = sym.name.strip(chars={'_'})
    if sym.name == "wolfSSL_X509_get_serial_number":
        sym.name = "c_wolfSSL_X509_get_serial_number"
    if sym.name == "wolfSSL_SetTmpDH":
        sym.name = "c_wolfSSL_SetTmpDH"
    if sym.name == "wolfSSL_GetVersion":
        sym.name = "c_wolfSSL_GetVersion"    
    if sym.name == "wolfSSL_free":
        sym.name = "c_wolfSSL_free"
    if sym.name == "CERT_TYPE":
        sym.name = "C_CERT_TYPE"

        
#[
when defined windows:
  echo "I'm on Windows!"
  cDefine("USE_WINDOWS_API") 
elif defined linux:
  echo "I'm on Linux!"
  cDefine("WOLFSSL_PTHREADS")
]#



cImport("user_settings.h")
cIncludeDir(baseDir)
cImport(sslPath, recurse = true)
# cImport(sslPath)

# cImport("options.h") 
# cImport("settings.h")  






