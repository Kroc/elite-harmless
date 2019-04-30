# Compiling _Elite_ & _Elite : Harmless_ #

Should it not be obvious, _Elite : Harmless_ is a game for the [Commodore 64][C64] microcomputer. Whilst the source code and build environment run on modern systems, the game itself can be run via a C64 emulator such as [VICE] or [CCS64].

[C64]:   https://en.wikipedia.org/wiki/Commodore_64
[VICE]:  http://vice-emu.sourceforge.net/
[CCS64]: http://www.ccs64.com/

Due to legal concerns, _Elite : Harmless_ binaries (i.e. disk images) are not made available, you will have to build the source code yourself using the following guide.

----

_Elite : Harmless_ can be built on Windows & Linux & Mac.

It's strongly recommended that you use Microsoft's [VSCode](https://code.visualstudio.com/). The repository contains a VSCode configuration to automatically set code formatting options and provides built-in shortcuts for building (`CTRL+SHIFT+B`)

Windows 10 users must install the [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/about), this allows you to run the Linux toolchain with the minimum of fuss, and is far less complicated than using other Windows-Linux toolchains such as MSYS / Cygwin. For other Windows versions, MSYS or Cygwin will have to be used, but no support is provided for this

The assembler used is [CC65](https://cc65.github.io/cc65/), this provides us cross-compatibility between Windows, Mac & Linux and an easy way to build from source on Windows 10

## Setting Up The Build Environment ##

1. Install [VSCode](https://code.visualstudio.com/)

2. Open the "elite-harmless" folder, via "File" > "Open Folder" menu

3. You may be prompted that the project contains recommended extensions and asked if you want to install them. This you should accept, or otherwise open the Extensions panel (`CTRL+SHIFT+X`), search for "CC65" and install the CC65 extension

4. From the VSCode menu, select "Tasks" > "Run Task..." and click on "Install build tools".
   The setup Bash script will download and compile CC65, mkd64 and other required tools. The script will ask for your Linux password so as to install the GCC compiler suite and required tools (`sudo apt-get install git gcc make python3`)

### Compiling the Source ###

Just press `CTRL+SHIFT+B` in VSCode to build the source code. Fresh disk images are spat out into the "release" directory.

----

## Legal ##

"Elite" is copyright David Braben & Ian Bell, Acornsoft (BBC / Electron versions), Firebird / British Telecom (C64 version), 1984-1985, all rights reserved. The name "Elite" is used in this project for historical, educational and archival purposes only.

To protect the legal interests involved, "Elite : Harmless" is made available under a [Creative Commons Attribution, Non-Commercial, Share-Alike Licence][cc-by-nc-sa].

[cc-by-nc-sa]:  https://creativecommons.org/licenses/by-nc-sa/4.0/