#!/usr/bin/sh

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