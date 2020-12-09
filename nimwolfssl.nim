import os, strutils

import nimterop/[build, cimport ]

static:
  cDebug()
  cDisableCaching()                                   
  # cSkipSymbol(@["will"])

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
    if sym.name == "Md4":
        sym.name = "C_Md4"
        

        
#[
when defined windows:
  echo "I'm on Windows!"
  cDefine("USE_WINDOWS_API") 
elif defined linux:
  echo "I'm on Linux!"
  cDefine("WOLFSSL_PTHREADS")
]#

type  
  HANDLE {.importc: "HANDLE",
              header: "<windows.h>", final, pure.} = object
  CRITICAL_SECTION {.importc: "CRITICAL_SECTION",
              header: "<windows.h>", final, pure.} = object
  WIN32_FIND_DATAA {.importc: "WIN32_FIND_DATAA",
              header: "<windows.h>", final, pure.} = object
  sockaddr  {.importc: "sockaddr",
              header: "<winsock2.h>", final, pure.} = object
  sockaddr_storage {.importc: "sockaddr_storage",
              header: "<winsock2.h>", final, pure.} = object
  sockaddr_in {.importc: "sockaddr_in",
              header: "<winsock2.h>", final, pure.} = object
  hostent {.importc: "hostent",
              header: "<winsock2.h>", final, pure.} = object
  tm {.importc: "tm",
              header: "<time.h>", final, pure.} = object
  will = object
#  mp_digit = uint

const defineValue = @[
  "WOLFSSL_LIB",
  "WOLFSSL_USER_SETTINGS",
  "CYASSL_USER_SETTINGS"
]

cDefine(defineValue)
#cImport("user_settings.h")
cIncludeDir(baseDir)
cPassL(baseDir)
#cIncludeDir(@[include_wolfssl_Dir,include_wolfcrypt_Dir])
#cImport(include_wolfcrypt_Dir/"random.h" , recurse = true)
#cCompile(baseDir/"wolfcrypt"/"src"/"random.c")  

#cImport(include_wolfcrypt_Dir/"types.h")
#cImport(include_wolfcrypt_Dir/"asn_public.h")
#cImport(include_wolfcrypt_Dir/"tfm.h")
#cImport(include_wolfcrypt_Dir/"rsa.h")
#cImport(sslPath, recurse = true)
const includePath = @[
  
#  include_wolfcrypt_Dir/"types.h",
#  include_wolfcrypt_Dir/"asn_public.h",
#  include_wolfcrypt_Dir/"tfm.h",

  sslPath,
#  include_wolfcrypt_Dir/"integer.h",
  include_wolfcrypt_Dir/"rsa.h",
]
cImport(includePath, recurse = true)

# cImport(sslPath)

# cImport("options.h") 
# cImport("settings.h")  






