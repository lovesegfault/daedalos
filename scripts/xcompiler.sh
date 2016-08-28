#!/usr/bin/env bash

ARCH=x86_64-elf
PREFIX=$(pwd)/xcompiler/$ARCH
PATH=$PATH:$PREFIX/bin
CFLAGS="-g -O2"
CCOUNT=$(nproc --all)

BINUTILS="binutils-2.27"
GCC="gcc-6.2.0"
GMP="gmp-6.1.1"
MPFR="mpfr-3.1.4"
MPC="mpc-1.0.3"

if [ "$(uname)" == "Darwin" ]; then
	echo "This doesn't work on MacOS yet!"
    exit
fi

rm -rf xcompiler/build
rm -rf xcompiler/$ARCH
mkdir -p xcompiler/build
mkdir -p xcompiler/$ARCH

if [[ ! -d xcompiler/src ]]; then
    mkdir -p xcompiler/src
    cd xcompiler/src || exit

    echo 'Downloading Sources'
    wget http://ftp.gnu.org/gnu/binutils/$BINUTILS.tar.gz
    wget http://ftp.gnu.org/gnu/gcc/$GCC/$GCC.tar.gz
    wget http://gmplib.org/download/gmp/$GMP.tar.xz
    wget http://www.mpfr.org/mpfr-current/$MPFR.tar.xz
    wget http://ftp.gnu.org/gnu/mpc/$MPC.tar.gz

    echo 'Extracting'
    tar xzf $BINUTILS.tar.gz
	tar xzf $GCC.tar.gz
	tar xJf $GMP.tar.xz
	tar xJf $MPFR.tar.xz
    tar xzf $MPC.tar.gz

    mv $GMP $GCC/gmp
	mv $MPFR $GCC/mpfr
	mv $MPC $GCC/mpc

    cd - || exit
fi

echo 'Building binutils'
mkdir xcompiler/build/binutils && cd "$_" || exit
../../src/$BINUTILS/configure --target=$ARCH --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j$CCOUNT
make install
cd - || exit

echo 'Building GCC'
mkdir xcompiler/build/gcc && cd "$_" || exit
../../src/$GCC/configure --target=$ARCH --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc -j$CCOUNT
make all-target-libgcc -j$CCOUNT
make install-gcc
make install-target-libgcc
cd - || exit

echo 'Done'
