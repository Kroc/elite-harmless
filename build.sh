#!/usr/bin/sh

# Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2020,
# see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
# All Rights Reserved. <github.com/Kroc/elite-harmless>
#===============================================================================

# stop further processing on any error
set -e

#===============================================================================

cl65="./bin/cc65/bin/cl65 \
    --debug-info \
    --include-dir src \
    --include-dir build \
    --bin-include-dir build \
    --feature leading_dot_in_identifiers \
    --feature bracket_as_indirect \
    --asm-args --large-alignment"
ca65="./bin/cc65/bin/ca65 \
    --debug-info \
    --target c64 \
    --debug-info \
    --include-dir src \
    --include-dir build \
    --bin-include-dir build \
    --feature leading_dot_in_identifiers \
    --feature bracket_as_indirect \
    --large-alignment"
ld65="ld65"
mkd64="mkd64"
encrypt="python3 link/encrypt.py"
exomizer="./bin/exomizer/src/exomizer sfx \$0400 -q"


clear
echo "building Elite : Harmless"
echo

clean() {
    echo -n "- cleaning up:                      "

    rm -rf build/*.o
    rm -rf build/*.s
    rm -rf build/*.bin
    rm -rf build/*.prg
    rm -rf build/*.d64
    rm -rf build/*.crt

    rm -f bin/*.prg
    rm -f bin/*.d64
    rm -f bin/*.crt

    # annoyingly `cl65` will always place object files in the same directory
    # as the source file, so we need to clean these out of "src" ourselves
    rm -f src/*.o
    rm -f src/boot/*.o
    rm -f src/c64/*.o
    rm -f src/gfx/*.o
    rm -f src/orig/*.o
    rm -f src/text/*.o

    echo "[OK]"
}
clean

# build an original version of the game, including the original fast-loader

echo
echo "* build original Elite"
echo "  ======================================"

# assemble 'original' version of the code; the `OPTION_ORIGINAL` symbol
# is used within the files to exlcude changed code from the original

options="-DOPTION_ORIGINAL -DFEATURE_AUDIO"

# assemble the HUD bitmap into a Koala file we can pick bytes from.
# we won't use a linker script for this as we don't need to include
# any external symbols or definitions
echo -n "- assemble 'screen_main.koa'        "
$cl65 $options \
    --target none \
    --start-addr \$4000 \
     -o "build/screen_main.koa" \
        "src/orig/gfx_koala_main.asm"

echo "[OK]"
echo -n "- assemble 'screen_menu.koa'        "
$cl65 $options \
    --target none \
    --start-addr \$4000 \
     -o "build/screen_menu.koa" \
        "src/orig/gfx_koala_menu.asm"

echo "[OK]"

# assemble the super-object containing
# the majority of the original Elite code
echo -n "- assemble 'elite-original.asm'     "
$ca65 $options -o build/elite-original.o    src/elite-original.asm

# the text database has to be assembled separately from the main code
# due to the rather insane complexity which is best not leaked into 
# the global scope along with the main source code
echo "[OK]"; echo -n "- assemble 'text_pairs.asm'         "
$ca65 $options -o build/text_pairs.o        src/text/text_pairs.asm
echo "[OK]"; echo -n "- assemble 'text_flight.asm'        "
$ca65 $options -o build/text_flight.o       src/text/text_flight.asm
echo "[OK]"; echo -n "- assemble 'text_docked.asm'        "
$ca65 $options -o build/text_docked.o       src/text/text_docked.asm
echo "[OK]"

# let's build an original floppy disk to verify that we haven't broken
# the code or failed to preserve the original somewhere along the line

echo "  --------------------------------------"
echo "* assemble GMA86 loader"
echo "  --------------------------------------"
echo -n "- assemble 'boot/gma/stage0.asm'    "
$ca65 -o build/boot_gma_stage0.o        src/boot/gma/stage0.asm
echo "[OK]"; echo -n "- assemble 'boot/gma/stage1.asm'    "
$ca65 -o build/boot_gma_stage1.o        src/boot/gma/stage1.asm
echo "[OK]"; echo -n "- assemble 'boot/gma/stage2.asm'    "
$ca65 -o build/boot_gma_stage2.o        src/boot/gma/stage2.asm
echo "[OK]"; echo -n "- assemble 'boot/gma/stage3.asm'    "
$ca65 -o build/boot_gma_stage3.o        src/boot/gma/stage3.asm
echo "[OK]"; echo -n "- assemble 'boot/gma/stage4.asm'    "
$ca65 -o build/boot_gma_stage4.o        src/boot/gma/stage4.asm
echo "[OK]"; echo -n "- assemble 'boot/gma/gma4_7C3A.asm' "
$ca65 -o build/boot_gma_stage4_7C3A.o   src/boot/gma/stage4_7C3A.asm
echo "[OK]"; echo -n "- assemble 'boot/gma/stage5.asm'    "
$ca65 -o build/boot_gma_stage5.o        src/boot/gma/stage5.asm
echo "[OK]"; echo -n "- assemble 'boot/gma/stage6.asm'    "
$ca65 -o build/boot_gma_stage6.o        src/boot/gma/stage6.asm
echo "[OK]"

echo "  --------------------------------------"
echo "* link 'elite-original-gma86.cfg'"
echo "  --------------------------------------"
echo -n "-     link objects...               "
$ld65 \
       -C "link/elite-original-gma86.cfg" \
       -m "build/elite-original-gma86.map" -vm \
      -Ln "build/elite-original-gma86.ll" \
    --obj "build/elite-original.o" \
    --obj "build/boot_gma_stage0.o" \
    --obj "build/boot_gma_stage1.o" \
    --obj "build/boot_gma_stage2.o" \
    --obj "build/boot_gma_stage3.o" \
    --obj "build/boot_gma_stage4.o" \
    --obj "build/boot_gma_stage5.o" \
    --obj "build/boot_gma_stage6.o" \
    --obj "build/boot_gma_stage4_7C3A.o" \
    --obj "build/text_pairs.o" \
    --obj "build/text_flight.o" \
    --obj "build/text_docked.o"

echo "[OK]"

# encrypt GMA4.PRG:
#-------------------------------------------------------------------------------
# verify that the packed data is correct:
# (this will be harder to debug once encrypted)
echo -n "-   verify 'gma4_data1.bin'         "
if [[
    # note that this hash was produced by dumping $4000...$758F,
    # just after decryption (but before relocation)
    $(md5sum -b < build/gma4_data1.bin) \
 == "049a1004768ed1de4e220923ea865f78 *-"
]]; then
    echo "[OK]"
else
    echo "FAIL"
    exit 1
fi

# run the binary through the encrypt script, which will spit out an assembler
# file we can then re-link into the stage 4 loader ("GMA4.PRG")
echo -n "-  encrypt 'gma4_data1.bin'         "
$encrypt 6C \
    build/gma4_data1.bin \
    build/gma4_data1.bin

echo "[OK]"

# verify that the packed data is correct:
# (this will be harder to debug once encrypted)
echo -n "-   verify 'gma4_data2.bin'         "
if [[
    # note that this hash was produced by dumping $75E4...$865F,
    # just after decryption (but before relocation)
    $(md5sum -b < build/gma4_data2.bin) \
 == "32cba4aa5d3ee363c0bdfb77e95c1fc3 *-"
]]; then
    echo "[OK]"
else
    echo "FAIL"
    exit 1
fi

# encrypt the second block
echo -n "-  encrypt 'gma4_data2.bin'         "
$encrypt 8E \
    build/gma4_data2.bin \
    build/gma4_data2.bin

echo "[OK]"
echo -n "-   concat 'gma4.prg'               "
cat "build/gma4_prg.bin" \
    "build/gma4_data1.bin" \
    "build/gma4_junk1.bin" \
    "build/gma4_code.bin" \
    "build/gma4_data2.bin" \
    "build/gma4_junk2.bin" \
>   "bin/gma4.prg"
echo "[OK]"

# encrypt GMA5.PRG:
#-------------------------------------------------------------------------------
echo -n "-  encrypt 'gma5_data.bin'          "
$encrypt 36 \
    build/gma5_data.bin \
    build/gma5_data.bin

echo "[OK]"
echo -n "-   concat 'gma5.prg'               "
cat "build/gma5_code.prg" \
    "build/gma5_data.bin" \
    "build/gma5_junk.bin" \
>   "bin/gma5.prg"
echo "[OK]"

# encrypt GMA6.PRG:
#-------------------------------------------------------------------------------
echo -n "-  encrypt 'gma6_data.bin'          "
$encrypt 49 \
    build/gma6_data.bin \
    build/gma6_data.bin

echo "[OK]"
echo -n "-   concat 'gma6.prg'               "
cat "build/gma6_prg.bin" \
    "build/gma6_data.bin" \
    "build/gma6_junk.bin" \
>   "bin/gma6.prg"
echo "[OK]"

#-------------------------------------------------------------------------------

echo "  --------------------------------------"
echo -n "- write floppy disk image           "
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

echo "[OK]"

#-------------------------------------------------------------------------------

echo -n "- verifying checksums               "
cd bin
md5sum --ignore-missing --quiet --check checksums.md5
if [ $? -eq 0 ]; then echo "[OK]"; fi
cd ..

#===============================================================================

echo "  ======================================"
echo "* build Elite : Harmless (disk images)"
echo "  ======================================"

# copy the elite : harmless screen bitmap images into the build directory.
# note that elite-harmless does not assemble the screens from a source file
cp "src/gfx/screen_main.koa" \
   "build/screen_main.koa"

echo "* elite-harmless.d64"
echo "  --------------------------------------"
clean

options="--cpu 6502X -Wa -DFEATURE_AUDIO"

echo -n "- assembling                        "

# note that the text database has to be assembled separately from the main code
# due to the rather insane complexity which is best not leaked into the global
# scope along with the main source code

$cl65 $options \
    --config "link/elite-harmless-d64.cfg" \
    --start-addr \$0400 \
     -m "build/elite-harmless.map" -vm \
    -Ln "build/elite-harmless.ll" \
     -o "bin/harmless.prg" \
        "src/elite-harmless.asm" \
        "src/text/text_pairs.asm" \
        "src/text/text_flight.asm" \
        "src/text/text_docked.asm" \
        "src/c64/prgheader.asm"

echo "[OK]"

# compress and fast-load the program
echo -n "- exomizing...                      "

# NB: `lda #$00 sta $d011` turns the screen "off" so no background is
# displayed. it also speeds up the processor (no VIC wait-states).
# we don't need to turn the screen back on afterwards as Elite
# does this itself during initialisation

$exomizer \
    -s "lda #\$00 sta \$d011 sta \$d020" \
    -X "inc \$d020 dec \$d020" \
    -o "bin/harmless-exo.prg" \
    -- "bin/harmless.prg"

echo "[OK]"
echo -n "- write floppy disk image           "
$mkd64 \
    -o release/elite-harmless.d64 \
    -m cbmdos -d "ELITE:HARMLESS" -i "KROC " \
    -f bin/harmless-exo.prg -t 17 -s 0 -n "HARMLESS"    -P -w \
    1>/dev/null

echo "[OK]"

#-------------------------------------------------------------------------------

echo "  --------------------------------------"
echo "* elite-harmless-hiram.d64"
echo "  --------------------------------------"
clean

options="--cpu 6502X -DOPTION_MATHTABLES,-DFEATURE_AUDIO"

echo -n "- assembling                        "

# note that the text database has to be assembled separately from the main code
# due to the rather insane complexity which is best not leaked into  the global
# scope along with the main source code

$cl65 $options \
    --config "link/elite-harmless-hiram.cfg" \
    --start-addr \$0400 \
     -m "build/elite-harmless-hiram.map" -vm \
    -Ln "build/elite-harmless-hiram.ll" \
     -o "bin/harmless.prg" \
        "src/elite-harmless.asm" \
        "src/text/text_pairs.asm" \
        "src/text/text_flight.asm" \
        "src/text/text_docked.asm" \
        "src/c64/prgheader.asm"
    
echo "[OK]"

# compress and fast-load the program
echo -n "- exomizing...                      "

$exomizer \
    -s "lda #\$00 sta \$d011 sta \$d020" \
    -X "inc \$d020 dec \$d020" \
    -o "bin/harmless-exo.prg" \
    -- "bin/harmless.prg"

echo "[OK]"
echo -n "- write floppy disk image           "
$mkd64 \
    -o release/elite-harmless-hiram.d64 \
    -m cbmdos -d "ELITE:HARMLESS" -i "KROC " \
    -f bin/harmless-exo.prg -t 17 -s 0 -n "HARMLESS"    -P -w \
    1>/dev/null

echo "[OK]"

#-------------------------------------------------------------------------------

echo "  --------------------------------------"
echo "* elite-harmless-hiram-fastlines.d64"
echo "  --------------------------------------"
clean

# enable undocumented opcodes and the replacement line-drawing routines
options="--cpu 6502X -Wa -DOPTION_MATHTABLES,-DOPTION_DYME_FASTLINE,-DFEATURE_AUDIO"

echo -n "- assembling                        "

# note that the text database has to be assembled separately from the main code
# due to the rather insane complexity which is best not leaked into the global
# scope along with the main source code

$cl65 $options \
    --config "link/elite-harmless-hiram.cfg" \
    --start-addr \$0400 \
     -m "build/elite-harmless-hiram-fastlines.map" -vm \
    -Ln "build/elite-harmless-hiram-fastlines.ll" \
     -o "bin/harmless.prg" \
        "src/elite-harmless.asm" \
        "src/text/text_pairs.asm" \
        "src/text/text_flight.asm" \
        "src/text/text_docked.asm" \
        "src/c64/prgheader.asm"

echo "[OK]"

# compress and fast-load the program
echo -n "- exomizing...                      "

# NB: `lda #$00 sta $d011` turns the screen "off" so no background is
# displayed. it also speeds up the processor (no VIC wait-states).
# we don't need to turn the screen back on afterwards as Elite
# does this itself during initialisation

$exomizer \
    -s "lda #\$00 sta \$d011 sta \$d020" \
    -X "inc \$d020 dec \$d020" \
    -o "bin/harmless-exo.prg" \
    -- "bin/harmless.prg"

echo "[OK]"
echo -n "- write floppy disk image           "
$mkd64 \
    -o release/elite-harmless-hiram-fastlines.d64 \
    -m cbmdos -d "ELITE:HARMLESS" -i "KROC " \
    -f bin/harmless-exo.prg -t 17 -s 0 -n "HARMLESS"    -P -w \
    1>/dev/null

echo "[OK]"

#===============================================================================

# annoyingly `cl65` will always place object files in the same directory
# as the source file, so we need to clean these out of "src" ourselves
echo -n "- cleaning up:                      "

rm -f src/*.o
rm -f src/boot/*.o
rm -f src/c64/*.o
rm -f src/gfx/*.o
rm -f src/text/*.o

echo "[OK]"

echo "  ======================================"
echo "* complete."
echo 
exit 0
