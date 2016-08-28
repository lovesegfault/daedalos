#!/usr/bin/env bash

ARCH=x86_64-elf
PREFIX=$(pwd)/xcompiler/$ARCH
PATH=$PATH:$PREFIX/bin
CFLAGS="-g -O2"
CCOUNT=$(nproc --all)

BIN_VER="binutils-2.27"
GCC_VER="gcc-6.2.0"
GMP_VER="gmp-6.1.1"
MPF_VER="mpfr-3.1.4"
MPC_VER="mpc-1.0.3"

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
    wget http://ftp.gnu.org/gnu/binutils/$BIN_VER.tar.gz
    wget http://ftp.gnu.org/gnu/gcc/$GCC_VER/$GCC_VER.tar.gz
    wget http://gmplib.org/download/gmp/$GMP_VER.tar.xz
    wget http://www.mpfr.org/mpfr-current/$MPF_VER.tar.xz
    wget http://ftp.gnu.org/gnu/mpc/$MPC_VER.tar.gz

    echo 'Extracting'
    tar xzf $BIN_VER.tar.gz
	tar xzf $GCC_VER.tar.gz
	tar xJf $GMP_VER.tar.xz
	tar xJf $MPF_VER.tar.xz
    tar xzf $MPC_VER.tar.gz

    mv $GMP_VER $GCC_VER/gmp
	mv $MPF_VER $GCC_VER/mpfr
	mv $MPC_VER $GCC_VER/mpc

    cd - || exit
fi

echo 'Building binutils'
mkdir xcompiler/build/binutils && cd "$_" || exit
../../src/$BIN_VER/configure --target=$ARCH --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j$CCOUNT
make install
cd - || exit

echo 'Building GCC'
mkdir xcompiler/build/gcc && cd "$_" || exit
../../src/$GCC_VER/configure --target=$ARCH --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc -j$CCOUNT
make all-target-libgcc -j$CCOUNT
make install-gcc
make install-target-libgcc
cd - || exit

echo 'Done'
