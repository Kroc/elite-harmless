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
echo "- assemble 'prgheader.asm'"
$ca65 -o build/prgheader.o      src/prgheader.asm
echo "- assemble 'elite_0700.asm'"
$ca65 -o build/elite_0700.o     src/elite_0700.asm
echo "- assemble 'elite_font.asm'"
$ca65 -o build/elite_font.o     src/elite_font.asm
echo "- assemble 'elite_0E00.asm'"
$ca65 -o build/elite_0E00.o     src/elite_0E00.asm
echo "- assemble 'elite_1D00.asm'"
$ca65 -o build/elite_1D00.o     src/elite_1D00.asm
echo "- assemble 'elite_1D81.asm'"
$ca65 -o build/elite_1D81.o     src/elite_1D81.asm
echo "- assemble 'elite_init.asm'"
$ca65 -o build/elite_init.o     src/elite_init.asm
echo "- assemble 'elite_6A00.asm'"
$ca65 -o build/elite_6A00.o     src/elite_6A00.asm
echo "- assemble 'elite_hulls.asm'"
$ca65 -o build/elite_hulls.o    src/elite_hulls.asm

# let's build an original floppy disk to verify that we haven't broken
# the code or failed to preserve the original somewhere along the lines

echo
echo "* assemble GMA86 loader:"
echo "  ======================"
echo "- assemble 'loader/stage0.asm'"
$ca65 -o build/loader_stage0.o  src/loader/stage0.asm
echo "- assemble 'loader/stage1.asm'"
$ca65 -o build/loader_stage1.o  src/loader/stage1.asm
echo "- assemble 'loader/stage2.asm'"
$ca65 -o build/loader_stage2.o  src/loader/stage2.asm
echo "- assemble 'loader/stage3.asm'"
$ca65 -o build/loader_stage3.o  src/loader/stage3.asm
echo "- assemble 'loader/stage4.asm'"
$ca65 -o build/loader_stage4.o  src/loader/stage4.asm
echo "- assemble 'loader/stage5.asm'"
$ca65 -o build/loader_stage5.o  src/loader/stage5.asm

# loader stage 4:
#-------------------------------------------------------------------------------

# pack the data for the first encrypted block into a single binary file
echo "-     link 'gma4_data1.bin'"
$ld65 \
       -C build/gma4_data1.cfg \
       -o build/gma4_data1.bin \
    --obj build/elite_0700.o \
    --obj build/elite_font.o \
    --obj build/elite_0E00.o \
    --obj build/elite_hulls.o

# verify this is as expected before encrypting 
# (it's very hard to track down errors post-encryption!)
echo -n "-   verify 'gma4_data1.bin' "
if [[
    # note that this hash was produced by dumping $4000..$758F,
    # just after decryption (but before relocation)
    $(md5sum -b < build/gma4_data1.bin) \
 == "049a1004768ed1de4e220923ea865f78 *-"
]]; then
    echo "[OK]"
else
    echo "[FAIL]"
fi

# run the binary through the encrypt script, which will spit out an assembler
# file we can then re-link into the stage 4 loader ("GMA4.PRG")
echo "-  encrypt 'gma4_data1.bin'"
$encrypt 6C \
    build/gma4_data1.bin \
    build/gma4_data1.s \
    --segment "DATA1"

# assemble the first encrypted payload
echo "- assemble 'gma4_data1.s'"
$ca65 -o build/gma4_data1.o build/gma4_data1.s

# the second data block is trickier to handle as the location of the decryption
# routine is dependent on the size of the first block of data, but we don't
# want to include this in the output
echo "-     link 'gma4_data2.bin'"
$ld65 \
       -C build/gma4_data2.cfg \
       -o build/gma4_data2.bin \
    --obj build/gma4_data1.o \
    --obj build/loader_stage4.o \
    --obj build/elite_init.o

# verify this is as expected before encrypting 
# (it's very hard to track down errors post-encryption!)
echo -n "-   verify 'gma4_data2.bin' "
if [[
    # note that this hash was produced by dumping $75E4..$865F,
    # just after decryption (but before relocation)
    $(md5sum -b < build/gma4_data2.bin) \
 == "32cba4aa5d3ee363c0bdfb77e95c1fc3 *-"
]]; then
    echo "[OK]"
else
    echo "[FAIL]"
fi

# encrypt the second block
echo "-  encrypt 'gma4_data2.bin'"
$encrypt 8E \
    build/gma4_data2.bin \
    build/gma4_data2.s \
    --segment "DATA2"

