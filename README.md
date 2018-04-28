# Elite DX #

Elite DX is a disassembly of the Commodore 64 port of the seminal space-trading-combat sim Elite.

## Building Elite DX ##

Elite DX can be built on Windows, Linux & Mac.

### Prerequisites ###

* It's strongly recommended that you use Microsoft's [VSCode](https://code.visualstudio.com/). The repository contains a VSCode configuration to automatically set code formatting options and provides built-in shortcuts for building (`CTRL+SHIFT+B`)

* Windows 10 users must install the [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/about), this allows you to run the Linux toolchain with the minimum of fuss, and is far less complicated than using other Windows-Linux toolchains such as MSYS / Cygwin. For other Windows versions, MSYS or Cygwin will have to be used, but no support is provided for this

* The assembler used is [CC65](https://cc65.github.io/cc65/), this provides us cross-compatibility between Windows, Mac & Linux and an easy way to build from source on Windows 10

### Setting Up The Build Tools ###

1. Install [VSCode](https://code.visualstudio.com/)

2. Open VSCode, open the Extensions panel (`CTRL+SHIFT+X`), search for "CC65" and install the CC65 extnesion

3. From the VSCode menu, select "Tasks" > "Run Task..." and click on "Install build tools".
   The setup Bash script will download and compile CC65. The script will ask for your Linux password so as to install the GCC compiler suite and required tools (`sudo apt-get install git gcc make`).

### Building the Elite DX Source ###

Just press `CTRL+SHIFT+B` in VSCode to build the source code.

## Legal ##

"Elite" is copyright David Braben & Ian Bell, Firebird / British Telecom, 1984-1985, all rights reserved. The name "Elite" is used in this project for historical, educational and archival purposes only.

To that end, no copyright claim is made on "Elite DX", it is published under a 'Public Domain'-like [Creative Commons CC0 licence](https://creativecommons.org/publicdomain/zero/1.0/). Any contributions are also licenced as such and authors agree to the licence terms upon contributing.