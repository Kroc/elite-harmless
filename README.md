# Elite : Harmless #

Elite : Harmless is a greatly enhanced version of the [Commodore 64][c64] port of the seminal space-trading-combat sim [Elite][elite], made possible by a full disassembly.

[c64]:      https://en.wikipedia.org/wiki/Commodore_64
[elite]:    https://en.wikipedia.org/wiki/Elite_(video_game)

## State Of The Project ##

The game is disassembled but documentation is on-going.  
Some improvements have been implemented, see below.
Help is needed in these areas:

* Understanding / commenting the 3D math code;  
  working out how to rebuild the math tables from macros
* Commenting SID code (I know literally nothing of audio theory)
* See also the [list of "Help Wanted" issues][helpw]

[helpw]:    https://github.com/Kroc/elite-harmless/labels/help%20wanted

## Improvements Implemented ##

### Speed ###

* _Multiplication routine upgraded to a faster version:_ I was able to free up 2 KB and insert some multiplication look-up tables which gives a general speed-up for 3D math

* _The code was unnecessarily storing and copying the blank space either side of the HUD_, where the C64's screen is 320px wide rather than 256px on the BBC, on *every frame*; and with an inefficient copy routine. Needless to say, in Elite : Harmless the blank space is neither stored nor copied and the copy method is much faster

## Planned Improvements ##

* [Speed improvements][speed]
* "Quality of Life" improvements, making the game [more accessible][ease] to new players and players who may never have played an 8-bit or C64 game before
* [Feature enhancements][feat]
* See the complete [list of issues][issues]

[speed]:    https://github.com/Kroc/elite-harmless/labels/speed
[ease]:     https://github.com/Kroc/elite-harmless/labels/ease-of-use
[feat]:     https://github.com/Kroc/elite-harmless/labels/enhancement
[issues]:   https://github.com/kroc/elite-harmless/issues

## Building Elite : Harmless ##

Elite : Harmless can be built on Windows, Linux & Mac.

### Prerequisites ###

* It's strongly recommended that you use Microsoft's [VSCode](https://code.visualstudio.com/). The repository contains a VSCode configuration to automatically set code formatting options and provides built-in shortcuts for building (`CTRL+SHIFT+B`)

* Windows 10 users must install the [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/about), this allows you to run the Linux toolchain with the minimum of fuss, and is far less complicated than using other Windows-Linux toolchains such as MSYS / Cygwin. For other Windows versions, MSYS or Cygwin will have to be used, but no support is provided for this

* The assembler used is [CC65](https://cc65.github.io/cc65/), this provides us cross-compatibility between Windows, Mac & Linux and an easy way to build from source on Windows 10

### Setting Up The Build Tools ###

1. Install [VSCode](https://code.visualstudio.com/)

2. Open VSCode, open the Extensions panel (`CTRL+SHIFT+X`), search for "CC65" and install the CC65 extension

3. From the VSCode menu, select "Tasks" > "Run Task..." and click on "Install build tools".
   The setup Bash script will download and compile CC65. The script will ask for your Linux password so as to install the GCC compiler suite and required tools (`sudo apt-get install git gcc make python3`).

### Building the Elite : Harmless Source ###

Just press `CTRL+SHIFT+B` in VSCode to build the source code. Fresh disk images are spat out into the "release" directory.

## Acknowledgements ##

This work was made possible by various resources available on the web, for which I would like to give thanks to the people involved and for the love and effort they've poured into their work.

* [Classic BBC Elite Disk flight code][bbc-flight] and [Classic BBC Elite Disk docked code][bbc-docked] by Paul Brink, 2014

[bbc-flight]: http://www.elitehomepage.org/archive/a/d4090012.txt
[bbc-docked]: http://www.elitehomepage.org/archive/a/d4090010.txt

* [Elite's crazy tokenised string routine][crazy] by Matt Godbolt

[crazy]:  https://xania.org/201406/elites-crazy-string-format

## Legal ##

"Elite" is copyright David Braben & Ian Bell, Acornsoft (BBC / Electron versions), Firebird / British Telecom (C64 version), 1984-1985, all rights reserved. The name "Elite" is used in this project for historical, educational and archival purposes only.

To protect the legal interests involved, "Elite : Harmless" is made available under a [Creative Commons Attribution, Non-Commercial, Share-Alike Licence][cc-by-nc-sa].

[cc-by-nc-sa]:  https://creativecommons.org/licenses/by-nc-sa/4.0/
