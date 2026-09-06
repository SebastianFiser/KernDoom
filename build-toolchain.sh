#!/bin/bash
set -e  # zastav skript při první chybě

export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

mkdir -p ~/src
cd ~/src

# --- binutils ---
if [ ! -f binutils-2.42.tar.gz ]; then
    wget https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.gz
fi
tar -xzf binutils-2.42.tar.gz

rm -rf ~/src/build-binutils
mkdir -p ~/src/build-binutils && cd ~/src/build-binutils
../binutils-2.42/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j$(nproc)
make install

# --- gcc ---
cd ~/src
if [ ! -f gcc-13.2.0.tar.gz ]; then
    wget https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.gz
fi
tar -xzf gcc-13.2.0.tar.gz
cd gcc-13.2.0
./contrib/download_prerequisites

mkdir -p ~/src/build-gcc && cd ~/src/build-gcc
../gcc-13.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make -j$(nproc) all-gcc
make -j$(nproc) all-target-libgcc
make install-gcc
make install-target-libgcc

echo "Toolchain built at $PREFIX"