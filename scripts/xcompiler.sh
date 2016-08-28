#!/usr/bin/env bash

ARCH=x86_64-elf
PREFIX=$(pwd)/xcompiler/$ARCH
PATH=$PATH:$PREFIX/bin
CFLAGS="-g -O2"
CCOUNT=$(nproc --all)

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
    wget http://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.gz
    wget http://ftp.gnu.org/gnu/gcc/gcc-6.2.0/gcc-6.2.0.tar.gz
    wget http://gmplib.org/download/gmp/gmp-6.1.1.tar.xz
    wget http://www.mpfr.org/mpfr-current/mpfr-3.1.4.tar.xz
    wget http://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz

    echo 'Extracting'
    tar xzf binutils-2.27.tar.gz
	tar xzf gcc-6.2.0.tar.gz
	tar xJf gmp-6.1.0.tar.xz
	tar xJf mpfr-3.1.4.tar.xz
    tar xzf mpc-1.0.3.tar.gz

    mv gmp-6.2.0 gcc-6.1.0/gmp
	mv mpfr-3.1.4 gcc-6.1.0/mpfr
	mv mpc-1.0.3 gcc-6.1.0/mpc

    cd - || exit
fi

echo 'Building binutils'
mkdir xcompiler/build/binutils && cd "$_" || exit
../../src/binutils-2.26/configure --target=$ARCH --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j$CCOUNT
make install
cd - || exit

echo 'Building GCC'
mkdir xcompiler/build/gcc && cd "$_" || exit
../../src/gcc-6.1.0/configure --target=$ARCH --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc -j$CCOUNT
make all-target-libgcc -j$CCOUNT
make install-gcc
make install-target-libgcc
cd - || exit

echo 'Done'
