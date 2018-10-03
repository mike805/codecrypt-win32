```
Binaries and patches for Codecrypt 1.8 Win32 portable executable
Tested on a clean Windows 7 virtual machine.
The codecrypt binary (ccr.exe) along with its .libs directory will run
on a Windows machine without a development environment installed.

Note: you must run codecrypt as ccr.exe in Windows.
If you just type "ccr" it will not work due to libtool.
Codecrypt will put the keys in the current directory unless you set CCR_DIR
Minutes-long key generation is normal - it's not broken! Everything is fast
after the key generation.

* codecrypt-portable-win32.zip
  Codecrypt portable executable binary package for win32
  If you just want to run codecrypt on Windows, this is the only file you need.
  License: LGPL 3.0

* codecrypt-1.8.win32.patch
  Patch for codecrypt 1.8 to make it compatible with MinGW
  License: LGPL due to embedded flock.c

* build_codecrypt_win32.bash
  Build script to unpack, patch, and compile codecrypt in MinGW
  
* codecrypt-win32-readme.txt
  Detailed instructions to setup build environment and build codecrypt

* codecrypt-1.8.tar.gz
  Codecrypt source code from https://gitea.blesmrt.net/exa/codecrypt
  License: LGPL 3.0

* cryptopp565.zip
  Cryptopp source code from https://www.cryptopp.com/release565.html
  License: Boost Software License - Version 1.0

* fftw-3.3.8.tar.gz
  FFTW library from http://www.fftw.org/download.html
  License: GPL

* mingw-std-threads-master.zip
  MinGW threads library from https://github.com/meganz/mingw-std-threads
  License: in package, permits source redistribution.

Check out my GPG-based email system Confidant Mail at https://www.confidantmail.org/
Confidant Mail is the only secure email system with multi-gigabyte attachment support.
```
