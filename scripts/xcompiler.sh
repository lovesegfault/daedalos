#!/usr/bin/env bash

dir="$( dirname "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)")"

ARCH=x86_64-elf
PREFIX="$dir/xcompiler"
workdir="$dir/xcompiler/script"
PARALLEL="-j$(nproc --all)"

BINUTILS="binutils-2.27"
GCC="gcc-6.2.0"
GMP="gmp-6.1.1"
MPFR="mpfr-3.1.5"
MPC="mpc-1.0.3"

if [ "$(uname)" == "Darwin" ]; then
    echo "This does not work on MacOS currently."
    exit
fi

OPTIONS_BINUTILS="--target=$ARCH --prefix=$PREFIX --with-sysroot --disable-nls --disable-werror"
OPTIONS_GCC="--target=$ARCH --prefix=$PREFIX --disable-nls --enable-languages=c,c++ --without-headers"

mkdir -p "$PREFIX"
mkdir -p "$workdir"

cd $workdir || exit

echo 'int main() {return 0;}' > test.c
error=0
if  ! gcc -lgmp test.c -o test; then
    error=1
    echo 'GMP (gmp-devel/libgmp-dev) dependency seems to be missing!'
fi
if ! gcc -lmpfr test.c -o test; then
    error=1
    echo 'MPFR (mpfr-devel/libmpfr-dev) dependency seems to be missing!'
fi
if ! gcc -lmpc test.c -o test; then
    error=1
    echo 'MPC (mpc-devel/libmpc-dev) dependency seems to be missing!'
fi
if ! gcc -lz test.c -o test; then
    error=1
    echo 'zlib (zlib-devel/zlib1g-dev) dependency seems to be missing!'
fi
if ! gcc -lpython2.7 test.c -o test; then
    error=1
    echo 'libpython2.7 (python-devel/python2.7-dev) dependency seems to be missing!'
fi
rm -f test test.c
if ! makeinfo -h > /dev/null; then
    error=1
    echo 'makeinfo (texinfo) dependency seems to be missing!'
fi
[ $error -eq 1 ] && exit 1

download=$workdir/download
build=$workdir/build

mkdir -p $download $build

if [ ! -f .downloaded ]; then
    wget -c http://ftp.gnu.org/gnu/binutils/$BINUTILS.tar.bz2 -O $download/$BINUTILS.tar.bz2 && \
        tar xvjf $download/$BINUTILS.tar.bz2 && \
        wget -c ftp://ftp.gnu.org/gnu/gcc/$GCC/$GCC.tar.bz2 -O $download/$GCC.tar.bz2 && \
        tar xvjf $download/$GCC.tar.bz2  && \
        wget -c http://gmplib.org/download/gmp/$GMP.tar.xz -O $download/$GDB.tar.xz && \
        tar xvJf $download/$GDB.tar.xz && \
        wget -c http://mpfr.loria.fr/$MPFR/$MPFR.tar.xz -O $download/$MPFR.tar.xz && \
        tar xvJf $download/$MPFR.tar.xz && \
        wget -c http://ftp.gnu.org/gnu/mpc/$MPC.tar.gz -O $download/$MPC.tar.gz && \
        tar xvzf $download/$MPC.tar.gz && \
        touch .downloaded
    if [ $? -ne 0 ]; then
        echo "Download failed!"
        exit 1
    fi
fi

# binutils
echo "Building binutils"
if [ ! -f .built_binutils ]; then
    cd $build || exit 1
    rm -rf * || exit 1
    $workdir/$BINUTILS/configure $OPTIONS_BINUTILS || exit 1
    make $PARALLEL all || exit 1
    make install || exit 1
    cd $workdir || exit 1
    rm -rf ${build:?}/* || exit 1
    touch .built_binutils || exit 1
fi

# GCC
echo "Building GCC"

if [ ! -f .built_gcc ]; then
    cd $build || exit 1
    rm -rf * || exit 1
    $workdir/$GCC/configure $OPTIONS_GCC || exit 1
    make $PARALLEL all-gcc || exit 1
    make $PARALLEL all-target-libgcc || exit 1
    make install-gcc || exit 1
    make install-target-libgcc || exit 1
    cd $workdir || exit 1
    rm -rf ${build:?}/* || exit 1
    touch .built_gcc || exit 1
fi

if [ $SHELL == "/usr/bin/bash" ]||[ $SHELL == "/bin/bash" ];then
    echo "It seems like you're using bash. To add the binaries to your PATH run"
    echo 'export PATH=$PATH':$PREFIX/bin
fi
if [ $SHELL == "/usr/bin/fish" ];then
    echo "It seems like you're using fish. To add the binaries to your PATH run"
    echo 'set -gx PATH $PATH' $PREFIX/bin
fi

echo 'Done'
