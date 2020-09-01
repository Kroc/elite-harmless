# Elite : Harmless #

_Elite : Harmless_ is a greatly enhanced version of the [Commodore 64][c64] port of the seminal space-trading-combat sim [_Elite_][elite], made possible by a full disassembly.

[c64]:      https://en.wikipedia.org/wiki/Commodore_64
[elite]:    https://en.wikipedia.org/wiki/Elite_(video_game)

## State Of The Project ##

The game is disassembled but documentation is on-going.  
Some improvements have been implemented, see below.
Help is needed in these areas:

* Understanding / commenting the 3D math code
* Commenting SID code (I know literally nothing of audio theory)
* See also the [list of "Help Wanted" issues][helpw]

[helpw]:    https://github.com/Kroc/elite-harmless/labels/help%20wanted

## Improvements Implemented ##

* _Multiplication routine upgraded to a faster version:_ I was able to free up 2 KB and insert some multiplication look-up tables which gives a general speed-up for 3D math

* Faster line-drawing code, provided by [dyme](https://github.com/dyme6510)

* _The code was unnecessarily storing and copying the blank space either side of the HUD_, where the C64's screen is 320px wide rather than 256px on the BBC, on *every frame*; and with an inefficient copy routine. Needless to say, in _Elite : Harmless_ the blank space is neither stored nor copied and the copy method is much faster

## Planned Improvements ##

* [Speed improvements][speed]
* "Quality of Life" improvements, making the game [more accessible][ease] to new players and players who may never have played an 8-bit or C64 game before
* [Feature enhancements][feat]
* See the complete [list of issues][issues]

[speed]:    https://github.com/Kroc/elite-harmless/labels/speed
[ease]:     https://github.com/Kroc/elite-harmless/labels/ease-of-use
[feat]:     https://github.com/Kroc/elite-harmless/labels/enhancement
[issues]:   https://github.com/kroc/elite-harmless/issues

## Getting _Elite : Harmless_ ##

Due to legal concerns, _Elite : Harmless_ binaries (i.e. disk images) are not made available, you will have to build the source code yourself using the instructions provided in [INSTALL.md](INSTALL.md).

## Acknowledgements ##

This work was made possible by various resources available on the web, for which I would like to give thanks to the people involved and for the love and effort they've poured into their work:

* Both [Dyme](https://github.com/dyme6510) and nc513 ([Lemon64 forums](https://www.lemon64.com/forum/)) have contributed solid technical understanding and code to the project

* [Ian Bell's Elite Archives][ian] for providing the original BBC Tape source code, as well as numerous resources for all classic _Elite_ fans

[ian]: http://www.iancgbell.clara.net/elite/index.htm

* [Classic BBC Elite Disk flight code][bbc-flight] and [Classic BBC Elite Disk docked code][bbc-docked] by Paul Brink, 2014

[bbc-flight]: http://www.elitehomepage.org/archive/a/d4090012.txt
[bbc-docked]: http://www.elitehomepage.org/archive/a/d4090010.txt

* Andy McFadden's [Apple \]\[ Elite disassembly](https://6502disassembly.com/a2-elite)

* [Mark Moxon's][markmoxon] _heavily_ documented [BBC disassembly][bbc-moxon], based off of [Kieran Connell's conversion][kieranasm] of the original source to BeebASM

[markmoxon]: https://www.markmoxon.com/
[bbc-moxon]: https://github.com/markmoxon/elite-beebasm
[kieranasm]: https://github.com/kieranhj/elite-beebasm

* [Elite's crazy tokenised string routine][crazy] by Matt Godbolt

[crazy]:  https://xania.org/201406/elites-crazy-string-format

* Gregory Naçu's blog post [The 6510 Processor Port][6510] for the neat memory map optimisation and general C64 internals knowledge

[6510]: http://www.c64os.com/post?p=83

* [Pixcen], a C64 image editor by Hammarberg/CensorDesign(?)

[Pixcen]: https://github.com/Hammarberg/pixcen

## Legal ##

"Elite" is copyright David Braben & Ian Bell, Acornsoft (BBC / Electron versions), Firebird / British Telecom (C64 version), 1984-1985, all rights reserved. The name "Elite" is used in this project for historical, educational and archival purposes only.

To protect the legal interests involved, "Elite : Harmless" is made available under a [Creative Commons Attribution, Non-Commercial, Share-Alike Licence][cc-by-nc-sa].

[cc-by-nc-sa]:  https://creativecommons.org/licenses/by-nc-sa/4.0/
