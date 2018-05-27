#!/usr/bin/sh

# "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
# "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
# <github.com/Kroc/EliteDX>
#===============================================================================

# stop further processing on any error
set -e


ca65="./bin/cc65/bin/ca65 --target c64 --debug-info \
    --include-dir src \
    --include-dir build \
    --feature leading_dot_in_identifiers"
ld65="./bin/cc65/bin/ld65"
mkd64="./bin/mkd64/bin/mkd64"
encrypt="python3 build/encrypt.py"


clear
echo "building Elite DX:"
echo

echo "* cleaning up:"

rm -f build/*.o
rm -f build/*.s
rm -f build/*.bin
rm -f build/*.prg
rm -f build/*.d64

rm -f bin/*.prg
rm -f bin/*.d64

echo "- OK"

# assemble the stand-alone Elite code into object files;
# these can be linked into program files in whichever order we please later

echo
echo "* assemble Elite source code:"
echo "  ==========================="
echo "- assemble 'elite_init.asm'"
$ca65 -o build/elite_init.o src/elite_init.asm
echo "- assemble 'elite_1D00.asm'"
$ca65 -o build/elite_1D00.o src/elite_1D00.asm
echo "- assemble 'elite_1D81.asm'"
$ca65 -o build/elite_1D81.o src/elite_1D81.asm
echo "- assemble 'elite_6A00.asm'"
$ca65 -o build/elite_6A00.o src/elite_6A00.asm

# let's build an original floppy disk to verify that we haven't broken
# the code or failed to preserve the original somewhere along the lines

echo
echo "* assemble GMA86 loader:"
echo "  ======================"
echo "- assemble 'loader/stage0.asm'"
$ca65 -o build/loader_stage0.o      src/loader/stage0.asm
echo "- assemble 'loader/stage1.asm'"
$ca65 -o build/loader_stage1.o      src/loader/stage1.asm
echo "- assemble 'loader/stage2.asm'"
$ca65 -o build/loader_stage2.o      src/loader/stage2.asm
echo "- assemble 'loader/stage3.asm'"
$ca65 -o build/loader_stage3.o      src/loader/stage3.asm
echo "- assemble 'loader/stage5.asm'"
$ca65 -o build/loader_stage5.o      src/loader/stage5.asm

# loader stage 4:
#-------------------------------------------------------------------------------

# assemble the original source, before encrypting
echo "- assemble 'gma4_4000.asm'"
$ca65 -o build/gma4_4000.o src/loader/gma4_4000.asm
# simply convert this to a binary as-is
echo "-     link 'gma4_4000.bin'"
$ld65 -C build/gma4_bin.cfg -o build/gma4_4000.bin build/gma4_4000.o
# run the binary for the encrypt script, which will spit out an assembler file,
# this gets included in the relevant position by the stage 4 loader (GMA4.PRG)
echo "-  encrypt 'gma4_4000.bin'"
$encrypt build/gma4_4000.bin build/gma4_4000.s
# assemble the stage 4 loader, with the encrypted binary payload
echo "- assemble 'loader/stage4.asm'"
$ca65 -o build/loader_stage4.o src/loader/stage4.asm

# loader stage 5:
#-------------------------------------------------------------------------------

# convert the Elite code portion of this to a binary, for encrypting; this will
# split the code/data into "gma5_code.bin" (unused), the unencrypted area, and
# "gma5_data.bin" the block to be encypted
echo "-     link 'gma5.bin'"
$ld65 -C build/gma5_bin.cfg -o build/gma5 \
    build/loader_stage5.o \
    build/elite_1D00.o \
    build/elite_1D81.o
# run the binary for the encrypt script, which will spit out an assembler file
echo "-  encrypt 'gma5.bin'"
$encrypt build/gma5_data.bin build/gma5_bin.s
# assemble the stage 5 loader, with encrypted binary payload
echo "- assemble 'loader/gma5.asm'"
$ca65 -o build/gma5.o src/loader/gma5.asm

# link the final .PRG file
echo "-     link 'gma5.prg'"
$ld65 -C build/gma5.cfg -o bin/gma5.prg \
    build/gma5.o \
    build/elite_1D00.o \
    build/loader_stage5.o \
    c64.lib

# loader stage 6:
#-------------------------------------------------------------------------------

# convert the source to a binary as-is
echo "-     link 'gma6.bin'"
$ld65 -C build/gma6_bin.cfg -o build/gma6.bin \
    build/elite_6A00.o \
    build/elite_1D00.o \
    build/loader_stage5.o \
    build/elite_1D81.o
# run the binary for the encrypt script, which will spit out an assembler file,
# this gets included in the relevant position by the stage 6 loader (GMA6.PRG)
echo "-  encrypt 'gma6.bin'"
$encrypt build/gma6.bin build/gma6_bin.s
# assemble the stage 6 loader, with the encrypted binary payload
echo "- assemble 'loader/stage6.asm'"
$ca65 -o build/loader_stage6.o  src/loader/stage6.asm

#-------------------------------------------------------------------------------

# the stage 0 loader is what gets loaded by `LOAD"*",8,1`
# its only purpose is to hijack BASIC and load the next stage
echo "-     link 'firebird.prg'"
$ld65 -C build/firebird.cfg -o bin/firebird.prg \
    build/loader_stage0.o \
    c64.lib

# the stage 1 loader contains the fast-loader code,
# but also a menu to opt for slow-loading
echo "-     link 'gma1.prg'"
$ld65 -C build/gma1.cfg \
    -o bin/gma1.prg \
    build/loader_stage1.o \
    build/loader_stage4.o \
    build/elite_init.o \
    build/elite_1D00.o \
    build/loader_stage5.o \
    c64.lib

echo "-     link 'byebyejulie.prg'"
$ld65 -C c64-asm.cfg -o bin/byebyejulie.prg \
    build/loader_stage2.o \
    c64.lib

echo "-     link 'gma3.prg'"
$ld65 -C c64-asm.cfg \
    --start-addr \$C800 -o bin/gma3.prg \
    build/loader_stage3.o \
    c64.lib

# "gma4.prg" will contain encrypted data/code blocks, so these areas of code
# have to be linked first, then encrypted and then re-linked. this link
# outputs the code and data-to-be-encrypted to seprate binaries:
#
# - "gma4_code.o" = the decryption routine
# - "gma4_data.o" = the binary to be encrypted and re-linked
#
echo "-     link 'gma4_*.bin'"
$ld65 -C build/gma4_decrypted.cfg -o build/gma4 \
    build/loader_stage4.o \
    build/elite_init.o

echo "-  encrypt 'gma4_data.bin'"
$encrypt build/gma4_data.bin build/gma4_data.s

# assemble the newly encrypted data
echo "- assemble 'gma4_data.s'"
$ca65 -o build/gma4_data.o \
    build/gma4_data.s

# now re-link with the encrypted binary blobs
echo "-     link 'gma4.prg'"
$ld65 -C build/gma4_encrypted.cfg -o bin/gma4.prg \
    build/loader_stage4.o \
    build/gma4_data.o \
    c64.lib

# re-link with the encrypted binary blobs
echo "-     link 'gma6.prg'"
$ld65 -C build/gma6_encrypted.cfg -o bin/gma6.prg \
    build/loader_stage6.o \
    c64.lib

#-------------------------------------------------------------------------------

echo
echo "* verifying checksums"
cd bin
md5sum --ignore-missing --quiet --check checksums.txt
if [ $? -eq 0 ]; then echo "- OK"; fi
cd ..

#-------------------------------------------------------------------------------

echo
echo "* write floppy disk image"
$mkd64 -o bin/elite_gma86.d64 \
    -m xtracks -XDS \
    -m cbmdos -d "ELITE 040486" -i "GMA86" \
    -f bin/firebird.prg     -t 17 -s 0 -n "FIREBIRD"    -P -S 1 -w \
    -f bin/gma1.prg         -t 17 -s 1 -n "GMA1"        -P -S 2 -w \
    -f bin/byebyejulie.prg  -t 17 -s 4 -n "BYEBYEJULIE" -P -S 3 -w \
    -f bin/gma3.prg         -t 17 -s 5 -n "GMA3"        -P -S 4 -w \
    -f bin/gma4.prg         -t 17 -s 6 -n "GMA4"        -P -S 5 -w \
    -f bin/gma5.prg         -t 19 -s 0 -n "GMA5"        -P -S 6 -w \
    -f bin/gma6.prg         -t 20 -s 8 -n "GMA6"        -P -S 7 -w \
    1>/dev/null
echo "- OK"

echo
echo "complete."
exit 0