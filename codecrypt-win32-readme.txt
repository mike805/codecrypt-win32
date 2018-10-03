Procedure to build Codecrypt 1.8 portable executable for Win32
Tested on a clean Windows 7 virtual machine.
The resulting codecrypt binary (ccr.exe) along with its .libs directory
will run on a Windows machine without a development environment installed.
I am also working on a Python interface for Codecrypt.

Download and run mingw-get-setup.exe here:
http://www.mingw.org/ [no https as of this writing]
https://osdn.net/projects/mingw/releases/p15522
Tested with mingw-get-setup 0.63

From MinGW Installation Manager Basic Setup, choose:
mingw-developer-toolkit-bin
mingw32-base-bin
mingw32-gcc-g++-bin
msys-base-bin

From All Packages, choose if not present:
mingw32-gmp-dev
mingw32-mpfr-dev
mingw32-pthreads-w32-dev
msys-unzip-bin
msys-zip-bin

Note: if mingw-get fails to install something like libgmp or libmpfr, you
must fix this before proceeding.  As of this writing, MinGW's catalog lags
behind their repository, so the installer is looking for old versions that
no longer exist in their repository.

The actual packages can be found in directories like:
https://sourceforge.net/projects/mingw/files/MinGW/Base/gmp/gmp-6.1.2/
Go look for the proper version, and update the installer configuration files.
I edited /mingw/var/lib/mingw-get/data/mingw32-gmp.xml
and changed the version from 6.1.2-1 to 6.1.2-2
Also had to edit /mingw/var/lib/mingw-get/data/mingw32-mpfr.xml and change
libmpfr-3.1.5-1 to 3.1.5-2
Quit and restart the installer if you have to edit these files, then try the
install again.

Open a Windows Command Prompt. Create your working directory. I used:
C:
mkdir \projects
mkdir \projects\codecrypt
cd \projects\codecrypt

Copy x86intrin.h to intrin.h in the working directory:
copy C:\MinGW\lib\gcc\mingw32\6.3.0\include\x86intrin.h C:\projects\codecrypt\intrin.h

Set your path:
path %path%;c:\MinGW\bin;c:\MinGW\msys\1.0\bin

Copy in the prerequisites. You should have:

C:\projects\codecrypt>dir
 Volume in drive C has no label.
 Volume Serial Number is 14AF-C0C1

 Directory of C:\projects\codecrypt

10/01/2018  02:21 PM    <DIR>          .
10/01/2018  02:21 PM    <DIR>          ..
10/01/2018  02:21 PM             3,999 build_codecrypt_win32.bash
09/05/2018  03:57 AM           471,273 codecrypt-1.8.tar.gz
09/29/2018  12:03 PM            10,548 codecrypt-1.8.win32.patch
09/05/2018  11:43 AM         4,220,843 cryptopp565.zip
09/05/2018  04:26 AM         4,110,137 fftw-3.3.8.tar.gz
06/02/2017  10:20 AM             2,030 intrin.h
09/29/2018  12:48 AM            31,127 mingw-std-threads-master.zip
               7 File(s)      8,849,957 bytes
               2 Dir(s)   8,674,856,960 bytes free

Switch to a bash (Unix-style shell) and run the build process:
C:\projects\codecrypt>bash
bash-3.1$ ./build_codecrypt_win32.bash

If you have set up everything properly, this will compile all the
prerequisites first, applying patches as it goes, and then patch and compile
codecrypt and make a portable executable.

Here are the things I had to fix in the codecrypt for Windows patch:
* add a flock.c which is missing in mingw and include it
* change random number generator from /dev/random to CryptGenRandom
* set stdin and/or stdout to binary if we are piping data in and/or out
  [Windows defaults to text]
* put in a readpassphrase function and use it

Most of the code snippets used were tracked down online, and I put in
comments with links to the sources.

Codecrypt for Windows saves its keyrings in the current directory by
default. You probably want to set environment variable CCR_DIR to the
location you want to store your keyring in.

You need to run ccr as ccr.exe or .\ccr.exe
If you just type "ccr", libtool runtime cannot find the library and
the program doesn't work.

CryptGenRandom may not be entirely secure on Windows XP and earlier.

Mike Ingle <inglem@pobox.com> or <mike@confidantmail.org>
Check out my secure email system Confidant Mail at https://www.confidantmail.org/
Confidant Mail is the only secure email system with multi-gigabyte attachment support.
