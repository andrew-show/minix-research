#!/bin/sh

gdb -ex='target remote localhost:1234' $PWD/obj.i386/destdir.i386/boot/minix/.temp/kernel
