#!/usr/bin/sh

echo "building Elite DX:"
echo

echo "* building loader:"

# the stage 0 loader is what gets loaded by `LOAD"*",8,1`
# its only purpose is to hijack BASIC and load the next stage
echo "- assembling 'loader_stage0.asm'..."
./bin/cc65/bin/ca65 -t c64 -g -o build/loader_stage0.o \
    src/loader_stage0.asm
echo "- assembling 'loader_stage1.asm'..."
./bin/cc65/bin/ca65 -t c64 -g -o build/loader_stage1.o \
    src/loader_stage1.asm
echo "- assembling 'loader_stage2.asm'..."
./bin/cc65/bin/ca65 -t c64 -g -o build/loader_stage2.o \
    src/loader_stage2.asm
echo "- assembling 'loader_stage3.asm'..."
./bin/cc65/bin/ca65 -t c64 -g -o build/loader_stage3.o \
    src/loader_stage3.asm

echo "- assembling 'loader_stage3b.asm'..."
./bin/cc65/bin/ca65 -t c64 -g -o build/loader_stage3b.o \
    src/loader_stage3b.asm

echo "- linking 'firebird.prg'..."
./bin/cc65/bin/ld65 -C c64-asm.cfg \
    --start-addr \$02A7 -o bin/firebird.prg \
    build/loader_stage0.o \
    c64.lib

echo "- linking 'gma1.prg'..."
./bin/cc65/bin/ld65 -C c64-asm.cfg \
    --start-addr \$0334 -o bin/gma1.prg \
    build/loader_stage1.o \
    build/loader_stage3.o \
    c64.lib

echo "- linking 'gma3.prg'..."
./bin/cc65/bin/ld65 -C c64-asm.cfg \
    --start-addr \$C800 -o bin/gma3.prg \
    build/loader_stage2.o \
    c64.lib

echo "- linking 'gma4.prg'..."
./bin/cc65/bin/ld65 -C c64-asm.cfg \
    --start-addr \$4000 -o bin/gma4.prg \
    build/loader_stage3.o \
    c64.lib

echo
echo "* verifying checksums"
cd bin
md5sum -c checksums.txt
cd ..

echo
echo "complete."
exit 0