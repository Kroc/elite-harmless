#!/usr/bin/sh

# Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018, see LICENSE.txt
# "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
# <github.com/Kroc/elite-harmless>
#===============================================================================

# if you've just installed Linux on Windows, you need to fetch up-to-date
# package information or install downloads will 404
sudo apt update
sudo apt-get install git gcc make python3

# todo: make this script `git pull` if code is already present?

cd bin
git clone https://github.com/cc65/cc65.git
cd cc65
make

cd ..
git clone https://github.com/Zirias/c64_tool_mkd64.git mkd64
cd mkd64
make