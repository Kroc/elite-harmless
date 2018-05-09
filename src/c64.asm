; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================
.linecont+

.define BLACK   $00
.define WHITE   $01
.define RED     $02
.define CYAN    $03
.define PURPLE  $04
.define GREEN   $05
.define BLUE    $06
.define YELLOW  $07
.define ORANGE  $08
.define BROWN   $09
.define LTRED   $0a
.define DKGREY  $0b
.define GREY    $0c
.define LTGREEN $0d
.define LTBLUE  $0e
.define LTGREY  $0f

.define .color_nybbles(fore, back) \
        (fore & 15) << 4 | (back & 15)
