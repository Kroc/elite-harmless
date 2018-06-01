; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; this data is part of the GMA4 2nd payload, but appears unreferenced.
; it gets overwritten by the game's code at $6A00..

.segment        "DATA_7C7A"

        .byte   $33, $8d, $49, $ea, $53, $29, $2c, $2f                  ;$7C7A
        .byte   $87, $c4, $a0, $70, $96, $90, $b3, $38
        .byte   $b9, $53, $9a, $91, $ae, $2e, $70, $f8                  ;$7C8A
        .byte   $c8, $1b, $7c, $a1, $d1, $37, $2b, $4c
        .byte   $97, $f3, $4f, $73, $ad, $d2, $39, $71                  ;$7C9A
        .byte   $4d, $ee, $f5, $d3, $4f, $e7, $c7, $f5
        .byte   $fe, $05, $d3, $4f, $68, $88, $35, $f9                  ;$7CAA
        .byte   $00, $d3, $4f, $27, $4a, $38, $f6, $fd
        .byte   $d6, $26, $cb, $1b, $bc, $ed, $0b, $33                  ;$7CBA
        .byte   $e9, $f0, $d3, $4f, $62, $85, $38, $f1
        .byte   $f8, $d3, $4f, $30, $56, $3b, $05, $0c                  ;$7CCA
        .byte   $d3, $4f, $68, $90, $98, $cb, $b7, $34
        .byte   $ed, $01, $08, $d3, $4f, $07, $2f, $3d                  ;$7CDA
        .byte   $d1, $d8, $d3, $4f, $62, $83, $36, $db
        .byte   $e2, $db, $2b, $07, $71, $1a, $93, $4f                  ;$7CEA
        .byte   $f8, $34, $d4, $33, $6f, $51, $ce, $d5
        .byte   $ea, $66, $8d, $af, $37, $04, $2b, $fe                  ;$7CFA
        .byte   $d7, $03, $2a, $f7, $d0, $06, $0d, $db
        .byte   $ad, $a5, $2f, $ce, $a4, $2e, $ce, $a3                  ;$7D0A
        .byte   $4d, $06, $60, $d2, $5b, $bc, $9d, $13
        .byte   $4f, $a8, $cd, $3a, $f7, $1e, $3e, $17                  ;$7D1A
        .byte   $f4, $fb, $dd, $b2, $4c, $97, $35, $ea
        .byte   $45, $c9, $e9, $b0, $2f, $8b, $12, $f7                  ;$7D2A
        .byte   $b6, $8b, $ab, $45, $c9, $e9, $b0, $06
        .byte   $bb, $0b, $36, $e2, $b7, $ab, $cf, $e3                  ;$7D3A
        .byte   $ea, $d9, $29, $a2, $f1, $8f, $b5, $d3
        .byte   $8a, $ce, $f1, $8f, $75, $c4, $14, $0b                  ;$7D4A
        .byte   $56, $0a, $e0, $2b, $35, $e6, $bc, $0c
        .byte   $30, $ea, $44, $96, $1b, $ae, $8a, $ea                  ;$7D5A
        .byte   $0b, $0c, $86, $44, $96, $38, $2c, $36
        .byte   $d3, $4f, $29, $50, $d3, $05, $45, $c9                  ;$7D6A
        .byte   $e9, $b0, $e9, $19, $b5, $0b, $fb, $b9
