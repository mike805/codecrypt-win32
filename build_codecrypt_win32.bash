#!/bin/bash

# Build codecrypt for win32

FAIL=0
echo Checking for prerequisites
if [ ! -f codecrypt-1.8.tar.gz ] ; then
	echo codecrypt-1.8.tar.gz missing
	FAIL=1
fi
if [ ! -f cryptopp565.zip ] ; then
	echo cryptopp565.zip missing
	FAIL=1
fi
if [ ! -f fftw-3.3.8.tar.gz ] ; then
	echo fftw-3.3.8.tar.gz missing
	FAIL=1
fi
if [ ! -f mingw-std-threads-master.zip ] ; then
	echo mingw-std-threads-master.zip missing
	FAIL=1
fi
if [ ! -f codecrypt-1.8.win32.patch ] ; then
	echo codecrypt-1.8.win32.patch missing
	FAIL=1
fi

if [ $FAIL -ne 0 ] ; then exit 1 ; fi

sleep 1
echo unpacking cryptopp
set -x
rm -rf cryptopp
mkdir cryptopp
cd cryptopp
unzip ../cryptopp565.zip
unzip ../mingw-std-threads-master.zip
cd ..
set +x
sleep 1
echo patching cryptopp
cat <<'ENDPATCH' | patch -p0
diff -Naur cryptopp-stock/GNUmakefile cryptopp/GNUmakefile
--- cryptopp-stock/GNUmakefile	2016-10-10 16:49:54 -0700
+++ cryptopp/GNUmakefile	2018-09-15 00:45:48 -0700
@@ -61,7 +61,7 @@
     CXXFLAGS ?= -DNDEBUG -g -xO2
   endif
 else
-  CXXFLAGS ?= -DNDEBUG -g2 -O2
+  CXXFLAGS ?= -DNDEBUG -D_WIN32_WINNT=0x0501 -g2 -O2 -std=gnu++11
 endif
 
 # Default prefix for make install
diff -Naur cryptopp-stock/misc.h cryptopp/misc.h
--- cryptopp-stock/misc.h	2016-10-10 16:49:54 -0700
+++ cryptopp/misc.h	2018-09-15 01:04:08 -0700
@@ -22,6 +22,9 @@
 #include "cryptlib.h"
 #include "stdcpp.h"
 #include "smartptr.h"
+#define owner_dead io_error
+#define protocol_error io_error
+#include "mingw-std-threads-master/mingw.mutex.h"
 
 #ifdef _MSC_VER
 	#if _MSC_VER >= 1400
ENDPATCH
if [ $? -ne 0 ] ; then exit 1 ; fi
sleep 1
echo building cryptopp
set -x
cd cryptopp
make
if [ $? -ne 0 ] ; then exit 1 ; fi
cd ..
set +x

echo
echo unpacking fftw-3.3.8
sleep 1
set -x
rm -rf fftw-3.3.8
tar xvzf fftw-3.3.8.tar.gz
set +x
sleep 1
echo configuring fftw-3.3.8
set -x
cd fftw-3.3.8
cp ../intrin.h .
CFLAGS="-g -O2 -DYieldProcessor=_mm_pause" ./configure --with-our-malloc16 --with-windows-f77-mangling --enable-shared --disable-static --enable-threads --with-combined-threads --enable-portable-binary --enable-sse2 --with-incoming-stack-boundary=2
if [ $? -ne 0 ] ; then exit 1 ; fi
set +x
echo
echo building fftw-3.3.8
sleep 1
set -x
make
if [ $? -ne 0 ] ; then exit 1 ; fi
set +x
echo installing fftw-3.3.8
set -x
make install
if [ $? -ne 0 ] ; then exit 1 ; fi
cd ..
set +x

echo unpacking codecrypt-1.8
sleep 1
set -x
rm -rf codecrypt-1.8
tar xvzf codecrypt-1.8.tar.gz
cd codecrypt-1.8
unzip ../mingw-std-threads-master.zip
cd ..
set +x
echo patching codecrypt-1.8
sleep 1
set -x
patch -p0 < codecrypt-1.8.win32.patch
if [ $? -ne 0 ] ; then exit 1 ; fi
set +x
echo configuring codecrypt-1.8
sleep 1
set -x
export CFLAGS="-I../fftw-3.3.8/api -I.. -D_WIN32_WINNT=0x0501"
export CXXFLAGS="-I../fftw-3.3.8/api -I.. -D_WIN32_WINNT=0x0501"
export LDFLAGS=-L/mingw/msys/1.0/local/lib
export CRYPTOPP_LIBS=../cryptopp/libcryptopp.a
export CRYPTOPP_CXXFLAGS="-I../fftw-3.3.8/api -I.. -D_WIN32_WINNT=0x0501"
export CRYPTOPP_CFLAGS="-I../fftw-3.3.8/api -I.. -D_WIN32_WINNT=0x0501"
cd codecrypt-1.8
./configure --with-cryptopp
if [ $? -ne 0 ] ; then exit 1 ; fi
set +x
echo building codecrypt-1.8
set -x
make
if [ $? -ne 0 ] ; then exit 1 ; fi
cd ..
set +x
echo creating portable executable
sleep 1
set -x
rm -rf codecrypt-portable
mkdir codecrypt-portable
cp codecrypt-1.8/ccr.exe codecrypt-portable/
mkdir codecrypt-portable/.libs
cp codecrypt-1.8/.libs/ccr.exe codecrypt-portable/.libs
cp /usr/local/bin/libfftw3-3.dll codecrypt-portable/.libs
cp /mingw/bin/libgcc_s_dw2-1.dll codecrypt-portable/.libs
cp /mingw/bin/libgmp-10.dll codecrypt-portable/.libs
cp /mingw/bin/libstdc++-6.dll codecrypt-portable/.libs
strip codecrypt-portable/.libs/ccr.exe
strip codecrypt-portable/.libs/libfftw3-3.dll
zip -r codecrypt-portable-win32.zip codecrypt-portable
set +x
echo done
echo

# EOF
