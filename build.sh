#!/usr/bin/sh

# Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
# see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
# All Rights Reserved. <github.com/Kroc/elite-harmless>
#===============================================================================

# stop further processing on any error
set -e

clean() {
    echo "* cleaning up:"

    rm -rf build/*.o
    rm -rf build/*.s
    rm -rf build/*.bin
    rm -rf build/*.prg
    rm -rf build/*.d64
    rm -rf build/*.crt

    rm -f bin/*.prg
    rm -f bin/*.d64
    rm -f bin/*.crt

    echo "- OK"
}

#===============================================================================

ca65="./bin/cc65/bin/ca65 \
    --target c64 \
    --debug-info \
    --include-dir src \
    --include-dir build \
    --bin-include-dir build \
    --feature leading_dot_in_identifiers \
    --feature bracket_as_indirect"
ld65="ld65"
mkd64="mkd64"
encrypt="python3 link/encrypt.py"
exomizer="./bin/exomizer/src/exomizer sfx"


clear
echo "building Elite : Harmless"
echo

clean

# build an original version of the game, including the original fast-loader

echo
echo "* build original Elite"
echo "  ======================================"

echo "- assemble 'prgheader.asm'"
$ca65 -o build/prgheader.o      src/c64/prgheader.asm

# assemble 'original' version of the code; the `OPTION_ORIGINAL` symbol
# is used within the files to exlcude changed code from the original

options="-DOPTION_ORIGINAL"

echo "- assemble 'orig_init.asm'"
$ca65 $options -o build/orig-init.o             src/orig_init.asm
echo "- assemble 'text_pairs.asm'"
$ca65 $options -o build/orig-text_pairs.o       src/text/text_pairs.asm
echo "- assemble 'text_flight.asm'"
$ca65 $options -o build/orig-text_flight.o      src/text/text_flight.asm
echo "- assemble 'text_docked.asm'"
$ca65 $options -o build/orig-text_docked.o      src/text/text_docked.asm
echo "- assemble 'vars_1D00.asm'"
$ca65 $options -o build/orig-vars_1D00.o        src/vars_1D00.asm
echo "- assemble 'code_1D81.asm'"
$ca65 $options -o build/orig-code_1D81.o        src/code_1D81.asm
echo "- assemble 'code_6A00.asm'"
$ca65 $options -o build/orig-code_6A00.o        src/code_6A00.asm
echo "- assemble 'table_bitmap.asm'"
$ca65 $options -o build/orig-table_bitmap.o     src/gfx/table_bitmap.asm
echo "- assemble 'sound.asm'"
$ca65 $options -o build/orig-sound.o            src/sound.asm
echo "- assemble 'gfx-font.asm'"
$ca65 $options -o build/orig-gfx_font.o         src/gfx/font.asm
echo "- assemble 'gfx-sprites.asm'"
$ca65 $options -o build/orig-gfx_sprites.o      src/gfx/sprites.asm
echo "- assemble 'math_data.asm'"
$ca65 $options -o build/orig-math_data.o        src/math_data.asm
echo "- assemble 'gfx-hull_data.asm'"
$ca65 $options -o build/orig-gfx_hull_data.o    src/gfx/hull_data.asm
echo "- assemble 'gfx-hud_data.asm'"
$ca65 $options -o build/orig-gfx_hud_data.o     src/gfx/hud_data.asm
echo "- assemble 'vars_polyobj.asm'"
$ca65 $options -o build/orig-vars_polyobj.o     src/vars_polyobj.asm
echo "- assemble 'elite_link.asm'"
$ca65 $options -o build/orig-link.o             src/elite_link.asm

#-------------------------------------------------------------------------------

# let's build an original floppy disk to verify that we haven't broken
# the code or failed to preserve the original somewhere along the lines

echo
echo "* assemble GMA86 loader"
echo "  --------------------------------------"
echo "- assemble 'boot/gma/stage0.asm'"
$ca65 -o build/boot_gma_stage0.o        src/boot/gma/stage0.asm
echo "- assemble 'boot/gma/stage1.asm'"
$ca65 -o build/boot_gma_stage1.o        src/boot/gma/stage1.asm
echo "- assemble 'boot/gma/stage2.asm'"
$ca65 -o build/boot_gma_stage2.o        src/boot/gma/stage2.asm
echo "- assemble 'boot/gma/stage3.asm'"
$ca65 -o build/boot_gma_stage3.o        src/boot/gma/stage3.asm
echo "- assemble 'boot/gma/stage4.asm'"
$ca65 -o build/boot_gma_stage4.o        src/boot/gma/stage4.asm
echo "- assemble 'boot/gma/gma4_7C3A.asm'"
$ca65 -o build/boot_gma_stage4_7C3A.o   src/boot/gma/stage4_7C3A.asm
echo "- assemble 'boot/gma/stage5.asm'"
$ca65 -o build/boot_gma_stage5.o        src/boot/gma/stage5.asm
echo "- assemble 'boot/gma/stage6.asm'"
$ca65 -o build/boot_gma_stage6.o        src/boot/gma/stage6.asm

echo
echo "* make 'elite-original-gma86.d64'"
echo "  --------------------------------------"
echo "-     link 'elite-original-gma86.cfg'"
$ld65 \
       -C link/elite-original-gma86.cfg \
       -m build/elite-original-gma86.map -vm \
    --obj build/orig-link.o \
    --obj build/boot_gma_stage0.o \
    --obj build/boot_gma_stage1.o \
    --obj build/boot_gma_stage2.o \
    --obj build/boot_gma_stage3.o \
    --obj build/boot_gma_stage4.o \
    --obj build/boot_gma_stage5.o \
    --obj build/boot_gma_stage6.o \
    --obj build/boot_gma_stage4_7C3A.o \
    --obj build/orig-text_pairs.o \
    --obj build/orig-text_flight.o \
    --obj build/orig-text_docked.o \
    --obj build/orig-vars_1D00.o \
    --obj build/orig-init.o \
    --obj build/orig-code_1D81.o \
    --obj build/orig-code_6A00.o \
    --obj build/orig-table_bitmap.o \
    --obj build/orig-sound.o \
    --obj build/orig-gfx_font.o \
    --obj build/orig-gfx_sprites.o \
    --obj build/orig-math_data.o \
    --obj build/orig-gfx_hud_data.o \
    --obj build/orig-gfx_hull_data.o \
    --obj build/orig-vars_polyobj.o

# encrypt GMA4.PRG:
#-------------------------------------------------------------------------------

# verify that the packed data is correct:
# (this will be harder to debug once encrypted)
echo -n "-   verify 'gma4_data1.bin' "
if [[
    # note that this hash was produced by dumping $4000...$758F,
    # just after decryption (but before relocation)
    $(md5sum -b < build/gma4_data1.bin) \
 == "049a1004768ed1de4e220923ea865f78 *-"
]]; then
    echo "[OK]"
else
    echo "[FAIL]"
    exit 1
fi

# run the binary through the encrypt script, which will spit out an assembler
# file we can then re-link into the stage 4 loader ("GMA4.PRG")
echo "-  encrypt 'gma4_data1.bin'"
$encrypt 6C \
    build/gma4_data1.bin \
    build/gma4_data1.bin

# verify that the packed data is correct:
# (this will be harder to debug once encrypted)
echo -n "-   verify 'gma4_data2.bin' "
if [[
    # note that this hash was produced by dumping $75E4...$865F,
    # just after decryption (but before relocation)
    $(md5sum -b < build/gma4_data2.bin) \
 == "32cba4aa5d3ee363c0bdfb77e95c1fc3 *-"
]]; then
    echo "[OK]"
else
    echo "[FAIL]"
    exit 1
fi

# encrypt the second block
echo "-  encrypt 'gma4_data2.bin'"
$encrypt 8E \
    build/gma4_data2.bin \
    build/gma4_data2.bin

echo "-   concat 'gma4.prg'"
cat "build/gma4_prg.bin" \
    "build/gma4_data1.bin" \
    "build/gma4_junk1.bin" \
    "build/gma4_code.bin" \
    "build/gma4_data2.bin" \
    "build/gma4_junk2.bin" \
>   "bin/gma4.prg"

# encrypt GMA5.PRG:
#-------------------------------------------------------------------------------

echo "-  encrypt 'gma5_data.bin'"
$encrypt 36 \
    build/gma5_data.bin \
    build/gma5_data.bin

echo "-   concat 'gma5.prg'"
cat "build/gma5_code.prg" \
    "build/gma5_data.bin" \
    "build/gma5_junk.bin" \
>   "bin/gma5.prg"

# encrypt GMA6.PRG:
#-------------------------------------------------------------------------------

echo "-  encrypt 'gma6_data.bin'"
$encrypt 49 \
    build/gma6_data.bin \
    build/gma6_data.bin

echo "-   concat 'gma6.prg'"
cat "build/gma6_prg.bin" \
    "build/gma6_data.bin" \
    "build/gma6_junk.bin" \
>   "bin/gma6.prg"

#-------------------------------------------------------------------------------

echo
echo "* write floppy disk image"
$mkd64 \
    -o release/elite-original-gma86.d64 \
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

##
##exit 0
##

#===============================================================================

echo
echo "* build Elite : Harmless (disk images)"
echo "  ======================================"
echo "* elite-harmless.d64"
echo "  --------------------------------------"
clean

options="-DOPTION_MATHTABLES"

echo
echo "- assemble 'disk_boot_exo.asm'"
$ca65 $options -o build/disk_boot_exo.o     src/boot/disk_boot_exo.asm
echo "- assemble 'code_init.asm'"
$ca65 $options -o build/code_init.o         src/code_init.asm
echo "- assemble 'text_pairs.asm'"
$ca65 $options -o build/text_pairs.o        src/text/text_pairs.asm
echo "- assemble 'text_flight.asm'"
$ca65 $options -o build/text_flight.o       src/text/text_flight.asm
echo "- assemble 'text_docked.asm'"
$ca65 $options -o build/text_docked.o       src/text/text_docked.asm
echo "- assemble 'vars_1D00.asm'"
$ca65 $options -o build/vars_1D00.o         src/vars_1D00.asm
echo "- assemble 'code_1D81.asm'"
$ca65 $options -o build/code_1D81.o         src/code_1D81.asm
echo "- assemble 'code_6A00.asm'"
$ca65 $options -o build/code_6A00.o         src/code_6A00.asm
echo "- assemble 'table_bitmap.asm'"
$ca65 $options -o build/table_bitmap.o      src/gfx/table_bitmap.asm
echo "- assemble 'sound.asm'"
$ca65 $options -o build/sound.o             src/sound.asm
echo "- assemble 'gfx-font.asm'"
$ca65 $options -o build/gfx-font.o          src/gfx/font.asm
echo "- assemble 'gfx-sprites.asm'"
$ca65 $options -o build/gfx-sprites.o       src/gfx/sprites.asm
echo "- assemble 'math_data.asm'"
$ca65 $options -o build/math_data.o         src/math_data.asm
echo "- assemble 'gfx-hull_data.asm'"
$ca65 $options -o build/gfx-hull_data.o     src/gfx/hull_data.asm
echo "- assemble 'gfx-hud_data.asm'"
$ca65 $options -o build/gfx-hud_data.o      src/gfx/hud_data.asm
echo "- assemble 'vars_polyobj.asm'"
$ca65 $options -o build/vars_polyobj.o      src/vars_polyobj.asm
echo "- assemble 'elite_link.asm'"
$ca65 $options -o build/elite_link.o        src/elite_link.asm

echo "- linking..."
$ld65 \
       -C link/elite-harmless-d64.cfg \
       -S \$0400 \
       -m build/elite-harmless.map -vm \
       -o bin/harmless.prg \
    --obj build/code_init.o \
    --obj build/elite_link.o \
    --obj build/disk_boot_exo.o \
    --obj build/text_pairs.o \
    --obj build/text_flight.o \
    --obj build/text_docked.o \
    --obj build/vars_1D00.o \
    --obj build/code_1D81.o \
    --obj build/code_6A00.o \
    --obj build/table_bitmap.o \
    --obj build/sound.o \
    --obj build/gfx-font.o \
    --obj build/gfx-sprites.o \
    --obj build/math_data.o \
    --obj build/gfx-hull_data.o \
    --obj build/gfx-hud_data.o \
    --obj build/vars_polyobj.o 

#-------------------------------------------------------------------------------

# compress and fast-load the program
echo "- exomizing..."
echo

# NB: `lda #$00 sta $d011` turns the screen "off" so no background is
# displayed. it also speeds up the processor (no VIC wait-states).
# we don't need to turn the screen back on afterwards as Elite
# does this itself during initialisation

$exomizer \$0400 -B \
    -x3 -s "lda #\$00 sta \$d011" \
    -o "bin/harmless-exo.prg" \
    -- \
        "bin/init.prg" \
        "bin/prg1.prg" \
        "bin/prg2.prg" \
        "bin/prg3.prg"

echo
echo "* write floppy disk image"
$mkd64 \
    -o release/elite-harmless.d64 \
    -m cbmdos -d "ELITE:HARMLESS" -i "KROC " \
    -f bin/harmless-exo.prg -t 17 -s 0 -n "HARMLESS"    -P -w \
    1>/dev/null
echo "- OK"
echo

#-------------------------------------------------------------------------------

echo "* elite-harmless-fastlines.d64"
echo "  --------------------------------------"
clean

# enable undocumented opcodes and the replacement line-drawing routines
options="--cpu 6502X -DOPTION_DYME_FASTLINE"

echo
echo "- assemble 'disk_boot_exo.asm'"
$ca65 $options -o build/disk_boot_exo.o     src/boot/disk_boot_exo.asm
echo "- assemble 'code_init.asm'"
$ca65 $options -o build/code_init.o         src/code_init.asm
echo "- assemble 'text_pairs.asm'"
$ca65 $options -o build/text_pairs.o        src/text/text_pairs.asm
echo "- assemble 'text_flight.asm'"
$ca65 $options -o build/text_flight.o       src/text/text_flight.asm
echo "- assemble 'text_docked.asm'"
$ca65 $options -o build/text_docked.o       src/text/text_docked.asm
echo "- assemble 'vars_1D00.asm'"
$ca65 $options -o build/vars_1D00.o         src/vars_1D00.asm
echo "- assemble 'code_1D81.asm'"
$ca65 $options -o build/code_1D81.o         src/code_1D81.asm
echo "- assemble 'code_6A00.asm'"
$ca65 $options -o build/code_6A00.o         src/code_6A00.asm
echo "- assemble 'table_bitmap.asm'"
$ca65 $options -o build/table_bitmap.o      src/gfx/table_bitmap.asm
echo "- assemble 'sound.asm'"
$ca65 $options -o build/sound.o             src/sound.asm
echo "- assemble 'gfx-font.asm'"
$ca65 $options -o build/gfx-font.o          src/gfx/font.asm
echo "- assemble 'gfx-sprites.asm'"
$ca65 $options -o build/gfx-sprites.o       src/gfx/sprites.asm
echo "- assemble 'math_data.asm'"
$ca65 $options -o build/math_data.o         src/math_data.asm
echo "- assemble 'gfx-hull_data.asm'"
$ca65 $options -o build/gfx-hull_data.o     src/gfx/hull_data.asm
echo "- assemble 'gfx-hud_data.asm'"
$ca65 $options -o build/gfx-hud_data.o      src/gfx/hud_data.asm
echo "- assemble 'vars_polyobj.asm'"
$ca65 $options -o build/vars_polyobj.o      src/vars_polyobj.asm
echo "- assemble 'elite_link.asm'"
$ca65 $options -o build/elite_link.o        src/elite_link.asm

echo "- linking..."
$ld65 \
       -C link/elite-harmless-d64.cfg \
       -S \$0400 \
       -m build/elite-harmless-fastlines.map -vm \
       -o bin/harmless.prg \
    --obj build/code_init.o \
    --obj build/elite_link.o \
    --obj build/disk_boot_exo.o \
    --obj build/text_pairs.o \
    --obj build/text_flight.o \
    --obj build/text_docked.o \
    --obj build/vars_1D00.o \
    --obj build/code_1D81.o \
    --obj build/code_6A00.o \
    --obj build/table_bitmap.o \
    --obj build/sound.o \
    --obj build/gfx-font.o \
    --obj build/gfx-sprites.o \
    --obj build/math_data.o \
    --obj build/gfx-hull_data.o \
    --obj build/gfx-hud_data.o \
    --obj build/vars_polyobj.o 

#-------------------------------------------------------------------------------

# compress and fast-load the program
echo "- exomizing..."
echo

# NB: `lda #$00 sta $d011` turns the screen "off" so no background is
# displayed. it also speeds up the processor (no VIC wait-states).
# we don't need to turn the screen back on afterwards as Elite
# does this itself during initialisation

$exomizer \$0400 -B \
    -x3 -s "lda #\$00 sta \$d011" \
    -o "bin/harmless-exo.prg" \
    -- \
        "bin/init.prg" \
        "bin/prg1.prg" \
        "bin/prg2.prg" \
        "bin/prg3.prg"

echo
echo "* write floppy disk image"
$mkd64 \
    -o release/elite-harmless-fastlines.d64 \
    -m cbmdos -d "ELITE:HARMLESS" -i "KROC " \
    -f bin/harmless-exo.prg -t 17 -s 0 -n "HARMLESS"    -P -w \
    1>/dev/null
echo "- OK"
echo

#===============================================================================

##echo "* build Elite : Harmless (cartridges)"
##echo "  ======================================"
##echo "* cleaning up:"
##
##rm -rf build/*.o
##rm -rf build/*.s
##rm -rf build/*.bin
##rm -rf build/*.prg
##rm -rf build/*.d64
##
##rm -f bin/*.prg
##rm -f bin/*.d64
##
##echo "- OK"
##
##options="-DOPTION_MATHTABLES"
##
##echo
##echo "- assemble 'elite_link.asm'"
##$ca65 $options -o build/elite_link.o        src/elite_link.asm
##echo "- assemble 'code_init.asm'"
##$ca65 $options -o build/code_init.o         src/code_init.asm
##echo "- assemble 'text_pairs.asm'"
##$ca65 $options -o build/text_pairs.o        src/text/text_pairs.asm
##echo "- assemble 'text_flight.asm'"
##$ca65 $options -o build/text_flight.o       src/text/text_flight.asm
##echo "- assemble 'text_docked.asm'"
##$ca65 $options -o build/text_docked.o       src/text/text_docked.asm
##echo "- assemble 'vars_1D00.asm'"
##$ca65 $options -o build/vars_1D00.o         src/vars_1D00.asm
##echo "- assemble 'code_1D81.asm'"
##$ca65 $options -o build/code_1D81.o         src/code_1D81.asm
##echo "- assemble 'code_6A00.asm'"
##$ca65 $options -o build/code_6A00.o         src/code_6A00.asm
##echo "- assemble 'table_bitmap.asm'"
##$ca65 $options -o build/table_bitmap.o      src/gfx/table_bitmap.asm
##echo "- assemble 'sound.asm'"
##$ca65 $options -o build/sound.o             src/sound.asm
##echo "- assemble 'gfx-font.asm'"
##$ca65 $options -o build/gfx-font.o          src/gfx/font.asm
##echo "- assemble 'gfx-sprites.asm'"
##$ca65 $options -o build/gfx-sprites.o       src/gfx/sprites.asm
##echo "- assemble 'math_data.asm'"
##$ca65 $options -o build/math_data.o         src/math_data.o
##echo "- assemble 'gfx-hull_data.asm'"
##$ca65 $options -o build/gfx-hull_data.o     src/gfx/hull_data.asm
##echo "- assemble 'gfx-hud_data.asm'"
##$ca65 $options -o build/gfx-hud_data.o      src/gfx/hud_data.asm
##echo "- assemble 'vars_polyobj.asm'"
##$ca65 $options -o build/vars_polyobj.o      src/vars_polyobj.asm
##echo
##
##echo "* make 'elite-harmless-ocean.crt'"
##echo "  --------------------------------------"
##echo "- assemble 'boot/cart_boot.asm'"
##$ca65 $options -o build/cart_boot.o         src/boot/cart_boot.asm
##echo "- linking..."
##$ld65 \
##       -C link/elite-harmless-crt-ocean.cfg \
##       -S \$0400 \
##       -m build/elite-harmless-crt-ocean.map -vm \
##       -o release/elite-harmless-ocean.crt \
##    --obj build/cart_boot.o \
##    --obj build/elite_link.o

#-------------------------------------------------------------------------------

echo
echo "* complete."
exit 0
