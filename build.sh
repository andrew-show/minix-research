#!/bin/bash

devel=no
if [ "X$1" == "Xdevel" ]; then
    devel=yes
fi
build_sh=$(realpath -e $0)

if [ ! -d src ]; then
    # download and extract source code
    wget https://github.com/Stichting-MINIX-Research-Foundation/minix/archive/refs/tags/v3.3.0.tar.gz
    tar xvf v3.3.0.tar.gz

    mv minix-3.3.0 src

    # apply patches to fix build issue
    cd src
    cat ../patches/*.patch | patch -p1
else
    cd src
fi

if [ ! -d ../obj.i386 ]; then
    # build tools and minix
    export JOBS=8
    ./releasetools/x86_hdimage.sh
fi

if [ $devel == "yes" ]; then
    # rebuild kenel with debug enabled
    export PATH=$(cd ../obj.i386/tooldir.*/bin && pwd):$PATH

    export DBG='-g -O0'

    for i in minix/kernel minix/fs minix/net minix/servers minix/drivers; do
        nbmake-i386 -C $i clean
        nbmake-i386 -C $i
        nbmake-i386 -C $i install
    done
else
    setup-lsp.sh -p i586-elf32-minix- -C .. $build_sh devel

    nbmake-i386 -C releasetools hdboot

    # create image
    export CREATE_IMAGE_ONLY=1
    ./releasetools/x86_hdimage.sh
fi

cd ..
