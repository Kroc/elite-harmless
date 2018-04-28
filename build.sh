#!/usr/bin/sh

echo "* building loader - stage 0:"

echo "- compiling 'loader_stage0.asm'..."
./bin/cc65/bin/ca65 -t c64 -g -o build/loader_stage0.o src/loader_stage0.asm

echo "- linking 'firebird.prg'..."

./bin/cc65/bin/ld65 -C c64-asm.cfg --start-addr \$02A7 -o bin/firebird.prg \
    build/loader_stage0.o \
    c64.lib

exit 0