#!/bin/sh

GDBINIT=/tmp/.gdbinit-$$

cat > $GDBINIT <<EOF
file $PWD/obj.i386/destdir.i386/boot/minix/.temp/kernel
target remote localhost:1234
add-symbol-file $PWD/obj.i386/destdir.i386/boot/minix/.temp/mod01_ds
add-symbol-file $PWD/obj.i386/destdir.i386/boot/minix/.temp/mod02_rs
add-symbol-file $PWD/obj.i386/destdir.i386/boot/minix/.temp/mod03_pm
add-symbol-file $PWD/obj.i386/destdir.i386/boot/minix/.temp/mod04_sched
add-symbol-file $PWD/obj.i386/destdir.i386/boot/minix/.temp/mod05_vfs
add-symbol-file $PWD/obj.i386/destdir.i386/boot/minix/.temp/mod06_memory
add-symbol-file $PWD/obj.i386/destdir.i386/boot/minix/.temp/mod07_tty
add-symbol-file $PWD/obj.i386/destdir.i386/boot/minix/.temp/mod08_mfs
add-symbol-file $PWD/obj.i386/destdir.i386/boot/minix/.temp/mod09_vm
add-symbol-file $PWD/obj.i386/destdir.i386/boot/minix/.temp/mod10_pfs
add-symbol-file $PWD/obj.i386/destdir.i386/boot/minix/.temp/mod11_init
br pre_init
layout src
c
EOF

gdb -x $GDBINIT

rm $GDBINIT
