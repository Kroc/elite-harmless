#!/usr/bin/sh

# Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
# see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
# All Rights Reserved. <github.com/Kroc/elite-harmless>
#===============================================================================

# if you've just installed Linux on Windows, you need to fetch up-to-date
# package information or install downloads will 404
sudo apt update
sudo apt-get install git gcc make python3

# todo: make this script `git pull` if code is already present?

cd bin

if [ ! -d "cc65" ]; then
    git clone --recurse-submodules https://github.com/cc65/cc65.git cc65
    
    cd cc65
    make
    sudo PREFIX=/usr/local make install
    cd ..
fi

if [ ! -d "mkd64" ]; then
    git clone --recurse-submodules https://github.com/Zirias/c64_tool_mkd64.git mkd64
    cd mkd64
    make
    sudo make install
    cd ..
fi

# compile exomizer (requires CC65 to be on the path)
cd exomizer/src

make

cd ../..

echo
echo "Build complete."