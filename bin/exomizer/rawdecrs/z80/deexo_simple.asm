;Exomizer 2 Z80 decoder
;Copyright (C) 2008-2016 by Jaime Tejedor Gomez (Metalbrain)
;
;Optimized by Antonio Villena and Urusergi (154 bytes)
;
;Compression algorithm by Magnus Lind
;
;   This depacker is free software; you can redistribute it and/or
;   modify it under the terms of the GNU Lesser General Public
;   License as published by the Free Software Foundation; either
;   version 2.1 of the License, or (at your option) any later version.
;
;   This library is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;   Lesser General Public License for more details.
;
;   You should have received a copy of the GNU Lesser General Public
;   License along with this library; if not, write to the Free Software
;   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
;
;input:         hl=compressed data start
;               de=uncompressed destination start
;
;simple version:
;               no literal sequences (compress with -c option)
;               you MUST define exo_mapbasebits aligned to a 256 boundary
;
;ATTENTION!
;A huge speed boost (around 14%) can be gained at the cost of only 5 bytes.
;If you want this, replace all instances of "call exo_getbit" with "srl a" followed by
;"call z,exo_getbit", and remove the first two instructions in exo_getbit routine.

deexo:          ld      iy, exo_mapbasebits+112
                ld      a, (hl)
                inc     hl
                ld      b, 52
                push    de
                cp      a
exo_initbits:   ld      c, 16
                jr      nz, exo_get4bits
                ld      ixl, c
                ld      de, 1           ;DE=b2
exo_get4bits:   call    exo_getbit      ;get one bit
                rl      c
                jr      nc, exo_get4bits
                ld      (iy-112), c     ;bits[i]=b1
                push    hl
                ld      hl, 1
                defb    210             ;3 bytes nop (JP NC)
exo_setbit:     add     hl, hl
                dec     c
                jr      nz, exo_setbit
                ld      (iy-60), e
                ld      (iy-8), d       ;base[i]=b2
                add     hl, de
                ex      de, hl
                inc     iyl
                pop     hl
                dec     ixl
                djnz    exo_initbits
                pop     de
                defb    218             ;3 bytes nop (JP C) --> jr exo_mainloop
exo_literal:    ldi
exo_mainloop:   call    exo_getbit      ;get one bit
                jr      c, exo_literal  ;literal?
                ld      c, 111
exo_getindex:   call    exo_getbit      ;get one bit
                inc     c
                jr      nc,exo_getindex
                ret     m
                push    de
                ld      iyl, c
                call    exo_getpair
                push    de
                rlc     d
                jr      nz, exo_dontgo
                dec     e
                ld      bc, 512+160     ;2 bits, 48 offset
                jr      z, exo_goforit
                dec     e               ;2?
exo_dontgo:     ld      bc, 1024+144    ;4 bits, 32 offset
                jr      z, exo_goforit
                ld      c, 128          ;16 offset
exo_goforit:    call    exo_getbits     ;get B bits in DE
                ld      iyl, c
                add     iy, de
                call    exo_getpair
                pop     bc
                ex      (sp), hl
                push    hl
                sbc     hl, de
                pop     de
                ldir
                pop     hl
                jr      exo_mainloop    ;Next!

exo_getpair:    ld      b, (iy-112)
                call    exo_getbits
                ex      de, hl
                ld      c, (iy-60)
                ld      b, (iy-8)
                add     hl, bc          ;Always clear C flag
                ex      de, hl
                ret

exo_getbits:    ld      de, 0
exo_gbcont:     dec     b
                ret     m
                call    exo_getbit
                rl      e
                rl      d
                jr      exo_gbcont

exo_getbit:     srl     a
                ret     nz
                ld      a, (hl)
                inc     hl
                rra
                ret

exo_mapbasebits:defs    156             ;tables for bits, baseL, baseH