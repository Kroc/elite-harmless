#!/usr/bin/sh

# Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2023,
# see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
# All Rights Reserved. <github.com/Kroc/elite-harmless>
#===============================================================================

# if you've just installed Linux on Windows, you need to fetch
# up-to-date package information or install downloads will 404
# TODO: test if packages already exist?
# TODO: mac support via Brew?

echo
echo "Enter your Linux root password"
echo "to install required tools:"
echo "(git, gcc, make, python3, bison, cc65)"
echo
sudo apt update
sudo apt-get install git gcc make python3 bison cc65

# todo: make this script `git pull` if code is already present?

cd bin

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
echo "Setup complete."