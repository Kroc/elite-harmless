#!/usr/bin/sh

# "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
# "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
# <github.com/Kroc/EliteDX>
#===============================================================================

# stop further processing on any error
set -e


ca65="./bin/cc65/bin/ca65 \
    --target c64 \
    --debug-info \
    --include-dir src \
    --include-dir build \
    --bin-include-dir build \
    --feature leading_dot_in_identifiers"
ld65="./bin/cc65/bin/ld65"
mkd64="./bin/mkd64/bin/mkd64"
encrypt="python3 link/encrypt.py"


clear
echo "building Elite DX:"
echo

echo "* cleaning up:"

rm -rf build/*.o
rm -rf build/*.s
rm -rf build/*.bin
rm -rf build/*.prg
rm -rf build/*.d64

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
echo "- assemble 'elite_consts.asm'"
$ca65 -o build/elite_consts.o   src/elite_consts.asm
echo "- assemble 'data_0700.asm'"
$ca65 -o build/data_0700.o      src/data_0700.asm
echo "- assemble 'gfx_font.asm'"
$ca65 -o build/gfx_font.o       src/gfx/font.asm
echo "- assemble 'data_0E00.asm'"
$ca65 -o build/data_0E00.o      src/data_0E00.asm
echo "- assemble 'data_1D00.asm'"
$ca65 -o build/data_1D00.o      src/data_1D00.asm
echo "- assemble 'elite_1D81.asm'"
$ca65 -o build/elite_1D81.o     src/elite_1D81.asm
echo "- assemble 'elite_init.asm'"
$ca65 -o build/elite_init.o     src/elite_init.asm
echo "- assemble 'gfx_sprites.asm'"
$ca65 -o build/gfx_sprites.o    src/gfx/sprites.asm
echo "- assemble 'elite_6A00.asm'"
$ca65 -o build/elite_6A00.o     src/elite_6A00.asm
echo "- assemble 'gfx_hulls.asm'"
$ca65 -o build/gfx_hulls.o      src/gfx/hulls.asm
echo "- assemble 'gfx_hud.asm'"
$ca65 -o build/gfx_hud.o        src/gfx/hud.asm

# let's try ham-fistedly link our own PRG without the loader
echo
echo "* build Elite DX (incomplete)"
echo "  ==========================="
echo "- link 'elite-dx.prg'"
$ld65 \
       -C link/elite_dx.cfg \
       -o bin/elite-dx.prg \
    --obj build/prgheader.o \
    --obj build/elite_consts.o \
    --obj build/data_0700.o \
    --obj build/gfx_font.o \
    --obj build/data_0E00.o \
    --obj build/data_1D00.o \
    --obj build/elite_1D81.o \
    --obj build/gfx_sprites.o \
    --obj build/elite_6A00.o \
    --obj build/gfx_hulls.o \
    --obj build/gfx_hud.o

# let's build an original floppy disk to verify that we haven't broken
# the code or failed to preserve the original somewhere along the lines

echo
echo "* assemble GMA86 loader:"
echo "  ======================"
echo "- assemble 'loader/stage0.asm'"
$ca65 -o build/loader/stage0.o  src/loader/stage0.asm
echo "- assemble 'loader/stage1.asm'"
$ca65 -o build/loader/stage1.o  src/loader/stage1.asm
echo "- assemble 'loader/stage2.asm'"
$ca65 -o build/loader/stage2.o  src/loader/stage2.asm
echo "- assemble 'loader/stage3.asm'"
$ca65 -o build/loader/stage3.o  src/loader/stage3.asm
echo "- assemble 'loader/stage4.asm'"
$ca65 -o build/loader/stage4.o  src/loader/stage4.asm
echo "- assemble 'loader/stage5.asm'"
$ca65 -o build/loader/stage5.o  src/loader/stage5.asm
echo "- assemble 'loader/stage6.asm'"
$ca65 -o build/loader/stage6.o  src/loader/stage6.asm

# loader stage 6:
#-------------------------------------------------------------------------------

# convert the source to a binary as-is
echo "-     link 'gma6_data.bin'"
$ld65 \
       -C link/loader/gma6_data.cfg \
       -o build/loader/gma6_data.bin \
    --obj build/elite_consts.o \
    --obj build/data_0700.o \
    --obj build/gfx_font.o \
    --obj build/data_0E00.o \
    --obj build/data_1D00.o \
    --obj build/loader/stage5.o \
    --obj build/elite_1D81.o \
    --obj build/elite_6A00.o

# run the binary for the encrypt script, which will spit out an assembler file
echo "-  encrypt 'gma6_data.bin'"
$encrypt 49 build/loader/gma6_data.bin build/loader/gma6_data.s

# assemble the encrypted payload
echo "- assemble 'gma6_data.s'"
$ca65 -o build/loader/gma6_data.o  build/loader/gma6_data.s

# link the final .PRG file
echo "-     link 'gma6.prg'"
$ld65 \
       -C link/loader/gma6.cfg \
       -o bin/gma6.prg \
    --obj build/prgheader.o \
    --obj build/data_0700.o \
    --obj build/gfx_font.o \
    --obj build/data_0E00.o \
    --obj build/loader/gma6_data.o \
    --obj build/loader/stage6.o

#-------------------------------------------------------------------------------

# the stage 0 loader is what gets loaded by `LOAD"*",8,1`, its only purpose is
# to hijack BASIC and load the next stage. it jumps into GMA1.PRG once loaded,
# which necessitates a whole ton of cross-linking (this to clean-up / improve) 
echo "-     link 'firebird.prg'"
$ld65 \
       -C link/loader/firebird.cfg \
       -o bin/firebird.prg \
    --obj build/prgheader.o \
    --obj build/elite_consts.o \
    --obj build/loader/stage0.o \
    --obj build/loader/stage1.o \
    --obj build/loader/stage4.o \
    --obj build/loader/stage5.o \
    --obj build/elite_6A00.o \
    --obj build/data_1D00.o \
    --obj build/elite_1D81.o \
    --obj build/data_0700.o \
    --obj build/gfx_font.o \
    --obj build/data_0E00.o \
    --obj build/elite_init.o \
    --obj build/gfx_hud.o \
    --obj build/gfx_sprites.o \
    --obj build/loader/gma4_7C3A.o \
    --obj build/gfx_hulls.o

# the stage 1 loader contains the fast-loader code,
# but also a menu to opt for slow-loading
echo "-     link 'gma1.prg'"
$ld65 \
       -C link/loader/gma1.cfg \
       -o bin/gma1.prg \
    --obj build/prgheader.o \
    --obj build/elite_consts.o \
    --obj build/loader/stage1.o \
    --obj build/data_0700.o \
    --obj build/gfx_font.o \
    --obj build/data_0E00.o \
    --obj build/data_1D00.o \
    --obj build/loader/stage5.o \
    --obj build/elite_1D81.o \
    --obj build/elite_6A00.o \
    --obj build/loader/stage4.o \
    --obj build/elite_init.o \
    --obj build/gfx_hud.o \
    --obj build/loader/gma4_7C3A.o \
    --obj build/gfx_sprites.o \
    --obj build/gfx_hulls.o

echo "-     link 'byebyejulie.prg'"
$ld65 \
       -C link/c64-prg.cfg \
       -o bin/byebyejulie.prg \
    --obj build/prgheader.o \
    --obj build/loader/stage2.o

echo "-     link 'gma3.prg'"
$ld65 \
       -C link/c64-prg.cfg \
       -o bin/gma3.prg \
       -S \$C800 \
    --obj build/prgheader.o \
    --obj build/loader/stage3.o

#===============================================================================

# let's attempt to link the whole program at once;
# this is bad, and kills the program

echo
echo "* build 'elite-gma86.prg'"
echo "  ======================="
echo "-     link 'elite-gma86.cfg'"
$ld65 \
       -C link/loader/gma86.cfg \
       -o build/elite-gma86.prg \
    --obj build/elite_consts.o \
    --obj build/loader/stage0.o \
    --obj build/loader/stage1.o \
    --obj build/loader/stage5.o \
    --obj build/elite_6A00.o \
    --obj build/data_1D00.o \
    --obj build/elite_1D81.o \
    --obj build/data_0700.o \
    --obj build/gfx_font.o \
    --obj build/data_0E00.o \
    --obj build/loader/stage4.o \
    --obj build/gfx_hulls.o \
    --obj build/elite_init.o \
    --obj build/loader/gma4_7C3A.o \
    --obj build/gfx_hud.o \
    --obj build/gfx_sprites.o

# encrypt GMA4.PRG:
#-------------------------------------------------------------------------------

# verify that the packed data is correct:
# (this will be harder to debug once encrypted)
echo -n "-   verify 'gma4_data1.bin' "
if [[
    # note that this hash was produced by dumping $4000...$758F,
    # just after decryption (but before relocation)
    $(md5sum -b < build/loader/gma4_data1.bin) \
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
    build/loader/gma4_data1.bin \
    build/loader/gma4_data1.s \

# verify that the packed data is correct:
# (this will be harder to debug once encrypted)
echo -n "-   verify 'gma4_data2.bin' "
if [[
    # note that this hash was produced by dumping $75E4...$865F,
    # just after decryption (but before relocation)
    $(md5sum -b < build/loader/gma4_data2.bin) \
 == "32cba4aa5d3ee363c0bdfb77e95c1fc3 *-"
]]; then
    echo "[OK]"
else
    echo "[FAIL]"
fi

# encrypt the second block
echo "-  encrypt 'gma4_data2.bin'"
$encrypt 8E \
    build/loader/gma4_data2.bin \
    build/loader/gma4_data2.s \

echo "- assemble 'gma4.asm'"
$ca65 -o build/loader/gma4.o    src/loader/gma4.asm

echo "-     link 'gma4.prg'"
$ld65 \
       -C link/c64-prg.cfg \
       -S \$4000 \
       -o bin/gma4.prg \
    --obj build/prgheader.o \
    --obj build/loader/gma4.o

# encrypt GMA5.PRG:
#-------------------------------------------------------------------------------

echo "-  encrypt 'gma5_data.bin'"
$encrypt 36 \
    build/loader/gma5_data.bin \
    build/loader/gma5_data.s

echo "- assemble 'gma5.asm'"
$ca65 -o build/loader/gma5.o    src/loader/gma5.asm

echo "-     link 'gma5.prg'"
$ld65 \
       -C link/c64-prg.cfg \
       -S \$1D00 \
       -o bin/gma5.prg \
    --obj build/prgheader.o \
    --obj build/loader/gma5.o

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

#===============================================================================

echo
echo "complete."
exit 0