#!/bin/bash

devel=no
if [ "X$1" == "Xdevel" ]; then
    devel=yes
fi
build_sh=$0

if [ ! -d src ]; then
    # download and extract source code
    wget https://github.com/Stichting-MINIX-Research-Foundation/minix/archive/refs/tags/v3.3.0.tar.gz
    tar xvf v3.3.0.tar.gz

    mv minix-3.3.0 src

    # apply patches to fix build issue
    cd src
    cat ../patches/*.patch | patch -p1
    cd ..
fi

if [ ! -d ./obj.i386 ]; then
    # build tools and minix
    export JOBS=8
    cd src
    ./releasetools/x86_hdimage.sh
    cd ..
fi

if [ $devel == "yes" ]; then
    # rebuild kenel with debug enabled
    export PATH=$PWD/obj.i386/tooldir.`uname -s`-`uname -r`-`uname -m`/bin:$PATH
    export DBG='-g -O0'

    for i in minix/lib minix/kernel minix/fs minix/net minix/servers minix/drivers; do
        nbmake-i386 -C src/$i clean
        nbmake-i386 -C src/$i
        nbmake-i386 -C src/$i install
    done

    nbmake-i386 -C src/releasetools hdboot
else
    setup-lsp.sh -p i586-elf32-minix- $build_sh devel

    # create image
    cd src
    CREATE_IMAGE_ONLY=1 ./releasetools/x86_hdimage.sh
    cd ..
fi
