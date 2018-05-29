; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; mostly "graphics" data (includes the charset and HUD image),
; this data is encrypted before being included as part of GMA4.PRG

; as the disassembly improves, this 'opaque' data will be broken out
; to more useful files such as BMPs/PNGs that will get translated into
; the code the C64 needs during the build process

.include        "../elite_0700.asm"

.include        "../elite_font.asm"

.include        "../elite_0E00.asm"

