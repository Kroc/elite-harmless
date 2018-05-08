#!/usr/bin/sh

# "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
# "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
# <github.com/Kroc/EliteDX>
#===============================================================================

# stop further processing on any error
set -e

echo "building Elite DX:"
echo

echo "* building loader:"

echo "- assemble 'elite_consts.asm'"
./bin/cc65/bin/ca65 -t c64 -g -o build/elite_consts.o \
    src/elite_consts.asm
echo "- assemble 'loader_stage0.asm'"
./bin/cc65/bin/ca65 -t c64 -g -o build/loader_stage0.o \
    src/loader_stage0.asm
echo "- assemble 'loader_stage1.asm'"
./bin/cc65/bin/ca65 -t c64 -g -o build/loader_stage1.o \
    src/loader_stage1.asm
echo "- assemble 'loader_stage2.asm'"
./bin/cc65/bin/ca65 -t c64 -g -o build/loader_stage2.o \
    src/loader_stage2.asm
echo "- assemble 'loader_stage3_code.asm'"
./bin/cc65/bin/ca65 -t c64 -g -o build/loader_stage3_code.o \
    src/loader_stage3_code.asm
echo "- assemble 'loader_stage3_data.asm'"
./bin/cc65/bin/ca65 -t c64 -g -o build/loader_stage3_data.o \
    src/loader_stage3_data.asm

# the stage 0 loader is what gets loaded by `LOAD"*",8,1`
# its only purpose is to hijack BASIC and load the next stage
echo "-     link 'firebird.prg'"
./bin/cc65/bin/ld65 -C build/firebird.cfg -o bin/firebird.prg \
    build/loader_stage0.o \
    c64.lib

# the stage 1 loader contains the fast-loader code,
# but also a menu to opt for slow-loading
echo "-     link 'gma1.prg'"
./bin/cc65/bin/ld65 -C build/gma1.cfg \
    -o bin/gma1.prg \
    build/loader_stage1.o \
    build/loader_stage3_code.o \
    build/loader_stage3_data.o \
    build/elite_consts.o \
    c64.lib

echo "-     link 'gma3.prg'"
./bin/cc65/bin/ld65 -C c64-asm.cfg \
    --start-addr \$C800 -o bin/gma3.prg \
    build/loader_stage2.o \
    c64.lib

#-------------------------------------------------------------------------------

# "gma4.prg" will contain encrypted data/code blocks, so these areas of code
# have to be linked first, then encrypted and then re-linked. this link
# outputs the code and data-to-be-encrypted to seprate binaries:
#
# - "gma4_code.o" = the decryption routine
# - "gma4_data.o" = the binary to be encrypted and re-linked
#
echo "-     link 'gma4_*.bin'"
./bin/cc65/bin/ld65 -C build/gma4_decrypted.cfg -o build/gma4 \
    build/loader_stage3_code.o \
    build/loader_stage3_data.o \
    build/elite_consts.o

echo "-  encrypt 'gma4_data.bin'"
python3 build/encrypt.py \
    build/gma4_data.bin build/gma4_data.s

# assemble the newly encrypted data
echo "- assemble 'gma4_data.s'"
./bin/cc65/bin/ca65 -t c64 -g -o build/gma4_data.o \
    build/gma4_data.s

# now re-link with the encrypted binary blobs
echo "-     link 'gma4.prg'"
./bin/cc65/bin/ld65 -C build/gma4_encrypted.cfg -o bin/gma4.prg \
    build/loader_stage3_code.o \
    build/gma4_data.o \
    c64.lib

#-------------------------------------------------------------------------------

echo
echo "* verifying checksums"
cd bin
md5sum -c checksums.txt
cd ..

echo
echo "complete."
exit 0