# assemble the second encrypted payload
echo "- assemble 'gma_data2.s'"
$ca65 -o build/gma4_data2.o build/gma4_data2.s

# link the final program with both encrypted binary blobs
echo "-     link 'gma4.prg'"
$ld65 \
       -C build/gma4.cfg \
       -o bin/gma4.prg \
    --obj build/prgheader.o \
    --obj build/loader_stage4.o \
    --obj build/gma4_data1.o \
    --obj build/gma4_data2.o
    
# loader stage 5:
#-------------------------------------------------------------------------------

# convert the Elite code portion of this to a binary, for encrypting
echo "-     link 'gma5_data.bin'"
$ld65 \
       -C build/gma5_data.cfg \
       -o build/gma5_data.bin \
    --obj build/loader_stage5.o \
    --obj build/elite_1D00.o \
    --obj build/elite_1D81.o \
    --obj build/elite_6A00.o

# run the binary for the encrypt script, which will spit out an assembler file
echo "-  encrypt 'gma5_data.bin'"
$encrypt 36 \
    build/gma5_data.bin \
    build/gma5_data.s \
    --segment "DATA_GMA5"

# assemble the encrypted payload
echo "- assemble 'gma5_data.s'"
$ca65 -o build/gma5_data.o build/gma5_data.s

# link the final .PRG file
echo "-     link 'gma5.prg'"
$ld65 \
       -C build/gma5.cfg \
       -o bin/gma5.prg \
    --obj build/prgheader.o \
    --obj build/gma5_data.o \
    --obj build/elite_1D00.o \
    --obj build/loader_stage5.o \
    --obj build/elite_1D81.o \
    --obj build/elite_6A00.o

# loader stage 6:
#-------------------------------------------------------------------------------

# convert the source to a binary as-is
echo "-     link 'gma6.bin'"
$ld65 \
       -C build/gma6_bin.cfg \
       -o build/gma6.bin \
    --obj build/elite_6A00.o \
    --obj build/elite_1D00.o \
    --obj build/loader_stage5.o \
    --obj build/elite_1D81.o

# run the binary for the encrypt script, which will spit out an assembler file,
# this gets included in the relevant position by the stage 6 loader (GMA6.PRG)
echo "-  encrypt 'gma6.bin'"
$encrypt 49 build/gma6.bin build/gma6_bin.s
# assemble the stage 6 loader, with the encrypted binary payload
echo "- assemble 'loader/stage6.asm'"
$ca65 -o build/loader_stage6.o  src/loader/stage6.asm

#-------------------------------------------------------------------------------

# the stage 0 loader is what gets loaded by `LOAD"*",8,1`
# its only purpose is to hijack BASIC and load the next stage
echo "-     link 'firebird.prg'"
$ld65 \
       -C build/firebird.cfg \
       -o bin/firebird.prg \
    --obj build/prgheader.o \
    --obj build/loader_stage0.o

# the stage 1 loader contains the fast-loader code,
# but also a menu to opt for slow-loading
echo "-     link 'gma1.prg'"
$ld65 \
       -C build/gma1.cfg \
       -o bin/gma1.prg \
    --obj build/prgheader.o \
    --obj build/loader_stage1.o \
    --obj build/elite_1D00.o \
    --obj build/loader_stage5.o \
    --obj build/elite_1D81.o \
    --obj build/elite_6A00.o

echo "-     link 'byebyejulie.prg'"
$ld65 \
       -C build/c64-prg.cfg \
       -o bin/byebyejulie.prg \
    --obj build/prgheader.o \
    --obj build/loader_stage2.o

echo "-     link 'gma3.prg'"
$ld65 \
       -C build/c64-prg.cfg \
       -o bin/gma3.prg \
       -S \$C800 \
    --obj build/prgheader.o \
    --obj build/loader_stage3.o

echo "-     link 'gma6.prg'"
$ld65 \
       -C build/gma6_encrypted.cfg \
       -o bin/gma6.prg \
    --obj build/prgheader.o \
    --obj build/loader_stage6.o

#-------------------------------------------------------------------------------

echo
echo "* write floppy disk image"
$mkd64 \
    -o bin/elite_gma86.d64 \
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

#-------------------------------------------------------------------------------

echo
echo "* verifying checksums"
cd bin
md5sum --ignore-missing --quiet --check checksums.md5
if [ $? -eq 0 ]; then echo "- OK"; fi
cd ..

echo
echo "complete."
exit 0