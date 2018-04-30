; "Elite" C64 disassembly / "Elite DX", cc0 2018, see LICENSE.txt
; "Elite" is copyright / trademark David Braben & Ian Bell, All Rights Reserved
; <github.com/Kroc/EliteDX>
;===============================================================================

; the stage 1 loader ("gma3.prg") jumps into here 
.export _7596

; 4000 7e 56 24 ror $2456,x
; 4003 03       ???
; 4004 63       ???
; 4005 cb       ???
; 4006 14       ???
; 4007 20 77 64 jsr $6477
; 400a d0 21    bne $402d
; 400c 26 de    rol $de
; 400e db       ???
; 400f 1f       ???
; 4010 28       plp 
; 4011 77       ???
; 4012 67       ???
; 4013 19 14 94 ora $9414,y
; 4016 52       ???
; 4017 20 af 64 jsr $64af
; 401a 22       ???
; 401b e4 31    cpx $31
; 401d 34       ???
; 401e a9 2f    lda #$2f
; 4020 70 ea    bvs $400c
; 4022 ea       nop 
; 4023 2f       ???
; 4024 2d 6e 73 and $736e
; 4027 30 63    bmi $408c
; 4029 a6 21    ldx $21
; 402b 24 ab    bit $ab
; 402d 19 d9 ce ora $ced9,y
; 4030 dd 7a 88 cmp $887a,x
; 4033 f5 70    sbc $70,x
; 4035 af       ???
; 4036 16 12    asl $12,x
; 4038 22       ???
; 4039 34       ???
; 403a 60       rts 
; 403b a3       ???
; 403c 62       ???
; 403d c6 21    dec $21
; 403f 1d d6 e5 ora $e5d6,x
; 4042 e6 ed    inc $ed
; 4044 2d 26 6f and $6f26
; 4047 bd 1d cb lda $cb1d,x
; 404a 6e 03 62 ror $6203
; 404d 17       ???
; 404e 6c 57 a3 jmp ($a357)
; 4051 03       ???
; 4052 73       ???
; 4053 df       ???
; 4054 26 bd    rol $bd
; 4056 03       ???
; 4057 a8       tay 
; 4058 57       ???
; 4059 1e e9 7d asl $7de9,x
; 405c 03       ???
; 405d 76 e3    ror $e3,x
; 405f d7       ???
; 4060 e1 77    sbc ($77,x)
; 4062 75 df    adc $df,x
; 4064 d0 da    bne $4040
; 4066 77       ???
; 4067 03       ???
; 4068 b9 71 6c lda $6c71,y
; 406b 2b       ???
; 406c f1 7a    sbc ($7a),y
; 406e b8       clv 
; 406f 61 09    adc ($09,x)
; 4071 cb       ???
; 4072 e5 7a    sbc $7a
; 4074 65 cb    adc $cb
; 4076 dc       ???
; 4077 dd 0a a3 cmp $a30a,x
; 407a 6e e4 e5 ror $e5e4
; 407d 23       ???
; 407e c2       ???
; 407f 8f       ???
; 4080 81 ae    sta ($ae,x)
; 4082 0e d7 29 asl $29d7
; 4085 6c 54 9a jmp ($9a54)
; 4088 d8       cld 
; 4089 46 e4    lsr $e4
; 408b e3       ???
; 408c 2b       ???
; 408d 35 77    and $77,x
; 408f 60       rts 
; 4090 1c       ???
; 4091 21 20    and ($20,x)
; 4093 6e 15 c2 ror $c215
; 4096 da       ???
; 4097 7a       ???
; 4098 67       ???
; 4099 cd d4 da cmp $dad4
; 409c cc 17 17 cpy $1717
; 409f da       ???
; 40a0 7a       ???
; 40a1 60       rts 
; 40a2 1a       ???
; 40a3 2d 2d 6c and $6c2d
; 40a6 18       clc 
; 40a7 69 eb    adc #$eb
; 40a9 9a       txs 
; 40aa 18       clc 
; 40ab 66 70    ror $70
; 40ad db       ???
; 40ae d5 dd    cmp $dd,x
; 40b0 73       ???
; 40b1 73       ???
; 40b2 50 44    bvc $40f8
; 40b4 dd d6 d7 cmp $d7d6,x
; 40b7 77       ???
; 40b8 03       ???
; 40b9 b9 26 23 lda $2326,y
; 40bc b3       ???
; 40bd 6b       ???
; 40be e1 e4    sbc ($e4,x)
; 40c0 26 bb    rol $bb
; 40c2 63       ???
; 40c3 cc db 2b cpy $2bdb
; 40c6 26 0d    rol $0d
; 40c8 a3       ???
; 40c9 6b       ???
; 40ca e5 ed    sbc $ed
; 40cc 26 23    rol $23
; 40ce e3       ???
; 40cf d5 08    cmp $08,x
; 40d1 a9 03    lda #$03
; 40d3 70 db    bvs $40b0
; 40d5 25 31    and $31
; 40d7 7a       ???
; 40d8 ec 6b 82 cpx $826b
; 40db ae 96 a0 ldx $a096
; 40de 5e a6 73 lsr $73a6,x
; 40e1 df       ???
; 40e2 df       ???
; 40e3 e9 e5    sbc #$e5
; 40e5 21 1c    and ($1c,x)
; 40e7 26 bc    rol $bc
; 40e9 64       ???
; 40ea 41 4d    eor ($4d,x)
; 40ec e0 73    cpx #$73
; 40ee 9c       ???
; 40ef 03       ???
; 40f0 df       ???
; 40f1 df       ???
; 40f2 e1 f1    sbc ($f1,x)
; 40f4 7a       ???
; 40f5 66 c6    ror $c6
; 40f7 1c       ???
; 40f8 28       plp 
; 40f9 da       ???
; 40fa e8       inx 
; 40fb 7a       ???
; 40fc 03       ???
; 40fd 72       ???
; 40fe d9 ce cf cmp $cfce,y
; 4101 e2       ???
; 4102 7a       ???
; 4103 7d e0 0f adc $0fe0,x
; 4106 19 70 bf ora $bf70,y
; 4109 1f       ???
; 410a cb       ???
; 410b 78       sei 
; 410c af       ???
; 410d 57       ???
; 410e 24 6f    bit $6f
; 4110 60       rts 
; 4111 c2       ???
; 4112 d2       ???
; 4113 db       ???
; 4114 6b       ???
; 4115 03       ???
; 4116 a8       tay 
; 4117 d1 96    cmp ($96),y
; 4119 26 bc    rol $bc
; 411b 59 db a4 eor $a4db,y
; 411e 22       ???
; 411f 77       ???
; 4120 20 49 17 jsr $1749
; 4123 7a       ???
; 4124 72       ???
; 4125 db       ???
; 4126 54       ???
; 4127 e8       inx 
; 4128 49 4c    eor #$4c
; 412a 6c cb d0 jmp ($d0cb)
; 412d dc       ???
; 412e 29 bb    and #$bb
; 4130 71 29    adc ($29),y
; 4132 58       cli 
; 4133 a0 70    ldy #$70
; 4135 e7       ???
; 4136 77       ???
; 4137 93       ???
; 4138 96 6f    stx $6f,y
; 413a d1 68    cmp ($68),y
; 413c 03       ???
; 413d 70 d6    bvs $4115
; 413f 92       ???
; 4140 2c 03 63 bit $6303
; 4143 09 0d    ora #$0d
; 4145 d0 91    bne $40d8
; 4147 25 66    and $66
; 4149 1f       ???
; 414a 23       ???
; 414b dd 73 65 cmp $6573,x
; 414e d1 d8    cmp ($d8),y
; 4150 d3       ???
; 4151 67       ???
; 4152 bf       ???
; 4153 3a       ???
; 4154 2f       ???
; 4155 23       ???
; 4156 19 aa b7 ora $b7aa,y
; 4159 65 1a    adc $1a
; 415b ce c2 14 dec $14c2
; 415e 69 25    adc #$25
; 4160 70 70    bvs $41d2
; 4162 26 6b    rol $6b
; 4164 25 70    and $70
; 4166 6f       ???
; 4167 d9 23 73 cmp $7323,y
; 416a c6 80    dec $80
; 416c 23       ???
; 416d 59 aa 6f eor $6faa,y
; 4170 e5 f1    sbc $f1
; 4172 f1 33    sbc ($33),y
; 4174 67       ???
; 4175 aa       tax 
; 4176 6d 16 09 adc $0916
; 4179 cc 20 14 cpy $1420
; 417c d0 70    bne $41ee
; 417e d8       cld 
; 417f 4b       ???
; 4180 e9 ed    sbc #$ed
; 4182 2a       rol a
; 4183 23       ???
; 4184 70 a8    bvs $412e
; 4186 08       php 
; 4187 cb       ???
; 4188 1a       ???
; 4189 62       ???
; 418a 2d 7a 62 and $627a
; 418d d1 de    cmp ($de),y
; 418f db       ???
; 4190 e6 ea    inc $ea
; 4192 70 65    bvs $41f9
; 4194 cf       ???
; 4195 17       ???
; 4196 56 17    lsr $17,x
; 4198 de 70 65 dec $6570,x
; 419b db       ???
; 419c e7       ???
; 419d e1 70    sbc ($70,x)
; 419f 6e 1d 62 ror $621d
; 41a2 56 13    lsr $13,x
; 41a4 70 64    bvs $420a
; 41a6 d0 db    bne $4183
; 41a8 d6 67    dec $67,x
; 41aa 73       ???
; 41ab e2       ???
; 41ac 21 61    and ($61,x)
; 41ae 25 e4    and $e4
; 41b0 6e a0 0e ror $0ea0
; 41b3 7c       ???
; 41b4 f6 a4    inc $a4,x
; 41b6 66 aa    ror $aa
; 41b8 a3       ???
; 41b9 0d 1b b4 ora $b41b
; 41bc 5f       ???
; 41bd cc 70 2f cpy $2f70
; 41c0 41 25    eor ($25,x)
; 41c2 36 39    rol $39,x
; 41c4 39 23 03 and $0323,y
; 41c7 63       ???
; 41c8 d1 71    cmp ($71),y
; 41ca 6f       ???
; 41cb 18       clc 
; 41cc 49 a0    eor #$a0
; 41ce 65 cf    adc $cf
; 41d0 1d 59 a6 ora $a659,x
; 41d3 70 18    bvs $41ed
; 41d5 d4       ???
; 41d6 2c 64 11 bit $1164
; 41d9 5e b1 71 lsr $71b1,x
; 41dc 2c bb 7a bit $7abb
; 41df e0 92    cpx #$92
; 41e1 98       tya 
; 41e2 e0 74    cpx #$74
; 41e4 61 d0    adc ($d0,x)
; 41e6 e5 dc    sbc $dc
; 41e8 66 61    ror $61
; 41ea 17       ???
; 41eb 16 c8    asl $c8,x
; 41ed 68       pla 
; 41ee 35 35    and $35,x
; 41f0 70 df    bvs $41d1
; 41f2 d9 d8 e8 cmp $e8d8,y
; 41f5 7a       ???
; 41f6 61 d7    adc ($d7,x)
; 41f8 da       ???
; 41f9 72       ???
; 41fa 74       ???
; 41fb e0 35    cpx #$35
; 41fd bb       ???
; 41fe 6b       ???
; 41ff 25 27    and $27
; 4201 28       plp 
; 4202 bb       ???
; 4203 61 1d    adc ($1d,x)
; 4205 36 7a    rol $7a,x
; 4207 65 17    adc $17
; 4209 b2       ???
; 420a 65 db    adc $db
; 420c e7       ???
; 420d e2       ???
; 420e eb       ???
; 420f 7a       ???
; 4210 dd 44 18 cmp $1844,x
; 4213 28       plp 
; 4214 77       ???
; 4215 65 42    adc $42
; 4217 41 64    eor ($64,x)
; 4219 6f       ???
; 421a d9 11 18 cmp $1811,y
; 421d d8       cld 
; 421e 67       ???
; 421f 6f       ???
; 4220 db       ???
; 4221 cd 49 9b cmp $9b49
; 4224 b3       ???
; 4225 a5 16    lda $16
; 4227 d8       cld 
; 4228 67       ???
; 4229 6b       ???
; 422a e1 e4    sbc ($e4,x)
; 422c 26 24    rol $24
; 422e d6 d1    dec $d1,x
; 4230 67       ???
; 4231 65 cb    adc $cb
; 4233 d5 1e    cmp $1e,x
; 4235 15 66    ora $66,x
; 4237 af       ???
; 4238 1f       ???
; 4239 d6 c6    dec $c6,x
; 423b d7       ???
; 423c 77       ???
; 423d 88       dey 
; 423e 3f       ???
; 423f 65 59    adc $59
; 4241 ab       ???
; 4242 60       rts 
; 4243 cc da 6e cpy $6eda
; 4246 d8       cld 
; 4247 46 26    lsr $26
; 4249 1f       ???
; 424a 1a       ???
; 424b b3       ???
; 424c 03       ???
; 424d 6a       ror a
; 424e 11 21    ora ($21),y
; 4250 54       ???
; 4251 57       ???
; 4252 35 bb    and $bb,x
; 4254 71 dd    adc ($dd),y
; 4256 6c 8d 90 jmp ($908d)
; 4259 06 96    asl $96
; 425b c2       ???
; 425c 32       ???
; 425d 9c       ???
; 425e 9c       ???
; 425f 06 06    asl $06
; 4261 90 90    bcc $41f3
; 4263 88       dey 
; 4264 88       dey 
; 4265 68       pla 
; 4266 1f       ???
; 4267 bd 73 d2 lda $d273,x
; 426a 04       ???
; 426b d1 58    cmp ($58),y
; 426d 29 65    and #$65
; 426f d6 2d    dec $2d,x
; 4271 33       ???
; 4272 77       ???
; 4273 ad 56 a9 lda $a956
; 4276 a2 07    ldx #$07
; 4278 dc       ???
; 4279 77       ???
; 427a bd 21 cf lda $cf21,x
; 427d e2       ???
; 427e 77       ???
; 427f 5a       ???
; 4280 c9 db    cmp #$db
; 4282 e0 98    cpx #$98
; 4284 24 40    bit $40
; 4286 72       ???
; 4287 11 e1    ora ($e1),y
; 4289 02       ???
; 428a 66 e1    ror $e1
; 428c f2       ???
; 428d 2e ba 03 rol $03ba
; 4290 73       ???
; 4291 e9 e5    sbc #$e5
; 4293 df       ???
; 4294 d6 fe    dec $fe,x
; 4296 98       tya 
; 4297 b0 12    bcs $42ab
; 4299 d0 06    bne $42a1
; 429b 98       tya 
; 429c 65 db    adc $db
; 429e dc       ???
; 429f d5 6f    cmp $6f,x
; 42a1 6e 2c 2e ror $2e2c
; 42a4 da       ???
; 42a5 0c       ???
; 42a6 a2 c0    ldx #$c0
; 42a8 ad f0 64 lda $64f0
; 42ab c3       ???
; 42ac dc       ???
; 42ad 7a       ???
; 42ae 66 73    ror $73
; 42b0 6d 6d 7b adc $7b6d
; 42b3 7b       ???
; 42b4 93       ???
; 42b5 86 45    stx $45
; 42b7 89       ???
; 42b8 b4 70    ldy $70,x
; 42ba 45 90    eor $90
; 42bc bb       ???
; 42bd 70 4a    bvs $4309
; 42bf 4d 73 d0 eor $d073
; 42c2 cc d8 df cpy $dfd8
; 42c5 e3       ???
; 42c6 70 aa    bvs $4272
; 42c8 0a       asl a
; 42c9 c2       ???
; 42ca d5 d9    cmp $d9,x
; 42cc 69 76    adc #$76
; 42ce df       ???
; 42cf d3       ???
; 42d0 67       ???
; 42d1 5a       ???
; 42d2 bb       ???
; 42d3 cd da cf cmp $cfda
; 42d6 61 45    adc ($45,x)
; 42d8 9f       ???
; 42d9 e7       ???
; 42da 8d 67 d3 sta $d367
; 42dd cc c8 17 cpy $17c8
; 42e0 13       ???
; 42e1 67       ???
; 42e2 f7       ???
; 42e3 f4       ???
; 42e4 59 5c a1 eor $a15c,y
; 42e7 9e       ???
; 42e8 6e d8 d9 ror $d9d8
; 42eb d9 e1 20 cmp $20e1,y
; 42ee 23       ???
; 42ef 7d 9b 98 adc $989b,x
; 42f2 6e 1d 5e ror $5e1d
; 42f5 13       ???
; 42f6 67       ???
; 42f7 9b       ???
; 42f8 98       tya 
; 42f9 e6 ff    inc $ff
; 42fb 3c       ???
; 42fc 23       ???
; 42fd af       ???
; 42fe 87       ???
; 42ff 87       ???
; 4300 13       ???
; 4301 67       ???
; 4302 4c 49 b1 jmp $b149
; 4305 64       ???
; 4306 17       ???
; 4307 de 7d 03 dec $037d,x
; 430a 64       ???
; 430b c6 18    dec $18
; 430d 16 14    asl $14,x
; 430f 14       ???
; 4310 60       rts 
; 4311 50 53    bvc $4366
; 4313 6f       ???
; 4314 d9 6d 62 cmp $626d,y
; 4317 8e 2c 26 stx $262c
; 431a c8       iny 
; 431b 06 07    asl $07
; 431d a6 eb    ldx $eb
; 431f 9a       txs 
; 4320 5d c4 19 eor $19c4,x
; 4323 df       ???
; 4324 e2       ???
; 4325 2a       rol a
; 4326 56 5e    lsr $5e,x
; 4328 5e 54 61 lsr $6154,x
; 432b 3f       ???
; 432c 89       ???
; 432d b0 4b    bcs $437a
; 432f 50 cd    bvc $42fe
; 4331 24 b0    bit $b0
; 4333 4a       lsr a
; 4334 4f       ???
; 4335 8f       ???
; 4336 1c       ???
; 4337 6a       ror a
; 4338 62       ???
; 4339 70 e6    bvs $4321
; 433b 2a       rol a
; 433c 6a       ror a
; 433d 29 2d    and #$2d
; 433f 6e 00 6f ror $6f00
; 4342 de 6f b7 dec $b76f,x
; 4345 6b       ???
; 4346 21 d1    and ($d1,x)
; 4348 7d 19 03 adc $0319,x
; 434b bf       ???
; 434c bf       ???
; 434d 03       ???
; 434e 2f       ???
; 434f 5a       ???
; 4350 17       ???
; 4351 5a       ???
; 4352 1f       ???
; 4353 28       plp 
; 4354 90 3e    bcc $4394
; 4356 25 60    and $60
; 4358 02       ???
; 4359 5a       ???
; 435a b8       clv 
; 435b 6c d1 ca jmp ($cad1)
; 435e 16 18    asl $18,x
; 4360 1a       ???
; 4361 b3       ???
; 4362 65 db    adc $db
; 4364 da       ???
; 4365 ce 1e 69 dec $691e
; 4368 b5 6b    lda $6b,x
; 436a 14       ???
; 436b 17       ???
; 436c 10 12    bpl $4380
; 436e e0 70    cpx #$70
; 4370 6e da 54 ror $54da
; 4373 57       ???
; 4374 e9 7d    sbc #$7d
; 4376 38       sec 
; 4377 35 8f    and $8f,x
; 4379 8f       ???
; 437a 88       dey 
; 437b 88       dey 
; 437c 62       ???
; 437d c3       ???
; 437e cd 21 b8 cmp $b821
; 4381 8b       ???
; 4382 88       dey 
; 4383 d8       cld 
; 4384 4b       ???
; 4385 d9 dd 28 cmp $28dd,y
; 4388 28       plp 
; 4389 77       ???
; 438a 67       ???
; 438b 1f       ???
; 438c 58       cli 
; 438d 7d 88 ab adc $ab88,x
; 4390 67       ???
; 4391 cd c8 c9 cmp $c9c8
; 4394 d6 e9    dec $e9,x
; 4396 7a       ???
; 4397 0e 1c 1c asl $1c1c
; 439a 1c       ???
; 439b 11 69    ora ($69),y
; 439d 69 72    adc #$72
; 439f 72       ???
; 43a0 6d 6d 7a adc $7a6d
; 43a3 7a       ???
; 43a4 69 69    adc #$69
; 43a6 11 1c    ora ($1c),y
; 43a8 1c       ???
; 43a9 1c       ???
; 43aa 0e 73 20 asl $2073
; 43ad 1d 21 28 ora $2821,x
; 43b0 77       ???
; 43b1 2b       ???
; 43b2 8f       ???
; 43b3 c6 d0    dec $d0
; 43b5 d4       ???
; 43b6 69 6f    adc #$6f
; 43b8 21 26    and ($26,x)
; 43ba 71 00    adc ($00),y
; 43bc 00       brk 
; 43bd 00       brk 
; 43be 00       brk 
; 43bf 00       brk 
; 43c0 19 4b 7c ora $7c4b,y
; 43c3 ac db 07 ldy $07db
; 43c6 30 57    bmi $441f
; 43c8 7b       ???
; 43c9 9b       ???
; 43ca b7       ???
; 43cb cf       ???
; 43cc e2       ???
; 43cd f0 fa    beq $43c9
; 43cf fe fe fa inc $fafe,x
; 43d2 f0 e2    beq $43b6
; 43d4 cf       ???
; 43d5 b7       ???
; 43d6 9b       ???
; 43d7 7b       ???
; 43d8 57       ???
; 43d9 30 07    bmi $43e2
; 43db db       ???
; 43dc ac 7c 4b ldy $4b7c
; 43df 19 01 04 ora $0401,y
; 43e2 07       ???
; 43e3 09 0b    ora #$0b
; 43e5 0e 11 13 asl $1311
; 43e8 15 17    ora $17,x
; 43ea 19 1c 1f ora $1f1c,y
; 43ed 21 23    and ($23,x)
; 43ef 25 27    and $27
; 43f1 29 2b    and #$2b
; 43f3 2d 2f 31 and $312f
; 43f6 32       ???
; 43f7 33       ???
; 43f8 35 37    and $37,x
; 43fa 39 3a 3b and $3b3a,y
; 43fd 3d 3e 1f and $1f3e,x
; 4400 00       brk 
; 4401 00       brk 
; 4402 00       brk 
; 4403 00       brk 
; 4404 00       brk 
; 4405 00       brk 
; 4406 00       brk 
; 4407 18       clc 
; 4408 30 30    bmi $443a
; 440a 30 30    bmi $443c
; 440c 18       clc 
; 440d 18       clc 
; 440e 18       clc 
; 440f 6c d8 d8 jmp ($d8d8)
; 4412 6c 00 00 jmp ($0000)
; 4415 00       brk 
; 4416 00       brk 
; 4417 36 6c    rol $6c,x
; 4419 b5 b5    lda $b5,x
; 441b b5 b5    lda $b5,x
; 441d 6c 36 0c jmp ($0c36)
; 4420 4b       ???
; 4421 a7       ???
; 4422 a6 49    ldx $49
; 4424 89       ???
; 4425 96 18    stx $18,y
; 4427 60       rts 
; 4428 c6 72    dec $72
; 442a 24 48    bit $48
; 442c 96 6c    stx $6c,y
; 442e 06 38    asl $38
; 4430 a4 d8    ldy $d8
; 4432 a4 a5    ldy $a5
; 4434 d3       ???
; 4435 a1 3b    lda ($3b,x)
; 4437 0c       ???
; 4438 24 48    bit $48
; 443a 30 00    bmi $443c
; 443c 00       brk 
; 443d 00       brk 
; 443e 00       brk 
; 443f 0c       ???
; 4440 24 48    bit $48
; 4442 60       rts 
; 4443 60       rts 
; 4444 48       pha 
; 4445 24 0c    bit $0c
; 4447 30 48    bmi $4491
; 4449 24 18    bit $18
; 444b 18       clc 
; 444c 24 48    bit $48
; 444e 30 00    bmi $4450
; 4450 18       clc 
; 4451 96 ba    stx $ba,y
; 4453 ba       tsx 
; 4454 96 18    stx $18,y
; 4456 00       brk 
; 4457 00       brk 
; 4458 18       clc 
; 4459 30 96    bmi $43f1
; 445b 96 30    stx $30,y
; 445d 18       clc 
; 445e 00       brk 
; 445f 00       brk 
; 4460 00       brk 
; 4461 00       brk 
; 4462 00       brk 
; 4463 00       brk 
; 4464 18       clc 
; 4465 30 48    bmi $44af
; 4467 30 00    bmi $4469
; 4469 00       brk 
; 446a 7e 7e 00 ror $007e,x
; 446d 00       brk 
; 446e 00       brk 
; 446f 00       brk 
; 4470 00       brk 
; 4471 00       brk 
; 4472 00       brk 
; 4473 00       brk 
; 4474 18       clc 
; 4475 30 18    bmi $448f
; 4477 00       brk 
; 4478 06 12    asl $12
; 447a 24 48    bit $48
; 447c 90 60    bcc $44de
; 447e 00       brk 
; 447f 3c       ???
; 4480 a2 d4    ldx #$d4
; 4482 ec f4 dc cpx $dcf4
; 4485 a2 3c    ldx #$3c
; 4487 18       clc 
; 4488 50 50    bvc $44da
; 448a 30 30    bmi $44bc
; 448c 30 96    bmi $4424
; 448e 7e 3c a2 ror $a23c,x
; 4491 6c 12 24 jmp ($2412)
; 4494 48       pha 
; 4495 ae 7e 3c ldx $3c7e
; 4498 a2 6c    ldx #$6c
; 449a 22       ???
; 449b 22       ???
; 449c 6c a2 3c jmp ($3ca2)
; 449f 0c       ???
; 44a0 28       plp 
; 44a1 58       cli 
; 44a2 a8       tay 
; 44a3 ea       nop 
; 44a4 8a       txa 
; 44a5 18       clc 
; 44a6 0c       ???
; 44a7 7e de dc ror $dcde,x
; 44aa 82       ???
; 44ab 0c       ???
; 44ac 6c a2 3c jmp ($3ca2)
; 44af 1c       ???
; 44b0 4c 90 dc jmp $dc90
; 44b3 e2       ???
; 44b4 cc a2 3c cpy $3ca2
; 44b7 7e 84 12 ror $1284,x
; 44ba 24 48    bit $48
; 44bc 60       rts 
; 44bd 60       rts 
; 44be 30 3c    bmi $44fc
; 44c0 a2 cc    ldx #$cc
; 44c2 a2 a2    ldx #$a2
; 44c4 cc a2 3c cpy $3ca2
; 44c7 3c       ???
; 44c8 a2 cc    ldx #$cc
; 44ca a4 44    ldy $44
; 44cc 12       ???
; 44cd 44       ???
; 44ce 38       sec 
; 44cf 00       brk 
; 44d0 00       brk 
; 44d1 18       clc 
; 44d2 30 18    bmi $44ec
; 44d4 18       clc 
; 44d5 30 18    bmi $44ef
; 44d7 00       brk 
; 44d8 00       brk 
; 44d9 18       clc 
; 44da 30 18    bmi $44f4
; 44dc 18       clc 
; 44dd 30 48    bmi $4527
; 44df 3c       ???
; 44e0 24 48    bit $48
; 44e2 90 90    bcc $4474
; 44e4 48       pha 
; 44e5 24 0c    bit $0c
; 44e7 00       brk 
; 44e8 00       brk 
; 44e9 7e 7e 7e ror $7e7e,x
; 44ec 7e 00 00 ror $0000,x
; 44ef 30 48    bmi $4539
; 44f1 24 12    bit $12
; 44f3 12       ???
; 44f4 24 48    bit $48
; 44f6 30 3c    bmi $4534
; 44f8 a2 72    ldx #$72
; 44fa 24 30    bit $30
; 44fc 18       clc 
; 44fd 18       clc 
; 44fe 18       clc 
; 44ff 3c       ???
; 4500 a2 d4    ldx #$d4
; 4502 d8       cld 
; 4503 d8       cld 
; 4504 ce 9c 3c dec $3c9c
; 4507 3c       ???
; 4508 a2 cc    ldx #$cc
; 450a e4 e4    cpx $e4
; 450c cc cc 66 cpy $66cc
; 450f 7c       ???
; 4510 e2       ???
; 4511 cc e2 e2 cpy $e2e2
; 4514 cc e2 7c cpy $7ce2
; 4517 3c       ???
; 4518 a2 c6    ldx #$c6
; 451a c0 c0    cpy #$c0
; 451c c6 a2    dec $a2
; 451e 3c       ???
; 451f 78       sei 
; 4520 e4 d2    cpx $d2
; 4522 cc cc d2 cpy $d2cc
; 4525 e4 78    cpx $78
; 4527 7e de c0 ror $c0de,x
; 452a dc       ???
; 452b dc       ???
; 452c c0 de    cpy #$de
; 452e 7e 7e de ror $de7e,x
; 4531 c0 dc    cpy #$dc
; 4533 dc       ???
; 4534 c0 c0    cpy #$c0
; 4536 60       rts 
; 4537 3c       ???
; 4538 a2 c6    ldx #$c6
; 453a ce d4 cc dec $ccd4
; 453d a2 3c    ldx #$3c
; 453f 66 cc    ror $cc
; 4541 cc e4 e4 cpy $e4e4
; 4544 cc cc 66 cpy $66cc
; 4547 7e 96 30 ror $3096,x
; 454a 30 30    bmi $457c
; 454c 30 96    bmi $44e4
; 454e 7e 3e 4a ror $4a3e,x
; 4551 18       clc 
; 4552 18       clc 
; 4553 18       clc 
; 4554 78       sei 
; 4555 a4 38    ldy $38
; 4557 66 d2    ror $d2
; 4559 e4 e8    cpx $e8
; 455b e8       inx 
; 455c e4 d2    cpx $d2
; 455e 66 60    ror $60
; 4560 c0 c0    cpy #$c0
; 4562 c0 c0    cpy #$c0
; 4564 c0 de    cpy #$de
; 4566 7e 63 da ror $da63,x
; 4569 f6 ea    inc $ea,x
; 456b d6 ce    dec $ce,x
; 456d c6 63    dec $63
; 456f 66 cc    ror $cc
; 4571 dc       ???
; 4572 f4       ???
; 4573 ec d4 cc cpx $ccd4
; 4576 66 3c    ror $3c
; 4578 a2 cc    ldx #$cc
; 457a cc cc cc cpy $cccc
; 457d a2 3c    ldx #$3c
; 457f 7c       ???
; 4580 e2       ???
; 4581 cc e2 dc cpy $dce2
; 4584 c0 c0    cpy #$c0
; 4586 60       rts 
; 4587 3c       ???
; 4588 a2 cc    ldx #$cc
; 458a cc d0 d6 cpy $d6d0
; 458d a2 36    ldx #$36
; 458f 7c       ???
; 4590 e2       ???
; 4591 cc e2 e8 cpy $e8e2
; 4594 d2       ???
; 4595 cc 66 3c cpy $3c66
; 4598 a2 c6    ldx #$c6
; 459a 9c       ???
; 459b 42       ???
; 459c 6c a2 3c jmp ($3ca2)
; 459f 7e 96 30 ror $3096,x
; 45a2 30 30    bmi $45d4
; 45a4 30 30    bmi $45d6
; 45a6 18       clc 
; 45a7 66 cc    ror $cc
; 45a9 cc cc cc cpy $cccc
; 45ac cc a2 3c cpy $3ca2
; 45af 66 cc    ror $cc
; 45b1 cc cc cc cpy $cccc
; 45b4 a2 54    ldx #$54
; 45b6 18       clc 
; 45b7 63       ???
; 45b8 c6 ce    dec $ce
; 45ba d6 ea    dec $ea,x
; 45bc f6 da    inc $da,x
; 45be 63       ???
; 45bf 66 cc    ror $cc
; 45c1 a2 54    ldx #$54
; 45c3 54       ???
; 45c4 a2 cc    ldx #$cc
; 45c6 66 66    ror $66
; 45c8 cc cc a2 cpy $a2cc
; 45cb 54       ???
; 45cc 30 30    bmi $45fe
; 45ce 18       clc 
; 45cf 7e 84 12 ror $1284,x
; 45d2 24 48    bit $48
; 45d4 90 de    bcc $45b4
; 45d6 7e 7c dc ror $dc7c,x
; 45d9 c0 c0    cpy #$c0
; 45db c0 c0    cpy #$c0
; 45dd dc       ???
; 45de 7c       ???
; 45df 00       brk 
; 45e0 60       rts 
; 45e1 90 48    bcc $462b
; 45e3 24 12    bit $12
; 45e5 06 00    asl $00
; 45e7 3e 44 0c rol $0c44,x
; 45ea 0c       ???
; 45eb 0c       ???
; 45ec 0c       ???
; 45ed 44       ???
; 45ee 3e 18 54 rol $5418,x
; 45f1 a2 a8    ldx #$a8
; 45f3 42       ???
; 45f4 00       brk 
; 45f5 00       brk 
; 45f6 00       brk 
; 45f7 00       brk 
; 45f8 00       brk 
; 45f9 00       brk 
; 45fa 00       brk 
; 45fb 00       brk 
; 45fc 00       brk 
; 45fd 00       brk 
; 45fe ff       ???
; 45ff 1b       ???
; 4600 52       ???
; 4601 66 ac    ror $ac
; 4603 ac 60 ae ldy $ae60
; 4606 7e 00 00 ror $0000,x
; 4609 3c       ???
; 460a 42       ???
; 460b 44       ???
; 460c a4 a4    ldy $a4
; 460e 3e 60 c0 rol $c060,x
; 4611 dc       ???
; 4612 e2       ???
; 4613 cc cc e2 cpy $e2cc
; 4616 7c       ???
; 4617 00       brk 
; 4618 00       brk 
; 4619 3c       ???
; 461a a2 c6    ldx #$c6
; 461c c6 a2    dec $a2
; 461e 3c       ???
; 461f 06 0c    asl $0c
; 4621 44       ???
; 4622 a4 cc    ldy $cc
; 4624 cc a4 3e cpy $3ea4
; 4627 00       brk 
; 4628 00       brk 
; 4629 3c       ???
; 462a a2 e4    ldx #$e4
; 462c de 9c 3c dec $3c9c,x
; 462f 1c       ???
; 4630 4c 60 ac jmp $ac60
; 4633 ac 60 60 ldy $6060
; 4636 30 00    bmi $4638
; 4638 00       brk 
; 4639 3e a4 cc rol $cca4,x
; 463c a4 44    ldy $44
; 463e 42       ???
; 463f 9c       ???
; 4640 c0 dc    cpy #$dc
; 4642 e2       ???
; 4643 cc cc cc cpy $cccc
; 4646 66 18    ror $18
; 4648 18       clc 
; 4649 38       sec 
; 464a 50 30    bvc $467c
; 464c 30 54    bmi $46a2
; 464e 3c       ???
; 464f 18       clc 
; 4650 18       clc 
; 4651 38       sec 
; 4652 50 30    bvc $4684
; 4654 30 30    bmi $4686
; 4656 88       dey 
; 4657 d0 c0    bne $4619
; 4659 c6 d2    dec $d2
; 465b e4 e4    cpx $e4
; 465d d2       ???
; 465e 66 38    ror $38
; 4660 50 30    bvc $4692
; 4662 30 30    bmi $4694
; 4664 30 54    bmi $46ba
; 4666 3c       ???
; 4667 00       brk 
; 4668 00       brk 
; 4669 36 b5    rol $b5,x
; 466b ea       nop 
; 466c d6 ce    dec $ce,x
; 466e 63       ???
; 466f 00       brk 
; 4670 00       brk 
; 4671 7c       ???
; 4672 e2       ???
; 4673 cc cc cc cpy $cccc
; 4676 66 00    ror $00
; 4678 00       brk 
; 4679 3c       ???
; 467a a2 cc    ldx #$cc
; 467c cc a2 3c cpy $3ca2
; 467f 00       brk 
; 4680 00       brk 
; 4681 7c       ???
; 4682 e2       ???
; 4683 cc e2 dc cpy $dce2
; 4686 c0 60    cpy #$60
; 4688 00       brk 
; 4689 3e a4 cc rol $cca4,x
; 468c a4 44    ldy $44
; 468e 0d 07 00 ora $0007
; 4691 6c e2 d6 jmp ($d6e2)
; 4694 c0 c0    cpy #$c0
; 4696 60       rts 
; 4697 00       brk 
; 4698 00       brk 
; 4699 3e 9e 9c rol $9c9e,x
; 469c 42       ???
; 469d 82       ???
; 469e 7c       ???
; 469f 30 60    bmi $4701
; 46a1 ac ac 60 ldy $60ac
; 46a4 60       rts 
; 46a5 4c 1c 00 jmp $001c
; 46a8 00       brk 
; 46a9 66 cc    ror $cc
; 46ab cc cc a4 cpy $a4cc
; 46ae 3e 00 00 rol $0000,x
; 46b1 66 cc    ror $cc
; 46b3 cc a2 54 cpy $54a2
; 46b6 18       clc 
; 46b7 00       brk 
; 46b8 00       brk 
; 46b9 63       ???
; 46ba ce d6 ea dec $ead6
; 46bd b5 36    lda $36,x
; 46bf 00       brk 
; 46c0 00       brk 
; 46c1 66 a2    ror $a2
; 46c3 54       ???
; 46c4 54       ???
; 46c5 a2 66    ldx #$66
; 46c7 00       brk 
; 46c8 00       brk 
; 46c9 66 cc    ror $cc
; 46cb cc a4 44 cpy $44a4
; 46ce 42       ???
; 46cf 3c       ???
; 46d0 00       brk 
; 46d1 7e 8a 24 ror $248a,x
; 46d4 48       pha 
; 46d5 ae 7e 0c ldx $0c7e
; 46d8 24 30    bit $30
; 46da 88       dey 
; 46db 88       dey 
; 46dc 30 24    bmi $4702
; 46de 0c       ???
; 46df 18       clc 
; 46e0 30 30    bmi $4712
; 46e2 18       clc 
; 46e3 18       clc 
; 46e4 30 30    bmi $4716
; 46e6 18       clc 
; 46e7 30 48    bmi $4731
; 46e9 30 26    bmi $4711
; 46eb 26 30    rol $30
; 46ed 48       pha 
; 46ee 30 31    bmi $4721
; 46f0 9c       ???
; 46f1 b1 46    lda ($46),y
; 46f3 00       brk 
; 46f4 00       brk 
; 46f5 00       brk 
; 46f6 00       brk 
; 46f7 ff       ???
; 46f8 fe fe fe inc $fefe,x
; 46fb fe fe fe inc $fefe,x
; 46fe fe 56 b5 inc $b556,x
; 4701 ba       tsx 
; 4702 b2       ???
; 4703 b5 d6    lda $d6,x
; 4705 c0 c0    cpy #$c0
; 4707 8d 2a d2 sta $d22a
; 470a c2       ???
; 470b 08       php 
; 470c 7b       ???
; 470d 91 2c    sta ($2c),y
; 470f c8       iny 
; 4710 36 dd    rol $dd,x
; 4712 b2       ???
; 4713 bb       ???
; 4714 df       ???
; 4715 f0 39    beq $4750
; 4717 42       ???
; 4718 e5 de    sbc $de
; 471a f0 7b    beq $4797
; 471c 1a       ???
; 471d c3       ???
; 471e 24 44    bit $44
; 4720 44       ???
; 4721 ca       dex 
; 4722 d3       ???
; 4723 e4 dd    cpx $dd
; 4725 f0 8b    beq $46b2
; 4727 33       ???
; 4728 c7       ???
; 4729 58       cli 
; 472a 4e e6 c8 lsr $c8e6
; 472d e3       ???
; 472e dc       ???
; 472f f0 8a    beq $46bb
; 4731 25 23    and $23
; 4733 27       ???
; 4734 18       clc 
; 4735 1d 1e 7a ora $7a1e,x
; 4738 cd 73 33 cmp $3373
; 473b 30 2c    bmi $4769
; 473d 16 1c    asl $1c,x
; 473f 31 6e    and ($6e),y
; 4741 d5 e2    cmp $e2,x
; 4743 db       ???
; 4744 f0 89    beq $46cf
; 4746 21 9b    and ($9b,x)
; 4748 0c       ???
; 4749 d7       ???
; 474a fd aa 20 sbc $20aa,x
; 474d 73       ???
; 474e 5a       ???
; 474f 19 1d 19 ora $191d,y
; 4752 69 6b    adc #$6b
; 4754 2c 32 21 bit $2132
; 4757 19 be 58 ora $58be,y
; 475a 34       ???
; 475b ff       ???
; 475c 2d d0 2f and $2fd0
; 475f b8       clv 
; 4760 10 c4    bpl $4726
; 4762 3e 21 d7 rol $d721,x
; 4765 d6 1f    dec $1f,x
; 4767 3d ce ee and $eece,x
; 476a 39 39 cd and $cd39,y
; 476d d5 8d    cmp $8d,x
; 476f 86 91    stx $91
; 4771 97       ???
; 4772 e6 bd    inc $bd
; 4774 b0 b6    bcs $472c
; 4776 b2       ???
; 4777 5e ac a9 lsr $a9ac,x
; 477a 08       php 
; 477b 7b       ???
; 477c 7b       ???
; 477d 0b       ???
; 477e 1d d4 35 ora $35d4,x
; 4781 21 21    and ($21,x)
; 4783 88       dey 
; 4784 2f       ???
; 4785 c3       ???
; 4786 20 48 46 jsr $4648
; 4789 d4       ???
; 478a b6 b2    ldx $b2,y
; 478c 24 3d    bit $3d
; 478e 74       ???
; 478f a3       ???
; 4790 f6 b2    inc $b2,x
; 4792 b1 e1    lda ($e1),y
; 4794 3d c2 c3 and $c3c2,x
; 4797 2a       rol a
; 4798 89       ???
; 4799 2d 39 21 and $2139
; 479c 15 89    ora $89,x
; 479e 95 3c    sta $3c,x
; 47a0 95 88    sta $88,x
; 47a2 2f       ???
; 47a3 d0 09    bne $47ae
; 47a5 97       ???
; 47a6 99 ae 65 sta $65ae,y
; 47a9 b5 2f    lda $2f,x
; 47ab 31 b7    and ($b7),y
; 47ad 14       ???
; 47ae 86 67    stx $67
; 47b0 29 62    and #$62
; 47b2 95 17    sta $17,x
; 47b4 b0 97    bcs $474d
; 47b6 a1 32    lda ($32,x)
; 47b8 32       ???
; 47b9 bb       ???
; 47ba a4 7a    ldy $7a
; 47bc 8f       ???
; 47bd 29 88    and #$88
; 47bf 5b       ???
; 47c0 e9 7c    sbc #$7c
; 47c2 78       sei 
; 47c3 b4 b5    ldy $b5,x
; 47c5 91 41    sta ($41),y
; 47c7 29 23    and #$23
; 47c9 c6 2c    dec $2c
; 47cb ad 9b 12 lda $129b
; 47ce 89       ???
; 47cf 77       ???
; 47d0 8e a9 2e stx $2ea9
; 47d3 8a       txa 
; 47d4 92       ???
; 47d5 39 3a 2e and $2e3a,y
; 47d8 89       ???
; 47d9 5b       ???
; 47da 82       ???
; 47db b1 2b    lda ($2b),y
; 47dd 9f       ???
; 47de a2 a7    ldx #$a7
; 47e0 8f       ???
; 47e1 b5 29    lda $29,x
; 47e3 94 35    sty $35,x
; 47e5 2d 8c 88 and $888c
; 47e8 bb       ???
; 47e9 21 32    and ($32,x)
; 47eb 56 5f    lsr $5f,x
; 47ed 5c       ???
; 47ee 0f       ???
; 47ef 5b       ???
; 47f0 5b       ???
; 47f1 04       ???
; 47f2 9f       ???
; 47f3 89       ???
; 47f4 96 31    stx $31,y
; 47f6 b7       ???
; 47f7 42       ???
; 47f8 b3       ???
; 47f9 9b       ???
; 47fa 9f       ???
; 47fb 32       ???
; 47fc 2b       ???
; 47fd 25 2d    and $2d
; 47ff 96 f2    stx $f2,y
; 4801 3b       ???
; 4802 08       php 
; 4803 58       cli 
; 4804 9c       ???
; 4805 11 8e    ora ($8e),y
; 4807 23       ???
; 4808 32       ???
; 4809 17       ???
; 480a ad 25 f2 lda $f225
; 480d 89       ???
; 480e bb       ???
; 480f c7       ???
; 4810 25 9a    and $9a
; 4812 93       ???
; 4813 1e d3 3c asl $3cd3,x
; 4816 8a       txa 
; 4817 1b       ???
; 4818 1f       ???
; 4819 7e 04 a1 ror $a104,x
; 481c 19 8f 0f ora $0f8f,y
; 481f 89       ???
; 4820 23       ???
; 4821 3d 30 2d and $2d30,x
; 4824 2e 8a 87 rol $878a
; 4827 b1 44    lda ($44),y
; 4829 45 4c    eor $4c
; 482b 45 9d    eor $9d
; 482d 1b       ???
; 482e 2a       rol a
; 482f bb       ???
; 4830 ad 05 1b lda $1b05
; 4833 bb       ???
; 4834 b4 2d    ldy $2d,x
; 4836 29 85    and #$85
; 4838 03       ???
; 4839 fc       ???
; 483a 74       ???
; 483b 7b       ???
; 483c 17       ???
; 483d 41 18    eor ($18,x)
; 483f 00       brk 
; 4840 a1 33    lda ($33,x)
; 4842 bc 3c dc ldy $dc3c,x
; 4845 cd 03 77 cmp $7703
; 4848 a1 a4    lda ($a4,x)
; 484a 7a       ???
; 484b 91 38    sta ($38),y
; 484d 22       ???
; 484e 08       php 
; 484f 98       tya 
; 4850 a5 16    lda $16
; 4852 1d 32 91 ora $9132,x
; 4855 05 93    ora $93
; 4857 7c       ???
; 4858 0f       ???
; 4859 0f       ???
; 485a 85 c7    sta $c7
; 485c cc 8a ff cpy $ff8a
; 485f ff       ???
; 4860 bb       ???
; 4861 f5 54    sbc $54,x
; 4863 1a       ???
; 4864 88       dey 
; 4865 2f       ???
; 4866 cb       ???
; 4867 24 91    bit $91
; 4869 a2 3d    ldx #$3d
; 486b b9 7b 8d lda $8d7b,y
; 486e 26 28    rol $28
; 4870 fd 30 e6 sbc $e630,x
; 4873 7f       ???
; 4874 e9 7c    sbc #$7c
; 4876 91 38    sta ($38),y
; 4878 22       ???
; 4879 08       php 
; 487a 22       ???
; 487b a6 03    ldx $03
; 487d f2       ???
; 487e 7b       ???
; 487f 23       ???
; 4880 ad a9 2e lda $2ea9
; 4883 8a       txa 
; 4884 5b       ???
; 4885 5b       ???
; 4886 8a       txa 
; 4887 25 26    and $26
; 4889 32       ???
; 488a 31 25    and ($25),y
; 488c b0 b4    bcs $4842
; 488e 2a       rol a
; 488f d2       ???
; 4890 c5 0a    cmp $0a
; 4892 7a       ???
; 4893 03       ???
; 4894 07       ???
; 4895 f2       ???
; 4896 95 22    sta $22,x
; 4898 a2 2b    ldx #$2b
; 489a 9f       ???
; 489b 2e 01 f8 rol $f801
; 489e cd bd 08 cmp $08bd
; 48a1 1d 26 85 ora $8526,x
; 48a4 3a       ???
; 48a5 5b       ???
; 48a6 33       ???
; 48a7 7f       ???
; 48a8 5b       ???
; 48a9 8d bb 1c sta $1cbb
; 48ac 8b       ???
; 48ad 2a       rol a
; 48ae 18       clc 
; 48af ae 34 1b ldx $1b34
; 48b2 48       pha 
; 48b3 57       ???
; 48b4 19 ff a3 ora $a3ff,y
; 48b7 29 85    and #$85
; 48b9 c8       iny 
; 48ba 73       ???
; 48bb 74       ???
; 48bc 56 7b    lsr $7b,x
; 48be 77       ???
; 48bf 8b       ???
; 48c0 a6 92    ldx $92
; 48c2 7e a8 2b ror $2ba8,x
; 48c5 39 b2 15 and $15b2,y
; 48c8 89       ???
; 48c9 3b       ???
; 48ca dd 2b 12 cmp $122b,x
; 48cd 77       ???
; 48ce 7b       ???
; 48cf 23       ???
; 48d0 3d 30 2d and $2d30,x
; 48d3 2e 17 e9 rol $e917
; 48d6 9a       txs 
; 48d7 57       ???
; 48d8 19 3b 08 ora $083b,y
; 48db 58       cli 
; 48dc 9c       ???
; 48dd 11 8e    ora ($8e),y
; 48df 23       ???
; 48e0 32       ???
; 48e1 17       ???
; 48e2 ad 47 ae lda $ae47
; 48e5 9d 8f 96 sta $968f,x
; 48e8 93       ???
; 48e9 1e d3 2c asl $2cd3,x
; 48ec 1f       ???
; 48ed 1f       ???
; 48ee c8       iny 
; 48ef 8c 8d 38 sty $388d
; 48f2 3b       ???
; 48f3 b4 6f    ldy $6f,x
; 48f5 28       plp 
; 48f6 30 2b    bmi $4923
; 48f8 8a       txa 
; 48f9 92       ???
; 48fa 1d 16 30 ora $3016,x
; 48fd 97       ???
; 48fe f2       ???
; 48ff 44       ???
; 4900 50 c4    bvc $48c6
; 4902 98       tya 
; 4903 a5 ac    lda $ac
; 4905 9e       ???
; 4906 99 ae cc sta $ccae,y
; 4909 ee 19 a5 inc $a519
; 490c a4 4d    ldy $4d
; 490e 34       ???
; 490f 0a       asl a
; 4910 fb       ???
; 4911 f0 bb    beq $48ce
; 4913 44       ???
; 4914 12       ???
; 4915 89       ???
; 4916 96 35    stx $35,y
; 4918 c3       ???
; 4919 24 90    bit $90
; 491b 2b       ???
; 491c a5 ab    lda $ab
; 491e 29 88    and #$88
; 4920 5b       ???
; 4921 e9 7c    sbc #$7c
; 4923 04       ???
; 4924 92       ???
; 4925 06 1f    asl $1f
; 4927 32       ???
; 4928 ce 31 8d dec $8d31
; 492b 26 26    rol $26
; 492d bd 42 b9 lda $b942,x
; 4930 2f       ???
; 4931 88       dey 
; 4932 5b       ???
; 4933 5b       ???
; 4934 77       ???
; 4935 8e a9 2e stx $2ea9
; 4938 8a       txa 
; 4939 17       ???
; 493a 17       ???
; 493b 33       ???
; 493c 33       ???
; 493d 87       ???
; 493e 28       plp 
; 493f 30 2b    bmi $496c
; 4941 8a       txa 
; 4942 8d 1a a2 sta $a21a
; 4945 ae 28 b6 ldx $b628
; 4948 e2       ???
; 4949 02       ???
; 494a 61 49    adc ($49,x)
; 494c 1d 5b 5b ora $5b5b,x
; 494f 77       ???
; 4950 8b       ???
; 4951 a6 92    ldx $92
; 4953 17       ???
; 4954 17       ???
; 4955 8c 1a 23 sty $231a
; 4958 30 23    bmi $497d
; 495a bc 46 b9 ldy $b946,x
; 495d 2f       ???
; 495e 88       dey 
; 495f 7b       ???
; 4960 06 16    asl $16
; 4962 d2       ???
; 4963 c2       ???
; 4964 08       php 
; 4965 15 13    ora $13,x
; 4967 1d 96 f2 ora $f296,x
; 496a 5b       ???
; 496b 5b       ???
; 496c 77       ???
; 496d 8b       ???
; 496e a6 92    ldx $92
; 4970 17       ???
; 4971 17       ???
; 4972 77       ???
; 4973 12       ???
; 4974 2d 36 92 and $9236
; 4977 1c       ???
; 4978 a5 b9    lda $b9
; 497a cc be 2e cpy $2ebe
; 497d d2       ???
; 497e a6 d6    ldx $d6
; 4980 c3       ???
; 4981 58       cli 
; 4982 92       ???
; 4983 10 09    bpl $498e
; 4985 dd d4 dd cmp $ddd4,x
; 4988 d1 b9    cmp ($b9),y
; 498a 6c 23 a0 jmp ($a023)
; 498d e9 99    sbc #$99
; 498f 08       php 
; 4990 65 ec    adc $ec
; 4992 a4 a5    ldy $a5
; 4994 ac 9e 99 ldy $999e
; 4997 ae cc ee ldx $eecc
; 499a 8b       ???
; 499b 9c       ???
; 499c 98       tya 
; 499d bf       ???
; 499e b2       ???
; 499f 05 b0    ora $b0
; 49a1 5a       ???
; 49a2 34       ???
; 49a3 8c 7b 44 sty $447b
; 49a6 43       ???
; 49a7 d1 b6    cmp ($b6),y
; 49a9 10 58    bpl $4a03
; 49ab b5 6c    lda $6c,x
; 49ad d1 77    cmp ($77),y
; 49af 8b       ???
; 49b0 a6 92    ldx $92
; 49b2 2a       rol a
; 49b3 b3       ???
; 49b4 16 24    asl $24,x
; 49b6 12       ???
; 49b7 7b       ???
; 49b8 17       ???
; 49b9 27       ???
; 49ba 8e b5 6c stx $6cb5
; 49bd 35 88    and $88,x
; 49bf bb       ???
; 49c0 21 5b    and ($5b,x)
; 49c2 5b       ???
; 49c3 1e 2b 1f asl $1f2b,x
; 49c6 43       ???
; 49c7 bb       ???
; 49c8 8a       txa 
; 49c9 2f       ???
; 49ca c6 ae    dec $ae
; 49cc 17       ???
; 49cd 33       ???
; 49ce 44       ???
; 49cf 2b       ???
; 49d0 1a       ???
; 49d1 2c 5d 1f bit $1f5d
; 49d4 5b       ???
; 49d5 5b       ???
; 49d6 2c 5c c3 bit $c35c
; 49d9 95 f2    sta $f2,x
; 49db fc       ???
; 49dc d2       ???
; 49dd a6 68    ldx $68
; 49df a0 41    ldy #$41
; 49e1 c5 6a    cmp $6a
; 49e3 0b       ???
; 49e4 b7       ???
; 49e5 92       ???
; 49e6 41 09    eor ($09,x)
; 49e8 57       ???
; 49e9 12       ???
; 49ea 2d 36 92 and $9236
; 49ed 93       ???
; 49ee d0 b4    bne $49a4
; 49f0 19 70 68 ora $6870,y
; 49f3 27       ???
; 49f4 30 32    bmi $4a28
; 49f6 d3       ???
; 49f7 12       ???
; 49f8 0b       ???
; 49f9 b7       ???
; 49fa ae 02 04 ldx $0402
; 49fd b2       ???
; 49fe 13       ???
; 49ff 65 71    adc $71
; 4a01 a5 9e    lda $9e
; 4a03 2e 29 65 rol $6529
; 4a06 71 32    adc ($32),y
; 4a08 a1 e0    lda ($e0,x)
; 4a0a fc       ???
; 4a0b bb       ???
; 4a0c 1a       ???
; 4a0d 8c 17 aa sty $aa17
; 4a10 29 65    and #$65
; 4a12 ae 49 49 ldx $4949
; 4a15 7c       ???
; 4a16 7c       ???
; 4a17 67       ???
; 4a18 b5 47    lda $47,x
; 4a1a f9 58 17 sbc $1758,y
; 4a1d 9f       ???
; 4a1e e0 5e    cpx #$5e
; 4a20 ae c3 73 ldx $73c3
; 4a23 ac 75 97 ldy $9775
; 4a26 98       tya 
; 4a27 7b       ???
; 4a28 d1 65    cmp ($65),y
; 4a2a 04       ???
; 4a2b c2       ???
; 4a2c 34       ???
; 4a2d 8c 5b 22 sty $225b
; 4a30 cf       ???
; 4a31 5b       ???
; 4a32 79 79 2e adc $2e79,y
; 4a35 4e 88 bb lsr $bb88
; 4a38 64       ???
; 4a39 bd 07 5b lda $5b07,x
; 4a3c 6f       ???
; 4a3d d6 66    dec $66,x
; 4a3f ac 5b 5b ldy $5b5b
; 4a42 23       ???
; 4a43 2d 27 d3 and $d327
; 4a46 be 5b 5b ldx $5b5b,y
; 4a49 8f       ???
; 4a4a a6 c2    ldx $c2
; 4a4c 61 be    adc ($be,x)
; 4a4e 5b       ???
; 4a4f 0f       ???
; 4a50 bb       ???
; 4a51 97       ???
; 4a52 97       ???
; 4a53 b2       ???
; 4a54 55 52    eor $52,x
; 4a56 34       ???
; 4a57 8c 5b 0e sty $0e5b
; 4a5a 59 c1 b3 eor $b3c1,y
; 4a5d ac 29 88 ldy $8829
; 4a60 aa       tax 
; 4a61 8a       txa 
; 4a62 0e 64 24 asl $2464
; 4a65 88       dey 
; 4a66 bb       ???
; 4a67 21 aa    and ($aa,x)
; 4a69 8a       txa 
; 4a6a 68       pla 
; 4a6b 29 30    and #$30
; 4a6d 2b       ???
; 4a6e 8a       txa 
; 4a6f 8c c7 cb sty $cbc7
; 4a72 2c b6 a7 bit $a7b6
; 4a75 5b       ???
; 4a76 5a       ???
; 4a77 91 93    sta ($93),y
; 4a79 23       ???
; 4a7a a7       ???
; 4a7b 8d 5b 5e sta $5e5b
; 4a7e 1f       ???
; 4a7f a2 8f    ldx #$8f
; 4a81 13       ???
; 4a82 65 fd    adc $fd
; 4a84 aa       tax 
; 4a85 18       clc 
; 4a86 2c 1c 5b bit $5b1c
; 4a89 92       ???
; 4a8a 92       ???
; 4a8b 57       ???
; 4a8c b3       ???
; 4a8d cf       ???
; 4a8e b0 5d    bcs $4aed
; 4a90 20 6b c3 jsr $c36b
; 4a93 c4 6c    cpy $6c
; 4a95 6c b7 f9 jmp ($f9b7)
; 4a98 0e cc 9e asl $9ecc
; 4a9b e0 9c    cpx #$9c
; 4a9d 9c       ???
; 4a9e f7       ???
; 4a9f a4 8e    ldy $8e
; 4aa1 e1 5e    sbc ($5e,x)
; 4aa3 b5 be    lda $be,x
; 4aa5 12       ???
; 4aa6 ad 02 06 lda $0602
; 4aa9 b0 17    bcs $4ac2
; 4aab 26 bb    rol $bb
; 4aad 02       ???
; 4aae 6b       ???
; 4aaf 16 07    asl $07,x
; 4ab1 09 af    ora #$af
; 4ab3 02       ???
; 4ab4 5b       ???
; 4ab5 18       clc 
; 4ab6 a2 93    ldx #$93
; 4ab8 15 bb    ora $bb,x
; 4aba 02       ???
; 4abb 7d 9d 8b adc $8b9d,x
; 4abe 32       ???
; 4abf 1f       ???
; 4ac0 8c 02 77 sty $7702
; 4ac3 b9 10 96 lda $9610,y
; 4ac6 b6 7f    ldx $7f,y
; 4ac8 7f       ???
; 4ac9 ae 3b 5b ldx $5b3b
; 4acc 6d 8d b6 adc $b68d
; 4acf b6 1d    ldx $1d,y
; 4ad1 33       ???
; 4ad2 a3       ???
; 4ad3 a3       ???
; 4ad4 e4 7d    cpx $7d
; 4ad6 9d 89 cb sta $cb89,x
; 4ad9 6e 5e bf ror $bf5e
; 4adc 32       ???
; 4add d6 11    dec $11,x
; 4adf 7d 9d 33 adc $339d,x
; 4ae2 6a       ror a
; 4ae3 b3       ???
; 4ae4 7c       ???
; 4ae5 8d 2a c0 sta $c02a
; 4ae8 ad 8d 9a lda $9a8d
; 4aeb 65 4f    adc $4f
; 4aed 02       ???
; 4aee 81 80    sta ($80,x)
; 4af0 60       rts 
; 4af1 1b       ???
; 4af2 0a       asl a
; 4af3 bd 7f 7f lda $7f7f,x
; 4af6 ae 8e 4f ldx $4f8e
; 4af9 8e 9a 74 stx $749a
; 4afc e7       ???
; 4afd ac ac ab ldy $abac
; 4b00 8b       ???
; 4b01 ac 82 87 ldy $8782
; 4b04 b1 4f    lda ($4f),y
; 4b06 34       ???
; 4b07 b3       ???
; 4b08 b2       ???
; 4b09 92       ???
; 4b0a 74       ???
; 4b0b 1f       ???
; 4b0c 20 dc 15 jsr $15dc
; 4b0f 6c c4 c8 jmp ($c8c4)
; 4b12 2c 21 65 bit $6521
; 4b15 57       ???
; 4b16 a2 45    ldx #$45
; 4b18 fa       ???
; 4b19 6c ba a5 jmp ($a5ba)
; 4b1c 57       ???
; 4b1d 67       ???
; 4b1e c9 c9    cmp #$c9
; 4b20 c2       ???
; 4b21 29 8c    and #$8c
; 4b23 c3       ???
; 4b24 37       ???
; 4b25 2c a7 5b bit $5ba7
; 4b28 9c       ???
; 4b29 9c       ???
; 4b2a 9d bd ae sta $aebd,x
; 4b2d 8e 9d bd stx $bd9d
; 4b30 bc 9c 9d ldy $9d9c,x
; 4b33 bd b6 96 lda $96b6,x
; 4b36 96 b6    stx $b6,y
; 4b38 bc 9c 68 ldy $689c,x
; 4b3b a0 91    ldy #$91
; 4b3d b9 72 12 lda $1272,y
; 4b40 69 21    adc #$21
; 4b42 27       ???
; 4b43 c4 c0    cpy $c0
; 4b45 6b       ???
; 4b46 76 37    ror $37,x
; 4b48 30 1f    bmi $4b69
; 4b4a 15 65    ora $65,x
; 4b4c 59 b8 ba eor $bab8,y
; 4b4f 06 b5    asl $b5
; 4b51 0a       asl a
; 4b52 69 21    adc #$21
; 4b54 23       ???
; 4b55 a0 33    ldy #$33
; 4b57 b7       ???
; 4b58 67       ???
; 4b59 6b       ???
; 4b5a 16 20    asl $20,x
; 4b5c 22       ???
; 4b5d ab       ???
; 4b5e b9 69 70 lda $7069,y
; 4b61 37       ???
; 4b62 2e 2f 22 rol $222f
; 4b65 7a       ???
; 4b66 92       ???
; 4b67 39 2f 23 and $232f,y
; 4b6a 69 6b    adc #$6b
; 4b6c 2a       rol a
; 4b6d 1a       ???
; 4b6e 22       ???
; 4b6f d2       ???
; 4b70 b8       clv 
; 4b71 5b       ???
; 4b72 5b       ???
; 4b73 90 03    bcc $4b78
; 4b75 8b       ???
; 4b76 2c 32 1e bit $1e32
; 4b79 5b       ???
; 4b7a ac 82 87 ldy $8782
; 4b7d b1 ab    lda ($ab),y
; 4b7f ab       ???
; 4b80 1b       ???
; 4b81 8a       txa 
; 4b82 3d cb ab and $abcb,x
; 4b85 1b       ???
; 4b86 89       ???
; 4b87 3c       ???
; 4b88 cb       ???
; 4b89 ab       ???
; 4b8a 1a       ???
; 4b8b 89       ???
; 4b8c 1d 1a 88 ora $881a,x
; 4b8f 1c       ???
; 4b90 5b       ???
; 4b91 8c ff 8f sty $8fff
; 4b94 29 98    and #$98
; 4b96 9c       ???
; 4b97 a1 a0    lda ($a0,x)
; 4b99 33       ???
; 4b9a 76 5b    ror $5b,x
; 4b9c 18       clc 
; 4b9d a2 a7    ldx #$a7
; 4b9f 2c b8 c0 bit $c0b8
; 4ba2 72       ???
; 4ba3 6c c3 c2 jmp ($c2c3)
; 4ba6 30 2c    bmi $4bd4
; 4ba8 12       ???
; 4ba9 bb       ???
; 4baa cc 6a 5c cpy $5c6a
; 4bad 1d 28 12 ora $1228,x
; 4bb0 14       ???
; 4bb1 69 57    adc #$57
; 4bb3 1f       ???
; 4bb4 c9 64    cmp #$64
; 4bb6 42       ???
; 4bb7 ff       ???
; 4bb8 17       ???
; 4bb9 2a       rol a
; 4bba 3c       ???
; 4bbb 29 96    and #$96
; 4bbd 31 28    and ($28),y
; 4bbf 29 a6    and #$a6
; 4bc1 a4 bf    ldy $bf
; 4bc3 b5 7e    lda $7e,x
; 4bc5 89       ???
; 4bc6 cb       ???
; 4bc7 29 83    and #$83
; 4bc9 8a       txa 
; 4bca 93       ???
; 4bcb 35 2f    and $2f,x
; 4bcd c3       ???
; 4bce 04       ???
; 4bcf 70 90    bvs $4b61
; 4bd1 79 1b be adc $be1b,y
; 4bd4 5d bd 21 eor $21bd,x
; 4bd7 ab       ???
; 4bd8 41 09    eor ($09,x)
; 4bda ce 8c bf dec $bf8c
; 4bdd 51 b7    eor ($b7),y
; 4bdf 67       ???
; 4be0 ce 8a 15 dec $158a
; 4be3 1d 36 72 ora $7236,x
; 4be6 ce 7a 15 dec $157a
; 4be9 b8       clv 
; 4bea be d3 12 ldx $12d3,y
; 4bed ce 1c a6 dec $a61c
; 4bf0 19 33 1e ora $1e33,y
; 4bf3 aa       tax 
; 4bf4 b7       ???
; 4bf5 67       ???
; 4bf6 1d 1d 1c ora $1c1d,x
; 4bf9 1c       ???
; 4bfa 5e b5 6c lsr $6cb5,x
; 4bfd 15 72    ora $72,x
; 4bff a7       ???
; 4c00 8f       ???
; 4c01 b5 29    lda $29,x
; 4c03 3d 1d 6a and $6a1d,x
; 4c06 15 1c    ora $1c,x
; 4c08 21 5e    and ($5e,x)
; 4c0a 75 95    adc $95,x
; 4c0c 96 31    stx $31,y
; 4c0e cb       ???
; 4c0f 40       rti 
; 4c10 ac 9c 2e ldy $2e9c
; 4c13 cf       ???
; 4c14 34       ???
; 4c15 b0 2c    bcs $4c43
; 4c17 0f       ???
; 4c18 8d 1d 0e sta $0e1d
; 4c1b 19 cb 4c ora $4ccb,y
; 4c1e 35 28    and $28,x
; 4c20 dd 65 20 cmp $2065,x
; 4c23 28       plp 
; 4c24 35 9a    and $9a,x
; 4c26 f2       ???
; 4c27 95 95    sta $95,x
; 4c29 96 31    stx $31,y
; 4c2b cb       ???
; 4c2c 40       rti 
; 4c2d ac 9c 0f ldy $0f9c
; 4c30 0f       ???
; 4c31 29 c3    and #$c3
; 4c33 14       ???
; 4c34 89       ???
; 4c35 0d fe 77 ora $77fe
; 4c38 1f       ???
; 4c39 3d d0 29 and $29d0,x
; 4c3c 8c 2b 2a sty $2a2b
; 4c3f 30 73    bmi $4cb4
; 4c41 67       ???
; 4c42 9a       txs 
; 4c43 01 5b    ora ($5b,x)
; 4c45 e9 7c    sbc #$7c
; 4c47 95 23    sta $23,x
; 4c49 8d ff 8d sta $8dff
; 4c4c 1a       ???
; 4c4d 08       php 
; 4c4e 7b       ???
; 4c4f 8f       ???
; 4c50 19 a4 1a ora $1aa4,y
; 4c53 7a       ???
; 4c54 1b       ???
; 4c55 9e       ???
; 4c56 dd 13 d6 cmp $d613,x
; 4c59 2c 89 9b bit $9b89
; 4c5c a9 1d    lda #$1d
; 4c5e 0f       ???
; 4c5f 77       ???
; 4c60 16 1a    asl $1a,x
; 4c62 7b       ???
; 4c63 04       ???
; 4c64 2e 18 19 rol $1918
; 4c67 28       plp 
; 4c68 dd 5a 08 cmp $085a,x
; 4c6b 13       ???
; 4c6c 94 dd    sty $dd,x
; 4c6e ce 8b 16 dec $168b
; 4c71 15 26    ora $26,x
; 4c73 2e 29 65 rol $6529
; 4c76 ce 8b 16 dec $168b
; 4c79 05 15    ora $15
; 4c7b 69 ce    adc #$ce
; 4c7d 88       dey 
; 4c7e 13       ???
; 4c7f 07       ???
; 4c80 0a       asl a
; 4c81 13       ???
; 4c82 65 ce    adc $ce
; 4c84 88       dey 
; 4c85 16 23    asl $23,x
; 4c87 bf       ???
; 4c88 b4 2e    ldy $2e,x
; 4c8a 29 65    and #$65
; 4c8c 57       ???
; 4c8d 16 1a    asl $1a,x
; 4c8f 0b       ???
; 4c90 5e 71 32 lsr $3271,x
; 4c93 cd 0c 67 cmp $670c
; 4c96 15 07    ora $07,x
; 4c98 17       ???
; 4c99 6c ff ab jmp ($abff)
; 4c9c 5a       ???
; 4c9d 9c       ???
; 4c9e 9c       ???
; 4c9f 5e 1f a2 lsr $a21f,x
; 4ca2 e1 10    sbc ($10,x)
; 4ca4 bc 07 7b ldy $7b07,x
; 4ca7 87       ???
; 4ca8 bf       ???
; 4ca9 c2       ???
; 4caa 15 a4    ora $a4,x
; 4cac b4 69    ldy $69,x
; 4cae 65 24    adc $24
; 4cb0 32       ???
; 4cb1 73       ???
; 4cb2 5b       ???
; 4cb3 1d 2f a1 ora $a12f,x
; 4cb6 e2       ???
; 4cb7 5b       ???
; 4cb8 1f       ???
; 4cb9 1d 12 67 ora $6712,x
; 4cbc 5a       ???
; 4cbd 08       php 
; 4cbe 1d 1f 25 ora $251f,x
; 4cc1 32       ???
; 4cc2 c7       ???
; 4cc3 0a       asl a
; 4cc4 6a       ror a
; 4cc5 b4 2e    ldy $2e,x
; 4cc7 e4 06    cpx $06
; 4cc9 56 fe    lsr $fe,x
; 4ccb 75 38    adc $38,x
; 4ccd 21 a8    and ($a8,x)
; 4ccf 2b       ???
; 4cd0 39 c4 c7 and $c7c4,y
; 4cd3 09 69    ora #$69
; 4cd5 21 11    and ($11,x)
; 4cd7 a2 4f    ldx #$4f
; 4cd9 c8       iny 
; 4cda 1c       ???
; 4cdb 5a       ???
; 4cdc 68       pla 
; 4cdd 13       ???
; 4cde 1b       ???
; 4cdf 32       ???
; 4ce0 27       ???
; 4ce1 65 57    adc $57
; 4ce3 12       ???
; 4ce4 30 23    bmi $4d09
; 4ce6 18       clc 
; 4ce7 6a       ror a
; 4ce8 59 b8 ba eor $bab8,y
; 4ceb 06 b5    asl $b5
; 4ced 0a       asl a
; 4cee e0 38    cpx #$38
; 4cf0 c8       iny 
; 4cf1 c9 07    cmp #$07
; 4cf3 5e 19 26 lsr $2619,x
; 4cf6 16 1d    asl $1d,x
; 4cf8 39 d7 10 and $10d7,y
; 4cfb 68       pla 
; 4cfc b6 4e    ldx $4e,y
; 4cfe 4a       lsr a
; 4cff a4 5a    ldy $5a
; 4d01 6f       ???
; 4d02 2c 28 2a bit $2a28
; 4d05 1a       ???
; 4d06 22       ???
; 4d07 a6 3b    ldx $3b
; 4d09 0a       asl a
; 4d0a 59 1b 20 eor $201b,y
; 4d0d ac 4b ba ldy $ba4b
; 4d10 17       ???
; 4d11 92       ???
; 4d12 41 09    eor ($09,x)
; 4d14 6a       ror a
; 4d15 b8       clv 
; 4d16 bb       ???
; 4d17 29 24    and #$24
; 4d19 13       ???
; 4d1a 1d 72 53 ora $5372,x
; 4d1d 53       ???
; 4d1e 62       ???
; 4d1f 82       ???
; 4d20 83       ???
; 4d21 83       ???
; 4d22 88       dey 
; 4d23 bb       ???
; 4d24 21 a9    and ($a9,x)
; 4d26 89       ???
; 4d27 32       ???
; 4d28 c0 17    cpy #$17
; 4d2a 89       ???
; 4d2b 88       dey 
; 4d2c a8       tay 
; 4d2d 8c 23 85 sty $8523
; 4d30 a7       ???
; 4d31 87       ???
; 4d32 32       ???
; 4d33 52       ???
; 4d34 8c 17 05 sty $0517
; 4d37 7a       ???
; 4d38 50 30    bvc $4d6a
; 4d3a ce 8d 4e dec $4e8d
; 4d3d af       ???
; 4d3e 9e       ???
; 4d3f 7e 5e 22 ror $225e,x
; 4d42 c3       ???
; 4d43 32       ???
; 4d44 e1 57    sbc ($57,x)
; 4d46 aa       tax 
; 4d47 c5 2e    cmp $2e
; 4d49 6a       ror a
; 4d4a 0c       ???
; 4d4b c7       ???
; 4d4c 89       ???
; 4d4d ce 0c d3 dec $d30c
; 4d50 22       ???
; 4d51 7b       ???
; 4d52 ce 0e cd dec $cd0e
; 4d55 29 98    and #$98
; 4d57 52       ???
; 4d58 24 b5    bit $b5
; 4d5a ba       tsx 
; 4d5b b2       ???
; 4d5c b5 b6    lda $b6,x
; 4d5e 6a       ror a
; 4d5f 18       clc 
; 4d60 23       ???
; 4d61 cb       ???
; 4d62 04       ???
; 4d63 ce 8b b6 dec $b68b
; 4d66 b8       clv 
; 4d67 cd c7 12 cmp $12c7
; 4d6a 14       ???
; 4d6b 69 75    adc #$75
; 4d6d c6 ff    dec $ff
; 4d6f 9b       ???
; 4d70 58       cli 
; 4d71 2c 32 34 bit $3432
; 4d74 c2       ???
; 4d75 bb       ???
; 4d76 b6 fa    ldx $fa,y
; 4d78 96 96    stx $96,y
; 4d7a 71 a8    adc ($a8),y
; 4d7c a7       ???
; 4d7d 1c       ???
; 4d7e 19 bd fe ora $febd,y
; 4d81 02       ???
; 4d82 c9 33    cmp #$33
; 4d84 c7       ???
; 4d85 09 5a    ora #$5a
; 4d87 a8       tay 
; 4d88 b7       ???
; 4d89 69 5b    adc #$5b
; 4d8b 0b       ???
; 4d8c 1f       ???
; 4d8d 1b       ???
; 4d8e 06 ae    asl $ae
; 4d90 02       ???
; 4d91 86 86    stx $86
; 4d93 85 85    sta $85
; 4d95 8d 4e 36 sta $364e
; 4d98 31 6a    and ($6a),y
; 4d9a 7f       ???
; 4d9b 7f       ???
; 4d9c 80       ???
; 4d9d 80       ???
; 4d9e ff       ???
; 4d9f bc 32 bf ldy $bf32,x
; 4da2 a4 5a    ldy $5a
; 4da4 69 21    adc #$21
; 4da6 cd c5 b3 cmp $b3c5
; 4da9 34       ???
; 4daa 3b       ???
; 4dab 0a       asl a
; 4dac 69 26    adc #$26
; 4dae d2       ???
; 4daf d7       ???
; 4db0 1c       ???
; 4db1 08       php 
; 4db2 23       ???
; 4db3 32       ???
; 4db4 6b       ???
; 4db5 fe b7 bf inc $bfb7,x
; 4db8 56 52    lsr $52,x
; 4dba 02       ???
; 4dbb 7c       ???
; 4dbc 7c       ???
; 4dbd 73       ???
; 4dbe a7       ???
; 4dbf a6 be    ldx $be
; 4dc1 fa       ???
; 4dc2 6a       ror a
; 4dc3 25 28    and $28
; 4dc5 29 2e    and #$2e
; 4dc7 29 65    and #$65
; 4dc9 69 13    adc #$13
; 4dcb 8c e2 09 sty $09e2
; 4dce 67       ???
; 4dcf 68       pla 
; 4dd0 0a       asl a
; 4dd1 58       cli 
; 4dd2 1f       ???
; 4dd3 32       ???
; 4dd4 32       ???
; 4dd5 36 d3    rol $d3,x
; 4dd7 12       ???
; 4dd8 e3       ???
; 4dd9 90 7b    bcc $4e56
; 4ddb ce b1 b3 dec $b3b1
; 4dde 9d 9b d0 sta $d09b,x
; 4de1 d4       ???
; 4de2 b3       ???
; 4de3 af       ???
; 4de4 ce 1f bb dec $bb1f
; 4de7 8a       txa 
; 4de8 ce 65 9c dec $9c65
; 4deb e5 5e    sbc $5e
; 4ded c0 d5    cpy #$d5
; 4def b0 ae    bcs $4d9f
; 4df1 a4 2d    ldy $2d
; 4df3 a7       ???
; 4df4 5b       ???
; 4df5 6a       ror a
; 4df6 ce be 7a dec $7abe
; 4df9 8b       ???
; 4dfa cb       ???
; 4dfb b9 15 17 lda $1715,y
; 4dfe 5b       ???
; 4dff 75 dc    adc $dc,x
; 4e01 35 17    and $17,x
; 4e03 a5 15    lda $15
; 4e05 14       ???
; 4e06 5b       ???
; 4e07 5c       ???
; 4e08 1d 2c 30 ora $302c,x
; 4e0b 93       ???
; 4e0c 88       dey 
; 4e0d bb       ???
; 4e0e 62       ???
; 4e0f 64       ???
; 4e10 34       ???
; 4e11 8c 5b 58 sty $585b
; 4e14 19 33 2f ora $2f33,y
; 4e17 2a       rol a
; 4e18 ca       dex 
; 4e19 6e 11 5e ror $5e11
; 4e1c 22       ???
; 4e1d c3       ???
; 4e1e ab       ???
; 4e1f 5a       ???
; 4e20 5a       ???
; 4e21 05 1d    ora $1d
; 4e23 39 25 5e and $5e25,y
; 4e26 6c bd 50 jmp ($50bd)
; 4e29 be 6d 6b ldx $6b6d,y
; 4e2c be c3 70 ldx $70c3,y
; 4e2f 9c       ???
; 4e30 45 12    eor $12
; 4e32 bd 02 9c lda $9c02,x
; 4e35 9c       ???
; 4e36 9d bd bc sta $bcbd,x
; 4e39 9c       ???
; 4e3a 9d bd b6 sta $b6bd,x
; 4e3d 96 fe    stx $fe,y
; 4e3f c6 35    dec $35
; 4e41 d3       ???
; 4e42 c0 ab    cpy #$ab
; 4e44 ab       ???
; 4e45 5a       ???
; 4e46 3f       ???
; 4e47 3f       ???
; 4e48 fe b7 87 inc $87b7,x
; 4e4b ce 02 22 dec $2202
; 4e4e ce ce 8a dec $8ace
; 4e51 8c 8e c4 sty $c48e
; 4e54 4f       ???
; 4e55 b9 90 e8 lda $e890,y
; 4e58 e8       inx 
; 4e59 95 97    sta $97,x
; 4e5b 19 bb 36 ora $36bb,y
; 4e5e 72       ???
; 4e5f ce 92 a7 dec $a792
; 4e62 8f       ???
; 4e63 b5 29    lda $29,x
; 4e65 7a       ???
; 4e66 08       php 
; 4e67 07       ???
; 4e68 1c       ???
; 4e69 2f       ???
; 4e6a c7       ???
; 4e6b 09 a5    ora #$a5
; 4e6d ac a8 a3 ldy $a3a8
; 4e70 9d 54 28 sta $2854,x
; 4e73 30 2b    bmi $4ea0
; 4e75 6d d1 8a adc $8ad1
; 4e78 29 24    and #$24
; 4e7a 85 44    sta $44
; 4e7c 44       ???
; 4e7d ca       dex 
; 4e7e ce f2 2a dec $2af2
; 4e81 6a       ror a
; 4e82 b7       ???
; 4e83 77       ???
; 4e84 91 2c    sta ($2c),y
; 4e86 b0 45    bcs $4ecd
; 4e88 aa       tax 
; 4e89 08       php 
; 4e8a 1d 2b 15 ora $152b,x
; 4e8d c0 35    cpy #$35
; 4e8f 91 28    sta ($28),y
; 4e91 9b       ???
; 4e92 a8       tay 
; 4e93 2c 8a f0 bit $f08a
; 4e96 bb       ???
; 4e97 62       ???
; 4e98 95 8d    sta $8d,x
; 4e9a 30 6f    bmi $4f0b
; 4e9c cc 3b de cpy $de3b
; 4e9f bd b7 33 lda $33b7,x
; 4ea2 c7       ???
; 4ea3 ab       ???
; 4ea4 7a       ???
; 4ea5 7e 0c ac ror $ac0c,x
; 4ea8 65 35    adc $35
; 4eaa 8f       ???
; 4eab 29 88    and #$88
; 4ead 2c ba 07 bit $07ba
; 4eb0 1b       ???
; 4eb1 73       ???
; 4eb2 3f       ???
; 4eb3 29 62    and #$62
; 4eb5 95 88    sta $88,x
; 4eb7 b8       clv 
; 4eb8 ba       tsx 
; 4eb9 8a       txa 
; 4eba 91 28    sta ($28),y
; 4ebc 9b       ???
; 4ebd a8       tay 
; 4ebe 2c 88 88 bit $8888
; 4ec1 bb       ???
; 4ec2 68       pla 
; 4ec3 d1 b1    cmp ($b1),y
; 4ec5 2b       ???
; 4ec6 a8       tay 
; 4ec7 36 92    rol $92,x
; 4ec9 91 28    sta ($28),y
; 4ecb 85 91    sta $91
; 4ecd 32       ???
; 4ece a1 00    lda ($00,x)
; 4ed0 7a       ???
; 4ed1 a8       tay 
; 4ed2 bb       ???
; 4ed3 1a       ???
; 4ed4 06 07    asl $07
; 4ed6 b0 22    bcs $4efa
; 4ed8 7e 1f 1c ror $1c1f,x
; 4edb 08       php 
; 4edc be be 22 ldx $22be,y
; 4edf a6 23    ldx $23
; 4ee1 b9 95 8d lda $8d95,y
; 4ee4 30 91    bmi $4e77
; 4ee6 8f       ???
; 4ee7 29 22    and #$22
; 4ee9 b4 37    ldy $37,x
; 4eeb a2 9c    ldx #$9c
; 4eed 09 f2    ora #$f2
; 4eef 88       dey 
; 4ef0 bb       ???
; 4ef1 21 3b    and ($3b,x)
; 4ef3 cb       ???
; 4ef4 1d 31 1e ora $1e31,x
; 4ef7 08       php 
; 4ef8 13       ???
; 4ef9 85 7b    sta $7b
; 4efb 06 1c    asl $1c
; 4efd 91 8f    sta ($8f),y
; 4eff 29 88    and #$88
; 4f01 94 1f    sty $1f,x
; 4f03 8b       ???
; 4f04 00       brk 
; 4f05 d9 c9 ce cmp $cec9,y
; 4f08 ce ab 58 dec $58ab
; 4f0b 58       cli 
; 4f0c 49 7c    eor #$7c
; 4f0e 3b       ???
; 4f0f 73       ???
; 4f10 54       ???
; 4f11 2e 00 2c rol $2c00
; 4f14 49 0b    eor #$0b
; 4f16 1e 1e 3b asl $3b1e,x
; 4f19 19 71 d0 ora $d071,y
; 4f1c b4 19    ldy $19,x
; 4f1e 90 79    bcc $4f99
; 4f20 1b       ???
; 4f21 37       ???
; 4f22 cb       ???
; 4f23 b2       ???
; 4f24 92       ???
; 4f25 28       plp 
; 4f26 f5 5a    sbc $5a,x
; 4f28 8b       ???
; 4f29 a6 92    ldx $92
; 4f2b 85 9c    sta $9c
; 4f2d 05 7a    ora $7a
; 4f2f 19 32 2e ora $2e32,y
; 4f32 89       ???
; 4f33 03       ???
; 4f34 e2       ???
; 4f35 d5 8d    cmp $8d,x
; 4f37 86 91    stx $91
; 4f39 97       ???
; 4f3a e6 c3    inc $c3
; 4f3c b3       ???
; 4f3d ae b5 b6 ldx $b6b5
; 4f40 ce 90 2f dec $2f90
; 4f43 30 2c    bmi $4f71
; 4f45 7a       ???
; 4f46 df       ???
; 4f47 ce ce 7a dec $7ace
; 4f4a 1b       ???
; 4f4b 8f       ???
; 4f4c ce ce 95 dec $95ce
; 4f4f 22       ???
; 4f50 7b       ???
; 4f51 ce 57 16 dec $1657
; 4f54 1a       ???
; 4f55 7b       ???
; 4f56 25 37    and $37
; 4f58 00       brk 
; 4f59 04       ???
; 4f5a 2e 18 19 rol $1918
; 4f5d 19 bb 9b ora $9bbb,y
; 4f60 d0 d4    bne $4f36
; 4f62 d2       ???
; 4f63 bb       ???
; 4f64 9b       ???
; 4f65 6a       ror a
; 4f66 2b       ???
; 4f67 2c 30 c7 bit $c730
; 4f6a 02       ???
; 4f6b ad d5 8d lda $8dd5
; 4f6e 86 91    stx $91
; 4f70 97       ???
; 4f71 e6 bf    inc $bf
; 4f73 5b       ???
; 4f74 23       ???
; 4f75 3d 25 5e and $5e25,x
; 4f78 ce 8d 8d dec $8d8d
; 4f7b ce ce 1a dec $1ace
; 4f7e a8       tay 
; 4f7f 23       ???
; 4f80 d9 12 ce cmp $ce12,y
; 4f83 90 2b    bcc $4fb0
; 4f85 12       ???
; 4f86 77       ???
; 4f87 ce ac cc dec $ccac
; 4f8a 96 c2    stx $c2,y
; 4f8c 1a       ???
; 4f8d 2f       ???
; 4f8e d5 d7    cmp $d7,x
; 4f90 bd 11 7e lda $7e11,x
; 4f93 74       ???
; 4f94 7b       ???
; 4f95 7b       ???
; 4f96 0b       ???
; 4f97 1d d4 35 ora $35d4,x
; 4f9a 90 2f    bcc $4fcb
; 4f9c 17       ???
; 4f9d 0f       ???
; 4f9e 68       pla 
; 4f9f b1 3d    lda ($3d),y
; 4fa1 45 b5    eor $b5
; 4fa3 cd ee 91 cmp $91ee
; 4fa6 d4       ???
; 4fa7 be 1a c6 ldx $c61a,y
; 4faa 27       ???
; 4fab 18       clc 
; 4fac b4 17    ldy $17,x
; 4fae 5b       ???
; 4faf ce 44 44 dec $4444
; 4fb2 ca       dex 
; 4fb3 ce f2 95 dec $95f2
; 4fb6 95 d1    sta $d1,x
; 4fb8 70 30    bvs $4fea
; 4fba 6f       ???
; 4fbb cc 8b 2a cpy $2a8b
; 4fbe 1d 0a 19 ora $190a,x
; 4fc1 bd 1e c3 lda $c31e,x
; 4fc4 c3       ???
; 4fc5 d1 72    cmp ($72),y
; 4fc7 29 95    and #$95
; 4fc9 db       ???
; 4fca ae af cf ldx $cfaf
; 4fcd 79 1b 35 adc $351b,y
; 4fd0 d0 b4    bne $4f86
; 4fd2 19 90 3d ora $3d90,y
; 4fd5 1d b5 bd ora $bdb5,x
; 4fd8 9f       ???
; 4fd9 96 cd    stx $cd,y
; 4fdb 1e bb 2c asl $2cbb,x
; 4fde 32       ???
; 4fdf ae ae d4 ldx $d4ae
; 4fe2 be 1a c6 ldx $c61a,y
; 4fe5 07       ???
; 4fe6 6b       ???
; 4fe7 16 07    asl $07,x
; 4fe9 0a       asl a
; 4fea 07       ???
; 4feb b7       ???
; 4fec 58       cli 
; 4fed a7       ???
; 4fee 5b       ???
; 4fef 68       pla 
; 4ff0 29 1c    and #$1c
; 4ff2 17       ???
; 4ff3 21 2a    and ($2a,x)
; 4ff5 2e 89 7b rol $7b89
; 4ff8 1e 28 c3 asl $c328,x
; 4ffb c7       ???
; 4ffc 69 68    adc #$68
; 4ffe bb       ???
; 4fff ad bd 63 lda $63bd
; 5002 bb       ???
; 5003 69 f3    adc #$f3
; 5005 41 5f    eor ($5f,x)
; 5007 60       rts 
; 5008 64       ???
; 5009 15 75    ora $75,x
; 500b 22       ???
; 500c 7b       ???
; 500d 17       ???
; 500e bb       ???
; 500f 39 30 13 and $1330,y
; 5012 ac 49 bd ldy $bd49
; 5015 35 c3    and $c3,x
; 5017 24 94    bit $94
; 5019 1f       ???
; 501a 1c       ???
; 501b 21 b2    and ($b2,x)
; 501d 49 61    eor #$61
; 501f d3       ???
; 5020 c3       ???
; 5021 c9 25    cmp #$25
; 5023 1d 65 a5 ora $a565,x
; 5026 ac a8 a3 ldy $a3a8
; 5029 ae 65 28 ldx $2865
; 502c 30 2b    bmi $5059
; 502e 8a       txa 
; 502f 8a       txa 
; 5030 29 24    and #$24
; 5032 85 44    sta $44
; 5034 44       ???
; 5035 ca       dex 
; 5036 ee b9 78 inc $78b9
; 5039 d1 8d    cmp ($8d),y
; 503b 30 91    bmi $4fce
; 503d bb       ???
; 503e 5a       ???
; 503f 26 b1    rol $b1
; 5041 a4 7a    ldy $7a
; 5043 bb       ???
; 5044 59 c3 ca eor $cac3,y
; 5047 2e 89 8f rol $8f89
; 504a 29 88    and #$88
; 504c bb       ???
; 504d 5d 2f 17 eor $172f,x
; 5050 b4 2a    ldy $2a,x
; 5052 bb       ???
; 5053 eb       ???
; 5054 aa       tax 
; 5055 15 2d    ora $2d,x
; 5057 cd c2 b1 cmp $b1c2
; 505a 5f       ???
; 505b 59 b1 1a eor $1ab1,y
; 505e 7b       ???
; 505f 5b       ???
; 5060 5b       ???
; 5061 93       ???
; 5062 d0 b4    bne $5018
; 5064 7b       ???
; 5065 f2       ???
; 5066 3b       ???
; 5067 08       php 
; 5068 5d 2f 17 eor $172f,x
; 506b 0f       ???
; 506c 85 96    sta $96
; 506e 35 c3    and $c3,x
; 5070 24 17    bit $17
; 5072 41 18    eor ($18,x)
; 5074 93       ???
; 5075 2e 24 19 rol $1924
; 5078 9b       ???
; 5079 58       cli 
; 507a 08       php 
; 507b f9 6e c9 sbc $c96e,y
; 507e 28       plp 
; 507f 36 31    rol $31,x
; 5081 17       ???
; 5082 7b       ???
; 5083 8f       ???
; 5084 29 22    and #$22
; 5086 88       dey 
; 5087 5b       ???
; 5088 e9 7c    sbc #$7c
; 508a 8d 1a 08 sta $081a
; 508d 7b       ???
; 508e 05 91    ora $91
; 5090 7a       ???
; 5091 1e 1e 8a asl $8a1e,x
; 5094 25 24    and $24
; 5096 19 7e 7b ora $7b7e,y
; 5099 0b       ???
; 509a 1d d4 35 ora $35d4,x
; 509d 88       dey 
; 509e bb       ???
; 509f 21 2f    and ($2f,x)
; 50a1 d1 27    cmp ($27),y
; 50a3 85 85    sta $85
; 50a5 20 cb bd jsr $bdcb
; 50a8 7b       ???
; 50a9 2b       ???
; 50aa b4 79    ldy $79,x
; 50ac f0 bb    beq $5069
; 50ae 44       ???
; 50af 12       ???
; 50b0 2d 36 92 and $9236
; 50b3 3b       ???
; 50b4 c8       iny 
; 50b5 90 8e    bcc $5045
; 50b7 18       clc 
; 50b8 c2       ???
; 50b9 34       ???
; 50ba ff       ???
; 50bb 96 35    stx $35,y
; 50bd 1a       ???
; 50be 7b       ???
; 50bf 8b       ???
; 50c0 33       ???
; 50c1 c7       ???
; 50c2 b8       clv 
; 50c3 bb       ???
; 50c4 46 29    lsr $29
; 50c6 93       ???
; 50c7 7c       ???
; 50c8 8c 2d 26 sty $262d
; 50cb 12       ???
; 50cc 7b       ???
; 50cd 30 cb    bmi $509a
; 50cf 89       ???
; 50d0 1c       ???
; 50d1 bb       ???
; 50d2 29 21    and #$21
; 50d4 85 88    sta $88
; 50d6 bb       ???
; 50d7 31 8e    and ($8e),y
; 50d9 09 06    ora #$06
; 50db 23       ???
; 50dc 96 7c    stx $7c,y
; 50de 23       ???
; 50df 2e 2f 22 rol $222f
; 50e2 a1 62    lda ($62,x)
; 50e4 e3       ???
; 50e5 37       ???
; 50e6 32       ???
; 50e7 2c 89 7b bit $7b89
; 50ea 12       ???
; 50eb 12       ???
; 50ec 07       ???
; 50ed 15 2c    ora $2c,x
; 50ef 91 8f    sta ($8f),y
; 50f1 29 88    and #$88
; 50f3 2c cd a5 bit $a5cd
; 50f6 04       ???
; 50f7 91 1c    sta ($1c),y
; 50f9 07       ???
; 50fa 18       clc 
; 50fb b6 46    ldx $46,y
; 50fd a7       ???
; 50fe 9f       ???
; 50ff ea       nop 
; 5100 ad a8 68 lda $68a8
; 5103 78       sei 
; 5104 d1 96    cmp ($96),y
; 5106 35 c3    and $c3,x
; 5108 24 8f    bit $8f
; 510a 2d 18 19 and $1918
; 510d bd 3a 57 lda $573a,x
; 5110 d7       ???
; 5111 25 23    and $23
; 5113 b2       ???
; 5114 5f       ???
; 5115 35 7e    and $7e,x
; 5117 b5 c7    lda $c7,x
; 5119 1d 7b 88 ora $887b,x
; 511c bb       ???
; 511d 21 2c    and ($2c,x)
; 511f c7       ???
; 5120 30 23    bmi $5145
; 5122 7c       ???
; 5123 bb       ???
; 5124 63       ???
; 5125 3d cb 24 and $24cb,x
; 5128 bb       ???
; 5129 44       ???
; 512a aa       tax 
; 512b c5 2e    cmp $2e
; 512d 17       ???
; 512e 9f       ???
; 512f 5f       ???
; 5130 64       ???
; 5131 2a       rol a
; 5132 3c       ???
; 5133 b6 7b    ldx $7b,y
; 5135 93       ???
; 5136 d0 b4    bne $50ec
; 5138 77       ???
; 5139 77       ???
; 513a 12       ???
; 513b 82       ???
; 513c 1d 24 87 ora $8724,x
; 513f 28       plp 
; 5140 1b       ???
; 5141 7a       ???
; 5142 33       ???
; 5143 d6 2c    dec $2c,x
; 5145 c7       ???
; 5146 49 a9    eor #$a9
; 5148 17       ???
; 5149 05 7a    ora $7a
; 514b 2b       ???
; 514c b7       ???
; 514d 7a       ???
; 514e 77       ???
; 514f 1f       ???
; 5150 c1 3d    cmp ($3d,x)
; 5152 b9 2f 88 lda $882f,y
; 5155 bb       ???
; 5156 62       ???
; 5157 95 7a    sta $7a,x
; 5159 b2       ???
; 515a c8       iny 
; 515b 1d 1e a6 ora $a61e,x
; 515e 03       ???
; 515f 3b       ???
; 5160 cb       ???
; 5161 b5 c7    lda $c7,x
; 5163 1d a2 2c ora $2ca2,x
; 5166 93       ???
; 5167 7c       ???
; 5168 8c 2b a3 sty $a32b
; 516b 04       ???
; 516c ff       ???
; 516d ff       ???
; 516e bb       ???
; 516f 01 62    ora ($62,x)
; 5171 54       ???
; 5172 26 2c    rol $2c
; 5174 c7       ???
; 5175 20 7e 8b jsr $8b7e
; 5178 36 92    rol $92,x
; 517a 1e aa a6 asl $a6aa,x
; 517d 61 c5    adc ($c5,x)
; 517f 0a       asl a
; 5180 7a       ???
; 5181 3b       ???
; 5182 c7       ???
; 5183 08       php 
; 5184 ad ac 1e lda $1eac
; 5187 38       sec 
; 5188 22       ???
; 5189 08       php 
; 518a 22       ???
; 518b a6 01    ldx $01
; 518d f0 bb    beq $514a
; 518f 62       ???
; 5190 95 90    sta $90,x
; 5192 2b       ???
; 5193 bd 32 1f lda $1f32,x
; 5196 36 56    rol $56,x
; 5198 d4       ???
; 5199 2e 89 3b rol $3b89
; 519c c9 07    cmp #$07
; 519e 1b       ???
; 519f b4 7f    ldy $7f,x
; 51a1 54       ???
; 51a2 15 1c    ora $1c,x
; 51a4 89       ???
; 51a5 c4 c6    cpy $c6
; 51a7 17       ???
; 51a8 ae 46 5f ldx $5f46
; 51ab cb       ???
; 51ac b5 c7    lda $c7,x
; 51ae 1d 7b 8d ora $8d7b,x
; 51b1 bb       ???
; 51b2 1c       ???
; 51b3 79 1b 37 adc $371b,y
; 51b6 25 09    and $09
; 51b8 1d a8 04 ora $04a8,x
; 51bb 8b       ???
; 51bc 2c 2b a6 bit $a62b
; 51bf 93       ???
; 51c0 1e d3 5c asl $5cd3,x
; 51c3 1e 3a c6 asl $c63a,x
; 51c6 08       php 
; 51c7 ad ac 1e lda $1eac
; 51ca 38       sec 
; 51cb 22       ???
; 51cc 08       php 
; 51cd 22       ???
; 51ce a6 23    ldx $23
; 51d0 fa       ???
; 51d1 43       ???
; 51d2 5b       ???
; 51d3 77       ???
; 51d4 8b       ???
; 51d5 a6 92    ldx $92
; 51d7 17       ???
; 51d8 17       ???
; 51d9 7e 1d 34 ror $341d,x
; 51dc 31 ae    and ($ae),y
; 51de 12       ???
; 51df ee ee ee inc $eeee
; 51e2 bb       ???
; 51e3 54       ???
; 51e4 28       plp 
; 51e5 30 2b    bmi $5212
; 51e7 8a       txa 
; 51e8 92       ???
; 51e9 1d 16 30 ora $3016,x
; 51ec 93       ???
; 51ed 44       ???
; 51ee 50 d2    bvc $51c2
; 51f0 a6 a5    ldx $a5
; 51f2 ac a8 a9 ldy $a9a8
; 51f5 b8       clv 
; 51f6 b3       ???
; 51f7 9e       ???
; 51f8 44       ???
; 51f9 12       ???
; 51fa 2d 36 92 and $9236
; 51fd 8a       txa 
; 51fe 9b       ???
; 51ff 9a       txs 
; 5200 89       ???
; 5201 44       ???
; 5202 68       pla 
; 5203 7f       ???
; 5204 5b       ???
; 5205 96 35    stx $35,y
; 5207 c3       ???
; 5208 24 04    bit $04
; 520a 92       ???
; 520b 06 94    asl $94
; 520d 95 06    sta $06,x
; 520f 7b       ???
; 5210 77       ???
; 5211 12       ???
; 5212 2d 36 00 and $0036
; 5215 e5 12    sbc $12
; 5217 89       ???
; 5218 7b       ???
; 5219 23       ???
; 521a d2       ???
; 521b ce 92 1c dec $1c92
; 521e bf       ???
; 521f 2c 2c 2f bit $2f2c
; 5222 b8       clv 
; 5223 3e 9b 12 rol $129b,x
; 5226 89       ???
; 5227 8a       txa 
; 5228 31 31    and ($31),y
; 522a 8a       txa 
; 522b 2b       ???
; 522c b7       ???
; 522d 7a       ???
; 522e 89       ???
; 522f 21 16    and ($16,x)
; 5231 19 26 17 ora $1726,y
; 5234 7a       ???
; 5235 3b       ???
; 5236 08       php 
; 5237 f9 6e c9 sbc $c96e,y
; 523a 28       plp 
; 523b 36 31    rol $31,x
; 523d 17       ???
; 523e a2 af    ldx #$af
; 5240 b8       clv 
; 5241 ba       tsx 
; 5242 8a       txa 
; 5243 05 91    ora $91
; 5245 7a       ???
; 5246 8d 2b a3 sta $a32b
; 5249 91 7a    sta ($7a),y
; 524b 5b       ???
; 524c 7f       ???
; 524d ac bb 21 ldy $21bb
; 5250 3b       ???
; 5251 de 32 32 dec $3232,x
; 5254 bb       ???
; 5255 a4 7a    ldy $7a
; 5257 7e b9 c8 ror $c8b9,x
; 525a a3       ???
; 525b 04       ???
; 525c 8d 2a d2 sta $d22a
; 525f c5 0a    cmp $0a
; 5261 7a       ???
; 5262 3a       ???
; 5263 07       ???
; 5264 5d 2f 17 eor $172f,x
; 5267 0f       ???
; 5268 85 c8    sta $c8
; 526a 76 77    ror $77,x
; 526c c9 8d    cmp #$8d
; 526e 1a       ???
; 526f 7b       ???
; 5270 7e 1d 24 ror $241d,x
; 5273 28       plp 
; 5274 bb       ???
; 5275 a4 86    ldy $86
; 5277 d2       ???
; 5278 a6 6d    ldx $6d
; 527a bb       ???
; 527b 1c       ???
; 527c 5b       ???
; 527d 5b       ???
; 527e 7b       ???
; 527f 06 a7    asl $a7
; 5281 0d bf 5b ora $5bbf
; 5284 23       ???
; 5285 c4 a5    cpy $a5
; 5287 57       ???
; 5288 f7       ???
; 5289 b6 9f    ldx $9f,y
; 528b e0 6c    cpx #$6c
; 528d 33       ???
; 528e 22       ???
; 528f 8c df 5b sty $5bdf
; 5292 1d 2f 32 ora $322f,x
; 5295 2e 69 57 rol $5769
; 5298 18       clc 
; 5299 33       ???
; 529a 2c 68 09 bit $0968
; 529d ca       dex 
; 529e 1f       ???
; 529f c0 cc    cpy #$cc
; 52a1 6a       ror a
; 52a2 6b       ???
; 52a3 b6 f9    ldx $f9,y
; 52a5 71 a2    adc ($a2),y
; 52a7 a4 2e    ldy $2e
; 52a9 20 65 67 jsr $6765
; 52ac 28       plp 
; 52ad ba       tsx 
; 52ae f9 68 2f sbc $2f68,y
; 52b1 22       ???
; 52b2 23       ???
; 52b3 76 94    ror $94,x
; 52b5 b4 b5    ldy $b5,x
; 52b7 95 9d    sta $9d,x
; 52b9 bd a6 a6 lda $a6a6,x
; 52bc a3       ???
; 52bd 83       ???
; 52be 4f       ???
; 52bf 34       ???
; 52c0 b3       ???
; 52c1 a5 a5    lda $a5
; 52c3 a3       ???
; 52c4 83       ???
; 52c5 82       ???
; 52c6 a2 a1    ldx #$a1
; 52c8 81 94    sta ($94,x)
; 52ca b4 b5    ldy $b5,x
; 52cc 95 71    sta $71,x
; 52ce 2c b4 f9 bit $f9b4
; 52d1 6b       ???
; 52d2 16 05    asl $05,x
; 52d4 1e a5 e1 asl $e1a5,x
; 52d7 e0 9b    cpx #$9b
; 52d9 28       plp 
; 52da 32       ???
; 52db 73       ???
; 52dc 6c 17 07 jmp ($0717)
; 52df 15 b3    ora $b3,x
; 52e1 a7       ???
; 52e2 5b       ???
; 52e3 13       ???
; 52e4 be 09 5e ldx $5e09,y
; 52e7 75 dc    adc $dc,x
; 52e9 15 71    ora $71,x
; 52eb 1c       ???
; 52ec 15 6a    ora $6a,x
; 52ee 64       ???
; 52ef b0 bb    bcs $52ac
; 52f1 92       ???
; 52f2 be 54 67 ldx $6754,y
; 52f5 58       cli 
; 52f6 17       ???
; 52f7 2a       rol a
; 52f8 16 04    asl $04,x
; 52fa 1c       ???
; 52fb 71 9d    adc ($9d),y
; 52fd bd 79 1d lda $1d79,x
; 5300 1e b2 06 asl $06b2,x
; 5303 76 37    ror $37,x
; 5305 2c 30 2e bit $2e30
; 5308 20 65 6b jsr $6b65
; 530b 19 23 32 ora $3223,y
; 530e 30 a6    bmi $52b6
; 5310 e1 73    sbc ($73,x)
; 5312 d5 5b    cmp $5b,x
; 5314 b4 69    ldy $69,x
; 5316 5e 1f cf lsr $cf1f,x
; 5319 0e 5a a4 asl $a45a
; 531c ba       tsx 
; 531d 37       ???
; 531e 22       ???
; 531f 5b       ???
; 5320 b2       ???
; 5321 a4 c0    ldy $c0
; 5323 1a       ???
; 5324 a8       tay 
; 5325 af       ???
; 5326 01 2a    ora ($2a,x)
; 5328 69 ba    adc #$ba
; 532a 40       rti 
; 532b 19 4c 84 ora $844c,y
; 532e ab       ???
; 532f da       ???
; 5330 84 64    sty $64
; 5332 e8       inx 
; 5333 80       ???
; 5334 46 7a    lsr $7a
; 5336 b2       ???
; 5337 a5 6e    lda $6e
; 5339 85 da    sta $da
; 533b 78       sei 
; 533c bd 6a 26 lda $266a,x
; 533f ea       nop 
; 5340 2a       rol a
; 5341 81 80    sta ($80,x)
; 5343 00       brk 
; 5344 00       brk 
; 5345 01 02    ora ($02,x)
; 5347 02       ???
; 5348 02       ???
; 5349 83       ???
; 534a 83       ???
; 534b 02       ???
; 534c 02       ???
; 534d 02       ???
; 534e 02       ???
; 534f 02       ???
; 5350 02       ???
; 5351 02       ???
; 5352 02       ???
; 5353 02       ???
; 5354 02       ???
; 5355 02       ???
; 5356 02       ???
; 5357 03       ???
; 5358 03       ???
; 5359 83       ???
; 535a 12       ???
; 535b e7       ???
; 535c 1b       ???
; 535d d8       cld 
; 535e 2c cf d0 bit $d0cf
; 5361 37       ???
; 5362 a7       ???
; 5363 8d 7b 96 sta $967b
; 5366 31 b7    and ($b7),y
; 5368 1c       ???
; 5369 96 35    stx $35,y
; 536b c3       ???
; 536c 24 78    bit $78
; 536e 1f       ???
; 536f 36 33    rol $33,x
; 5371 bd 4d 00 lda $004d,x
; 5374 cc 1e aa cpy $aa1e
; 5377 a6 b3    ldx $b3
; 5379 c3       ???
; 537a c9 2a    cmp #$2a
; 537c c0 c0    cpy #$c0
; 537e 8b       ???
; 537f 8b       ???
; 5380 cb       ???
; 5381 d0 ad    bne $5330
; 5383 9b       ???
; 5384 0c       ???
; 5385 1d 1b 1b ora $1b1b,x
; 5388 2c 2c 33 bit $332c
; 538b 75 3f    adc $3f,x
; 538d e9 23    sbc #$23
; 538f ad a9 2e lda $2ea9
; 5392 8a       txa 
; 5393 17       ???
; 5394 17       ???
; 5395 8d 17 19 sta $1917
; 5398 36 31    rol $31,x
; 539a be 02 1b ldx $1b02,y
; 539d d8       cld 
; 539e 9c       ???
; 539f 11 8e    ora ($8e),y
; 53a1 23       ???
; 53a2 32       ???
; 53a3 17       ???
; 53a4 ad 21 13 lda $1321
; 53a7 41 5f    eor ($5f,x)
; 53a9 60       rts 
; 53aa 64       ???
; 53ab 39 f2 44 and $44f2,y
; 53ae 24 6d    bit $6d
; 53b0 8d 9c 9c sta $9c9c
; 53b3 2e cf 34 rol $34cf
; 53b6 b0 2c    bcs $53e4
; 53b8 0f       ???
; 53b9 29 c3    and #$c3
; 53bb 14       ???
; 53bc 7a       ???
; 53bd 96 31    stx $31,y
; 53bf b7       ???
; 53c0 2c 87 1f bit $1f87
; 53c3 3d d0 29 and $29d0,x
; 53c6 8c 2b 2a sty $2a2b
; 53c9 30 95    bmi $5360
; 53cb f0 92    beq $535f
; 53cd 33       ???
; 53ce 30 34    bmi $5404
; 53d0 af       ???
; 53d1 a8       tay 
; 53d2 a3       ???
; 53d3 a7       ???
; 53d4 2c 8a 88 bit $888a
; 53d7 bb       ???
; 53d8 21 30    and ($30,x)
; 53da cb       ???
; 53db c3       ???
; 53dc 08       php 
; 53dd 65 20    adc $20
; 53df 19 82 02 ora $0282,y
; 53e2 ac aa 1d ldy $1daa
; 53e5 0f       ???
; 53e6 96 35    stx $35,y
; 53e8 29 9a    and #$9a
; 53ea 97       ???
; 53eb c3       ???
; 53ec c9 2a    cmp #$2a
; 53ee c0 c0    cpy #$c0
; 53f0 8b       ???
; 53f1 96 2d    stx $2d,y
; 53f3 15 aa    ora $aa,x
; 53f5 b6 18    ldx $18,y
; 53f7 23       ???
; 53f8 cb       ???
; 53f9 24 88    bit $88
; 53fb 9d 8f 96 sta $968f,x
; 53fe b2       ???
; 53ff 31 b7    and ($b7),y
; 5401 1e f0 32 asl $32f0,x
; 5404 4e 1f 03 lsr $031f
; 5407 7a       ???
; 5408 1b       ???
; 5409 30 6f    bmi $547a
; 540b 1a       ???
; 540c 3a       ???
; 540d 9c       ???
; 540e 9c       ???
; 540f 0f       ???
; 5410 0f       ???
; 5411 8a       txa 
; 5412 25 31    and $31
; 5414 2d 15 9a and $9a15
; 5417 b2       ???
; 5418 31 b7    and ($b7),y
; 541a 1c       ???
; 541b 88       dey 
; 541c 16 1d    asl $1d,x
; 541e 32       ???
; 541f 91 2b    sta ($2b),y
; 5421 b4 1f    ldy $1f,x
; 5423 31 b7    and ($b7),y
; 5425 20 f2 7b jsr $7bf2
; 5428 06 1b    asl $1b
; 542a 90 7b    bcc $54a7
; 542c 20 3a 38 jsr $383a
; 542f 34       ???
; 5430 c5 90    cmp $90
; 5432 02       ???
; 5433 1f       ???
; 5434 1c       ???
; 5435 21 b2    and ($b2,x)
; 5437 24 f0    bit $f0
; 5439 95 95    sta $95,x
; 543b 96 31    stx $31,y
; 543d cb       ???
; 543e 30 03    bmi $5443
; 5440 03       ???
; 5441 77       ???
; 5442 a1 a4    lda ($a4,x)
; 5444 a1 45    lda ($45,x)
; 5446 64       ???
; 5447 5d f7 7b eor $7bf7,x
; 544a 9b       ???
; 544b 0f       ???
; 544c 0f       ???
; 544d 77       ???
; 544e a1 a4    lda ($a4,x)
; 5450 7a       ???
; 5451 88       dey 
; 5452 bb       ???
; 5453 21 91    and ($91,x)
; 5455 2c 89 19 bit $1989
; 5458 19 8d d1 ora $d18d,y
; 545b 74       ???
; 545c 32       ???
; 545d f0 91    beq $53f0
; 545f 28       plp 
; 5460 85 25    sta $25
; 5462 b2       ???
; 5463 a7       ???
; 5464 a7       ???
; 5465 7b       ???
; 5466 8a       txa 
; 5467 31 31    and ($31),y
; 5469 2c 89 73 bit $7389
; 546c 7a       ???
; 546d 89       ???
; 546e 13       ???
; 546f a2 18    ldx #$18
; 5471 7b       ???
; 5472 18       clc 
; 5473 c3       ???
; 5474 b2       ???
; 5475 17       ???
; 5476 33       ???
; 5477 96 3b    stx $3b,y
; 5479 e8       inx 
; 547a 7b       ???
; 547b 6f       ???
; 547c 37       ???
; 547d 96 8a    stx $8a,y
; 547f 25 cb    and $cb
; 5481 30 91    bmi $5414
; 5483 2c 89 85 bit $8589
; 5486 c8       iny 
; 5487 33       ???
; 5488 00       brk 
; 5489 98       tya 
; 548a 16 23    asl $23,x
; 548c 2e 2f 22 rol $222f
; 548f 14       ???
; 5490 13       ???
; 5491 1d 92 7c ora $7c92,x
; 5494 1d 28 12 ora $1228,x
; 5497 14       ???
; 5498 89       ???
; 5499 77       ???
; 549a 1e d3 2c asl $2cd3,x
; 549d 77       ???
; 549e 1f       ???
; 549f c1 19    cmp ($19,x)
; 54a1 95 95    sta $95,x
; 54a3 17       ???
; 54a4 bb       ???
; 54a5 39 30 bf and $bf30,y
; 54a8 24 5b    bit $5b
; 54aa 5b       ???
; 54ab 7e 19 2a ror $2a19,x
; 54ae 1f       ???
; 54af b9 29 8b lda $8b29,y
; 54b2 c7       ???
; 54b3 ce a2 39 dec $39a2
; 54b6 c8       iny 
; 54b7 29 8a    and #$8a
; 54b9 7e 1f a1 ror $a11f,x
; 54bc 2c c1 c8 bit $c8c1
; 54bf 21 7b    and ($7b,x)
; 54c1 23       ???
; 54c2 37       ???
; 54c3 1b       ???
; 54c4 7a       ???
; 54c5 79 09 7e adc $7e09,y
; 54c8 2e ba 07 rol $07ba
; 54cb 7b       ???
; 54cc 8f       ???
; 54cd 29 88    and #$88
; 54cf 2c cd a5 bit $a5cd
; 54d2 04       ???
; 54d3 17       ???
; 54d4 b6 9f    ldx $9f,y
; 54d6 a4 29    ldy $29
; 54d8 85 7e    sta $7e
; 54da 25 cd    and $cd
; 54dc b2       ???
; 54dd bd 9f e5 lda $e59f,x
; 54e0 a1 a4    lda ($a4,x)
; 54e2 a1 59    lda ($59,x)
; 54e4 6d b7 23 adc $23b7
; 54e7 75 3b    adc $3b,x
; 54e9 5b       ???
; 54ea 8b       ???
; 54eb bc 1f 7a ldy $7a1f,x
; 54ee 19 2a 30 ora $302a,y
; 54f1 ce 29 3b dec $3b29
; 54f4 03       ???
; 54f5 b6 9b    ldx $9b,y
; 54f7 9b       ???
; 54f8 95 2f    sta $2f,x
; 54fa 88       dey 
; 54fb 5b       ???
; 54fc 5b       ???
; 54fd 92       ???
; 54fe 39 3a 2e and $2e3a,y
; 5501 8b       ???
; 5502 f0 96    beq $549a
; 5504 31 82    and ($82),y
; 5506 74       ???
; 5507 7b       ???
; 5508 19 19 21 ora $2119,y
; 550b 63       ???
; 550c 68       pla 
; 550d 06 ad    asl $ad
; 550f 6a       ror a
; 5510 2c 32 ae bit $ae32
; 5513 50 44    bvc $5559
; 5515 f5 e4    sbc $e4,x
; 5517 89       ???
; 5518 2d a7 9e and $9ea7
; 551b 89       ???
; 551c 95 3c    sta $3c,x
; 551e 75 7a    adc $7a,x
; 5520 7a       ???
; 5521 7a       ???
; 5522 7a       ???
; 5523 7a       ???
; 5524 7a       ???
; 5525 7a       ???
; 5526 7a       ???
; 5527 7a       ???
; 5528 7a       ???
; 5529 7a       ???
; 552a 7a       ???
; 552b 7a       ???
; 552c 7a       ???
; 552d 7a       ???
; 552e 7a       ???
; 552f 7a       ???
; 5530 7a       ???
; 5531 7a       ???
; 5532 7a       ???
; 5533 7a       ???
; 5534 7a       ???
; 5535 7a       ???
; 5536 7a       ???
; 5537 7a       ???
; 5538 7a       ???
; 5539 6c 2d 26 jmp ($262d)
; 553c 85 8d    sta $8d
; 553e bb       ???
; 553f 1c       ???
; 5540 5b       ???
; 5541 5b       ???
; 5542 1e 1e 3b asl $3b1e,x
; 5545 c4 05    cpy $05
; 5547 8d 98 87 sta $8798
; 554a 87       ???
; 554b c3       ???
; 554c c9 25    cmp #$25
; 554e 1d 84 cd ora $cd84,x
; 5551 0c       ???
; 5552 58       cli 
; 5553 b5 82    lda $82,x
; 5555 74       ???
; 5556 8b       ???
; 5557 2c 58 2a bit $2a58
; 555a 9b       ???
; 555b 9b       ???
; 555c 7e 25 cd ror $cd25,x
; 555f b2       ???
; 5560 15 89    ora $89,x
; 5562 05 91    ora $91
; 5564 7a       ???
; 5565 2c 58 b5 bit $b558
; 5568 69 1b    adc #$1b
; 556a 5a       ???
; 556b 9a       txs 
; 556c 7b       ???
; 556d 8f       ???
; 556e 29 88    and #$88
; 5570 b1 b1    lda ($b1),y
; 5572 8d bb 1c sta $1cbb
; 5575 33       ???
; 5576 33       ???
; 5577 8d ce c5 sta $c5ce
; 557a b4 b7    ldy $b7,x
; 557c 2b       ???
; 557d 29 85    and #$85
; 557f 7e 0c 23 ror $230c,x
; 5582 38       sec 
; 5583 38       sec 
; 5584 ca       dex 
; 5585 59 24 2c eor $2c24,y
; 5588 57       ???
; 5589 19 2c c7 ora $c72c,y
; 558c 20 85 00 jsr $0085
; 558f 14       ???
; 5590 a6 92    ldx $92
; 5592 2c 5c c3 bit $c35c
; 5595 93       ???
; 5596 bb       ???
; 5597 c1 fa    cmp ($fa,x)
; 5599 fa       ???
; 559a fa       ???
; 559b fa       ???
; 559c f4       ???
; 559d f4       ???
; 559e fa       ???
; 559f fa       ???
; 55a0 fa       ???
; 55a1 fa       ???
; 55a2 fa       ???
; 55a3 1a       ???
; 55a4 14       ???
; 55a5 db       ???
; 55a6 77       ???
; 55a7 6a       ror a
; 55a8 ad 56 12 lda $1256
; 55ab 2d 2f 2c and $2c2f
; 55ae 32       ???
; 55af 2c 89 7a bit $7a89
; 55b2 1b       ???
; 55b3 8f       ???
; 55b4 7a       ???
; 55b5 22       ???
; 55b6 31 89    and ($89),y
; 55b8 7b       ???
; 55b9 16 13    asl $13,x
; 55bb 13       ???
; 55bc 2b       ???
; 55bd 1c       ???
; 55be 15 24    ora $24,x
; 55c0 2b       ???
; 55c1 1c       ???
; 55c2 22       ???
; 55c3 96 87    stx $87,y
; 55c5 26 31    rol $31
; 55c7 31 25    and ($25),y
; 55c9 1d 84 cd ora $cd84,x
; 55cc 91 86    sta ($86),y
; 55ce 90 85    bcc $5555
; 55d0 99 b0 89 sta $89b0,y
; 55d3 5c       ???
; 55d4 5c       ???
; 55d5 6b       ???
; 55d6 7b       ???
; 55d7 85 87    sta $87
; 55d9 66 53    ror $53
; 55db 6a       ror a
; 55dc 8d a7 95 sta $95a7
; 55df 99 b0 89 sta $89b0,y
; 55e2 66 60    ror $60
; 55e4 5c       ???
; 55e5 6b       ???
; 55e6 84 97    sty $97
; 55e8 9d 9c 98 sta $989c,x
; 55eb 81 68    sta ($68,x)
; 55ed 40       rti 
; 55ee 2e 9b b7 rol $b79b
; 55f1 6b       ???
; 55f2 7a       ???
; 55f3 98       tya 
; 55f4 81 67    sta ($67,x)
; 55f6 52       ???
; 55f7 6c 90 85 jmp ($8590)
; 55fa 99 b0 89 sta $89b0,y
; 55fd 6b       ???
; 55fe 8d f8 75 sta $75f8
; 5601 73       ???
; 5602 74       ???
; 5603 90 91    bcc $5596
; 5605 e5 e6    sbc $e6
; 5607 26 26    rol $26
; 5609 ce ce 70 dec $70ce
; 560c 71 47    adc ($47),y
; 560e 48       pha 
; 560f 84 84    sty $84
; 5611 b6 b7    ldx $b7,y
; 5613 99 9b 23 sta $239b,y
; 5616 25 17    and $17
; 5618 18       clc 
; 5619 0e 0f 11 asl $110f
; 561c 12       ???
; 561d e8       inx 
; 561e e9 c3    sbc #$c3
; 5620 c3       ???
; 5621 6b       ???
; 5622 6c 9a 9b jmp ($9b9a)
; 5625 81 82    sta ($82,x)
; 5627 b2       ???
; 5628 b3       ???
; 5629 77       ???
; 562a 78       sei 
; 562b 3e 3f ef rol $ef3f,x
; 562e f0 78    beq $56a8
; 5630 79 a3 a4 adc $a4a3,y
; 5633 96 97    stx $97,y
; 5635 b1 b2    lda ($b2),y
; 5637 8a       txa 
; 5638 8b       ???
; 5639 a7       ???
; 563a a8       tay 
; 563b 14       ???
; 563c 15 17    ora $17,x
; 563e 18       clc 
; 563f 1a       ???
; 5640 1b       ???
; 5641 ee 00 01 inc $0100
; 5644 01 00    ora ($00,x)
; 5646 00       brk 
; 5647 00       brk 
; 5648 00       brk 
; 5649 21 82    and ($82,x)
; 564b 01 40    ora ($40,x)
; 564d 40       rti 
; 564e 41 42    eor ($42,x)
; 5650 63       ???
; 5651 ce 98 18 dec $1898
; 5654 18       clc 
; 5655 98       tya 
; 5656 98       tya 
; 5657 91 91    sta ($91),y
; 5659 18       clc 
; 565a 18       clc 
; 565b 0e 8e 18 asl $188e
; 565e 10 08    bpl $5668
; 5660 24 20    bit $20
; 5662 95 95    sta $95,x
; 5664 10 1a    bpl $5680
; 5666 14       ???
; 5667 10 0e    bpl $5677
; 5669 12       ???
; 566a 1a       ???
; 566b 21 fb    and ($fb,x)
; 566d 94 7f    sty $7f,x
; 566f d5 55    cmp $55,x
; 5671 6f       ???
; 5672 6f       ???
; 5673 d5 d5    cmp $d5,x
; 5675 af       ???
; 5676 af       ???
; 5677 ff       ???
; 5678 dc       ???
; 5679 5c       ???
; 567a 3f       ???
; 567b 3f       ???
; 567c 6a       ror a
; 567d 00       brk 
; 567e 6a       ror a
; 567f cb       ???
; 5680 76 aa    ror $aa,x
; 5682 55 00    eor $00,x
; 5684 00       brk 
; 5685 00       brk 
; 5686 00       brk 
; 5687 00       brk 
; 5688 00       brk 
; 5689 00       brk 
; 568a 00       brk 
; 568b 00       brk 
; 568c 00       brk 
; 568d 00       brk 
; 568e 00       brk 
; 568f 00       brk 
; 5690 01 01    ora ($01,x)
; 5692 00       brk 
; 5693 00       brk 
; 5694 00       brk 
; 5695 00       brk 
; 5696 00       brk 
; 5697 00       brk 
; 5698 00       brk 
; 5699 00       brk 
; 569a 01 02    ora ($02,x)
; 569c 02       ???
; 569d 02       ???
; 569e 01 02    ora ($02,x)
; 56a0 02       ???
; 56a1 05 0a    ora $0a
; 56a3 05 00    ora $00
; 56a5 40       rti 
; 56a6 46 80    lsr $80
; 56a8 54       ???
; 56a9 2f       ???
; 56aa 55 0a    eor $0a,x
; 56ac 70 7e    bvs $572c
; 56ae 18       clc 
; 56af 00       brk 
; 56b0 24 32    bit $32
; 56b2 10 2e    bpl $56e2
; 56b4 2c 00 02 bit $0200
; 56b7 02       ???
; 56b8 00       brk 
; 56b9 00       brk 
; 56ba 44       ???
; 56bb 63       ???
; 56bc 2f       ???
; 56bd 42       ???
; 56be 3a       ???
; 56bf 10 2c    bpl $56ed
; 56c1 83       ???
; 56c2 80       ???
; 56c3 75 5c    adc $5c,x
; 56c5 10 2c    bpl $56f3
; 56c7 43       ???
; 56c8 51 a6    eor ($a6),y
; 56ca 7c       ???
; 56cb 10 2c    bpl $56f9
; 56cd c3       ???
; 56ce cf       ???
; 56cf a6 7e    ldx $7e
; 56d1 10 2c    bpl $56ff
; 56d3 03       ???
; 56d4 ef       ???
; 56d5 75 6d    adc $6d,x
; 56d7 10 34    bpl $570d
; 56d9 6b       ???
; 56da b3       ???
; 56db fc       ???
; 56dc 90 10    bcc $56ee
; 56de 34       ???
; 56df ab       ???
; 56e0 d3       ???
; 56e1 dc       ???
; 56e2 90 10    bcc $56f4
; 56e4 34       ???
; 56e5 2b       ???
; 56e6 64       ???
; 56e7 ed 90 10 sbc $1090
; 56ea 34       ???
; 56eb eb       ???
; 56ec 35 fe    and $fe,x
; 56ee 94 18    sty $18,x
; 56f0 38       sec 
; 56f1 54       ???
; 56f2 9c       ???
; 56f3 fc       ???
; 56f4 94 18    sty $18,x
; 56f6 38       sec 
; 56f7 94 bc    sty $bc,x
; 56f9 dc       ???
; 56fa 94 18    sty $18,x
; 56fc 38       sec 
; 56fd 14       ???
; 56fe 4d ed 94 eor $94ed
; 5701 18       clc 
; 5702 38       sec 
; 5703 d4       ???
; 5704 1e fe 90 asl $90fe,x
; 5707 10 14    bpl $571d
; 5709 b4 1e    ldy $1e,x
; 570b ed 7f 10 sbc $107f
; 570e 14       ???
; 570f f4       ???
; 5710 4d cb 6e eor $6ecb
; 5713 10 14    bpl $5729
; 5715 34       ???
; 5716 9c       ???
; 5717 eb       ???
; 5718 7f       ???
; 5719 10 14    bpl $572f
; 571b 74       ???
; 571c bc a9 74 ldy $74a9,x
; 571f 40       rti 
; 5720 21 04    and ($04,x)
; 5722 23       ???
; 5723 51 32    eor ($32),y
; 5725 08       php 
; 5726 27       ???
; 5727 4f       ???
; 5728 30 0c    bmi $5736
; 572a 2b       ???
; 572b 2f       ???
; 572c 10 10    bpl $573e
; 572e 2f       ???
; 572f 43       ???
; 5730 28       plp 
; 5731 0c       ???
; 5732 27       ???
; 5733 70 55    bvs $578a
; 5735 14       ???
; 5736 2f       ???
; 5737 7f       ???
; 5738 6c 1c 2f jmp ($2f1c)
; 573b 92       ???
; 573c 7b       ???
; 573d 14       ???
; 573e 2b       ???
; 573f 93       ???
; 5740 7c       ???
; 5741 1c       ???
; 5742 33       ???
; 5743 73       ???
; 5744 58       cli 
; 5745 1c       ???
; 5746 37       ???
; 5747 84 75    sty $75
; 5749 2c 3b 95 bit $953b
; 574c 82       ???
; 574d 2c 3f a5 bit $a53f
; 5750 a2 3c    ldx #$3c
; 5752 3f       ???
; 5753 a6 9b    ldx $9b
; 5755 34       ???
; 5756 3f       ???
; 5757 a3       ???
; 5758 98       tya 
; 5759 2c 37 a4 bit $a437
; 575c 9d 34 24 sta $2434,x
; 575f 8d 9d 40 sta $409d
; 5762 30 8f    bmi $56f3
; 5764 9b       ???
; 5765 38       sec 
; 5766 2c 8f a7 bit $a78f
; 5769 50 38    bvc $57a3
; 576b 8d a1 48 sta $48a1
; 576e 34       ???
; 576f 7c       ???
; 5770 98       tya 
; 5771 60       rts 
; 5772 44       ???
; 5773 5c       ???
; 5774 7c       ???
; 5775 68       pla 
; 5776 48       pha 
; 5777 7e a6 64 ror $64a6,x
; 577a 3c       ???
; 577b 6d 91 64 adc $6491
; 577e d7       ???
; 577f df       ???
; 5780 40       rti 
; 5781 10 6f    bpl $57f2
; 5783 5f       ???
; 5784 40       rti 
; 5785 50 2f    bvc $57b6
; 5787 5f       ???
; 5788 40       rti 
; 5789 10 2f    bpl $57ba
; 578b 1f       ???
; 578c 40       rti 
; 578d 50 2f    bvc $57be
; 578f 3f       ???
; 5790 20 00 5f jsr $5f00
; 5793 5f       ???
; 5794 20 20 9f jsr $9f20
; 5797 bf       ???
; 5798 20 00 1f jsr $1f00
; 579b 1f       ???
; 579c 20 20 3f jsr $3f20
; 579f 3f       ???
; 57a0 00       brk 
; 57a1 b0 b0    bcs $5753
; 57a3 00       brk 
; 57a4 64       ???
; 57a5 d8       cld 
; 57a6 58       cli 
; 57a7 3d 59 36 and $3659,x
; 57aa 96 7c    stx $7c,y
; 57ac 1c       ???
; 57ad 00       brk 
; 57ae 38       sec 
; 57af b0 68    bcs $5819
; 57b1 f0 00    beq $57b3
; 57b3 00       brk 
; 57b4 00       brk 
; 57b5 06 a6    asl $a6
; 57b7 a0 a0    ldy #$a0
; 57b9 bf       ???
; 57ba 2f       ???
; 57bb 72       ???
; 57bc 62       ???
; 57bd a0 40    ldy #$40
; 57bf bf       ???
; 57c0 3f       ???
; 57c1 a3       ???
; 57c2 23       ???
; 57c3 a0 a0    ldy #$a0
; 57c5 3f       ???
; 57c6 cf       ???
; 57c7 a4 74    ldy $74
; 57c9 a0 40    ldy #$40
; 57cb ff       ???
; 57cc 6f       ???
; 57cd 64       ???
; 57ce f4       ???
; 57cf 40       rti 
; 57d0 a0 5f    ldy #$5f
; 57d2 b0 f7    bcs $57cb
; 57d4 46 40    lsr $40
; 57d6 a0 1f    ldy #$1f
; 57d8 81 1a    sta ($1a,x)
; 57da 58       cli 
; 57db 40       rti 
; 57dc a0 9f    ldy #$9f
; 57de 12       ???
; 57df 3b       ???
; 57e0 68       pla 
; 57e1 40       rti 
; 57e2 a0 df    ldy #$df
; 57e4 33       ???
; 57e5 eb       ???
; 57e6 37       ???
; 57e7 a0 a0    ldy #$a0
; 57e9 df       ???
; 57ea e5 81    sbc $81
; 57ec db       ???
; 57ed a0 40    ldy #$40
; 57ef df       ???
; 57f0 f7       ???
; 57f1 94 7c    sty $7c,x
; 57f3 a0 a0    ldy #$a0
; 57f5 5f       ???
; 57f6 56 73    lsr $73,x
; 57f8 dc       ???
; 57f9 a0 40    ldy #$40
; 57fb 1f       ???
; 57fc 14       ???
; 57fd 6f       ???
; 57fe e4 28    cpx $28
; 5800 be fe 5e ldx $5efe,y
; 5803 00       brk 
; 5804 0a       asl a
; 5805 28       plp 
; 5806 be be 1e ldx $1ebe,y
; 5809 00       brk 
; 580a 0a       asl a
; 580b 28       plp 
; 580c be 3e 9e ldx $9e3e,y
; 580f 00       brk 
; 5810 0a       asl a
; 5811 28       plp 
; 5812 be 7e de ldx $de7e,y
; 5815 00       brk 
; 5816 1f       ???
; 5817 2f       ???
; 5818 10 0c    bpl $5826
; 581a 2b       ???
; 581b 3f       ???
; 581c 20 04 23 jsr $2304
; 581f 4f       ???
; 5820 34       ???
; 5821 0c       ???
; 5822 27       ???
; 5823 5f       ???
; 5824 48       pha 
; 5825 14       ???
; 5826 2b       ???
; 5827 70 5d    bvs $5886
; 5829 1c       ???
; 582a 2f       ???
; 582b 80       ???
; 582c 61 10    adc ($10,x)
; 582e 2f       ???
; 582f 81 62    sta ($62,x)
; 5831 14       ???
; 5832 33       ???
; 5833 a1 96    lda ($96,x)
; 5835 18       clc 
; 5836 23       ???
; 5837 a2 87    ldx #$87
; 5839 1c       ???
; 583a 37       ???
; 583b 92       ???
; 583c 7b       ???
; 583d 20 37 93 jsr $9337
; 5840 7c       ???
; 5841 24 3b    bit $3b
; 5843 73       ???
; 5844 60       rts 
; 5845 28       plp 
; 5846 3b       ???
; 5847 f9 fa 4c sbc $4cfa,y
; 584a 4b       ???
; 584b fa       ???
; 584c fb       ???
; 584d 44       ???
; 584e 43       ???
; 584f fb       ???
; 5850 00       brk 
; 5851 4c 47 f8 jmp $f847
; 5854 01 54    ora ($54,x)
; 5856 4b       ???
; 5857 c4 b5    cpy $b5
; 5859 3c       ???
; 585a 4b       ???
; 585b c5 b6    cmp $b6
; 585d 30 3f    bmi $589e
; 585f d5 ca    cmp $ca,x
; 5861 34       ???
; 5862 3f       ???
; 5863 d7       ???
; 5864 cc 38 43 cpy $4338
; 5867 e7       ???
; 5868 e0 3c    cpx #$3c
; 586a 43       ???
; 586b e6 df    inc $df
; 586d 40       rti 
; 586e 47       ???
; 586f b6 b3    ldx $b3,y
; 5871 44       ???
; 5872 47       ???
; 5873 b4 b1    ldy $b1,x
; 5875 48       pha 
; 5876 4a       lsr a
; 5877 1e 30 64 asl $6430,x
; 587a 52       ???
; 587b 1e 34 6c asl $6c34,x
; 587e 56 1e    lsr $1e,x
; 5880 38       sec 
; 5881 74       ???
; 5882 5a       ???
; 5883 1e 3c 6c asl $6c3c,x
; 5886 4f       ???
; 5887 1f       ???
; 5888 00       brk 
; 5889 a0 ff    ldy #$ff
; 588b ca       dex 
; 588c d6 d6    dec $d6,x
; 588e 8a       txa 
; 588f 8a       txa 
; 5890 d6 d6    dec $d6,x
; 5892 0a       asl a
; 5893 0a       asl a
; 5894 d6 d6    dec $d6,x
; 5896 4a       lsr a
; 5897 4a       lsr a
; 5898 d6 d6    dec $d6,x
; 589a ca       dex 
; 589b 5f       ???
; 589c a0 a0    ldy #$a0
; 589e 1f       ???
; 589f bf       ???
; 58a0 a0 00    ldy #$00
; 58a2 9f       ???
; 58a3 3f       ???
; 58a4 a0 00    ldy #$00
; 58a6 1f       ???
; 58a7 1f       ???
; 58a8 a0 a0    ldy #$a0
; 58aa ff       ???
; 58ab 6a       ror a
; 58ac d6 d6    dec $d6,x
; 58ae ea       nop 
; 58af ea       nop 
; 58b0 d6 d6    dec $d6,x
; 58b2 aa       tax 
; 58b3 aa       tax 
; 58b4 d6 d6    dec $d6,x
; 58b6 2a       rol a
; 58b7 2a       rol a
; 58b8 d6 d6    dec $d6,x
; 58ba aa       tax 
; 58bb 3f       ???
; 58bc 00       brk 
; 58bd a0 c0    ldy #$c0
; 58bf 20 01 2d jsr $2d01
; 58c2 70 61    bvs $5925
; 58c4 1d 16 2e ora $2e16,x
; 58c7 1e 06 00 asl $0006,x
; 58ca 10 18    bpl $58e4
; 58cc 19 19 08 ora $0819,y
; 58cf 00       brk 
; 58d0 04       ???
; 58d1 04       ???
; 58d2 07       ???
; 58d3 07       ???
; 58d4 24 c3    bit $c3
; 58d6 b1 45    lda ($45),y
; 58d8 3a       ???
; 58d9 15 1a    ora $1a,x
; 58db 0b       ???
; 58dc 01 35    ora ($35,x)
; 58de 3a       ???
; 58df 15 1a    ora $1a,x
; 58e1 cb       ???
; 58e2 c0 34    cpy #$34
; 58e4 48       pha 
; 58e5 15 00    ora $00,x
; 58e7 1f       ???
; 58e8 20 23 41 jsr $4123
; 58eb 42       ???
; 58ec 23       ???
; 58ed 04       ???
; 58ee 23       ???
; 58ef 22       ???
; 58f0 07       ???
; 58f1 0c       ???
; 58f2 27       ???
; 58f3 20 09 14 jsr $1409
; 58f6 2b       ???
; 58f7 31 1e    and ($1e),y
; 58f9 0c       ???
; 58fa 1f       ???
; 58fb 32       ???
; 58fc 13       ???
; 58fd 08       php 
; 58fe 27       ???
; 58ff 21 0e    and ($0e,x)
; 5901 10 43    bpl $5946
; 5903 73       ???
; 5904 34       ???
; 5905 7a       ???
; 5906 99 46 8e sta $8e46,y
; 5909 85 7d    sta $7d
; 590b 86 8e    stx $8e
; 590d 85 bd    sta $bd
; 590f 0f       ???
; 5910 70 00    bvs $5912
; 5912 80       ???
; 5913 e4 64    cpx $64
; 5915 2c 68 51 bit $5168
; 5918 15 0a    ora $0a,x
; 591a 22       ???
; 591b 1c       ???
; 591c 04       ???
; 591d 00       brk 
; 591e 04       ???
; 591f 09 15    ora #$15
; 5921 20 10 00 jsr $0010
; 5924 03       ???
; 5925 03       ???
; 5926 0f       ???
; 5927 25 1f    and $1f
; 5929 08       php 
; 592a fe fe 0e inc $0efe,x
; 592d 35 2f    and $2f,x
; 592f c8       iny 
; 5930 be fe 12 ldx $12fe,y
; 5933 33       ???
; 5934 2b       ???
; 5935 1f       ???
; 5936 13       ???
; 5937 fe 09 38 inc $3809,x
; 593a 34       ???
; 593b 5a       ???
; 593c 53       ???
; 593d fe 1e 1e inc $1e1e,x
; 5940 ff       ???
; 5941 04       ???
; 5942 14       ???
; 5943 0f       ???
; 5944 03       ???
; 5945 0c       ???
; 5946 1c       ???
; 5947 13       ???
; 5948 07       ???
; 5949 14       ???
; 594a 1c       ???
; 594b 0f       ???
; 594c 0b       ???
; 594d 0c       ???
; 594e 00       brk 
; 594f 00       brk 
; 5950 00       brk 
; 5951 00       brk 
; 5952 00       brk 
; 5953 90 91    bcc $58e6
; 5955 51 dc    eor ($dc),y
; 5957 c1 35    cmp ($35,x)
; 5959 12       ???
; 595a 4e 4b 0f lsr $0f4b
; 595d 00       brk 
; 595e 1c       ???
; 595f 28       plp 
; 5960 1d 20 0f ora $0f20,x
; 5963 00       brk 
; 5964 02       ???
; 5965 02       ???
; 5966 18       clc 
; 5967 28       plp 
; 5968 10 1f    bpl $5989
; 596a 2f       ???
; 596b 65 6d    adc $6d
; 596d 1d 14 2e ora $2e14,x
; 5970 2f       ???
; 5971 32       ???
; 5972 3a       ???
; 5973 25 16    and $16
; 5975 68       pla 
; 5976 7f       ???
; 5977 53       ???
; 5978 4b       ???
; 5979 25 16    and $16
; 597b 88       dey 
; 597c af       ???
; 597d 74       ???
; 597e 5c       ???
; 597f 1d 14 4e ora $4e14,x
; 5982 7f       ???
; 5983 95 6d    sta $6d,x
; 5985 28       plp 
; 5986 10 9f    bpl $5927
; 5988 f0 b7    beq $5941
; 598a 7e 1d 14 ror $141d,x
; 598d ae c0 87 ldx $87c0
; 5990 7e 25 16 ror $1625,x
; 5993 e8       inx 
; 5994 11 98    ora ($98),y
; 5996 7e 25 16 ror $1625,x
; 5999 08       php 
; 599a 42       ???
; 599b a9 7e    lda #$7e
; 599d 1d 14 ce ora $ce14,x
; 59a0 13       ???
; 59a1 ba       tsx 
; 59a2 85 2f    sta $2f
; 59a4 10 04    bpl $59aa
; 59a6 23       ???
; 59a7 3f       ???
; 59a8 24 0c    bit $0c
; 59aa 27       ???
; 59ab 4f       ???
; 59ac 38       sec 
; 59ad 14       ???
; 59ae 2b       ???
; 59af 5f       ???
; 59b0 4c 1c 2f jmp $2f1c
; 59b3 6f       ???
; 59b4 50 10    bvc $59c6
; 59b6 2f       ???
; 59b7 70 51    bvs $5a0a
; 59b9 14       ???
; 59ba 33       ???
; 59bb 40       rti 
; 59bc 25 1c    and $1c
; 59be 37       ???
; 59bf 51 3a    eor ($3a),y
; 59c1 24 3b    bit $3b
; 59c3 62       ???
; 59c4 4f       ???
; 59c5 2c 3f 73 bit $733f
; 59c8 64       ???
; 59c9 34       ???
; 59ca 43       ???
; 59cb 80       ???
; 59cc 75 2c    adc $2c,x
; 59ce 37       ???
; 59cf 81 7a    sta ($7a,x)
; 59d1 34       ???
; 59d2 3b       ???
; 59d3 82       ???
; 59d4 7f       ???
; 59d5 3c       ???
; 59d6 3f       ???
; 59d7 83       ???
; 59d8 84 44    sty $44
; 59da 43       ???
; 59db 84 89    sty $89
; 59dd 38       sec 
; 59de 33       ???
; 59df 7f       ???
; 59e0 60       rts 
; 59e1 00       brk 
; 59e2 1f       ???
; 59e3 1f       ???
; 59e4 29 47    and #$47
; 59e6 7d 5f 12 adc $125f,x
; 59e9 42       ???
; 59ea 8f       ???
; 59eb 5f       ???
; 59ec 33       ???
; 59ed 33       ???
; 59ee 7f       ???
; 59ef 7f       ???
; 59f0 12       ???
; 59f1 42       ???
; 59f2 6f       ???
; 59f3 3f       ???
; 59f4 29 47    and #$47
; 59f6 bd ff 60 lda $60ff,x
; 59f9 00       brk 
; 59fa 00       brk 
; 59fb 84 87    sty $87
; 59fd 41 b8    eor ($b8,x)
; 59ff ab       ???
; 5a00 31 0e    and ($0e),y
; 5a02 38       sec 
; 5a03 39 10 01 and $0110,y
; 5a06 28       plp 
; 5a07 3c       ???
; 5a08 28       plp 
; 5a09 32       ???
; 5a0a 1e 00 02 asl $0200,x
; 5a0d 02       ???
; 5a0e 12       ???
; 5a0f 37       ???
; 5a10 30 ca    bmi $59dc
; 5a12 c0 5a    cpy #$5a
; 5a14 77       ???
; 5a15 25 13    and $13
; 5a17 2b       ???
; 5a18 31 68    and ($68),y
; 5a1a 72       ???
; 5a1b 23       ???
; 5a1c 13       ???
; 5a1d 8b       ???
; 5a1e a2 8a    ldx #$8a
; 5a20 69 02    adc #$02
; 5a22 27       ???
; 5a23 66 73    ror $73
; 5a25 ac 94 3e ldy $3e94
; 5a28 40       rti 
; 5a29 dd c3 8d cmp $8dc3,x
; 5a2c 8e 0f 17 stx $170f
; 5a2f 6c 5e fe jmp ($fe5e)
; 5a32 13       ???
; 5a33 25 2f    and $2f
; 5a35 5d 3e fe eor $fe3e,x
; 5a38 1e 34 15 asl $1534,x
; 5a3b 04       ???
; 5a3c 23       ???
; 5a3d 45 2a    eor $2a
; 5a3f 0c       ???
; 5a40 27       ???
; 5a41 56 3f    lsr $3f,x
; 5a43 14       ???
; 5a44 2b       ???
; 5a45 67       ???
; 5a46 54       ???
; 5a47 1c       ???
; 5a48 2f       ???
; 5a49 28       plp 
; 5a4a 19 10 1f ora $1f10,y
; 5a4d 20 01 14 jsr $1401
; 5a50 33       ???
; 5a51 31 16    and ($16),y
; 5a53 18       clc 
; 5a54 33       ???
; 5a55 42       ???
; 5a56 2b       ???
; 5a57 1c       ???
; 5a58 33       ???
; 5a59 53       ???
; 5a5a 40       rti 
; 5a5b 20 33 23 jsr $2333
; 5a5e 14       ???
; 5a5f 24 33    bit $33
; 5a61 78       sei 
; 5a62 59 18 37 eor $3718,y
; 5a65 75 5a    adc $5a,x
; 5a67 1c       ???
; 5a68 37       ???
; 5a69 86 6f    stx $6f
; 5a6b 20 37 97 jsr $9737
; 5a6e 84 24    sty $24
; 5a70 37       ???
; 5a71 a8       tay 
; 5a72 99 28 f7 sta $f728,y
; 5a75 ee 12 0b inc $0b12
; 5a78 a7       ???
; 5a79 a6 13    ldx $13
; 5a7b 2a       rol a
; 5a7c 7d 7f 4f adc $4f7f,x
; 5a7f 47       ???
; 5a80 17       ???
; 5a81 02       ???
; 5a82 2a       rol a
; 5a83 2e 06 04 rol $0406
; 5a86 09 05    ora #$05
; 5a88 20 50 85 jsr $8550
; 5a8b 5c       ???
; 5a8c 47       ???
; 5a8d af       ???
; 5a8e 85 2a    sta $2a
; 5a90 94 cb    sty $cb,x
; 5a92 6f       ???
; 5a93 75 91    adc $91,x
; 5a95 55 4e    eor $4e,x
; 5a97 c1 c8    cmp ($c8,x)
; 5a99 67       ???
; 5a9a 96 94    stx $94,y
; 5a9c 26 00    rol $00
; 5a9e 19 63 e8 ora $e863,y
; 5aa1 e3       ???
; 5aa2 45 22    eor $22
; 5aa4 58       cli 
; 5aa5 4b       ???
; 5aa6 1a       ???
; 5aa7 05 38    ora $38
; 5aa9 6a       ror a
; 5aaa 6e 5a 1e ror $1e5a
; 5aad 00       brk 
; 5aae 01 01    ora ($01,x)
; 5ab0 00       brk 
; 5ab1 50 50    bvc $5b03
; 5ab3 1f       ???
; 5ab4 1e fe 4f asl $4ffe,x
; 5ab7 5a       ???
; 5ab8 0a       asl a
; 5ab9 df       ???
; 5aba de fe ff dec $fffe,x
; 5abd 50 50    bvc $5b0f
; 5abf 5f       ???
; 5ac0 5e fe 45 lsr $45fe,x
; 5ac3 6e 28 5f ror $5f28
; 5ac6 5e fe 3b lsr $3bfe,x
; 5ac9 6e 32 1f ror $1f32
; 5acc 84 41    sty $41
; 5ace 0e 32 3c asl $3c32
; 5ad1 5b       ???
; 5ad2 1e fe 27 asl $27fe,x
; 5ad5 28       plp 
; 5ad6 46 e5    lsr $e5
; 5ad8 af       ???
; 5ad9 42       ???
; 5ada 32       ???
; 5adb 1e 69 8a asl $8a69,x
; 5ade 3e fe ff rol $fffe,x
; 5ae1 32       ???
; 5ae2 6e bb 17 ror $17bb
; 5ae5 52       ???
; 5ae6 d9 91 72 cmp $7291,y
; 5ae9 04       ???
; 5aea 23       ???
; 5aeb f5 d6    sbc $d6,x
; 5aed 10 2f    bpl $5b1e
; 5aef e4 d1    cpx $d1
; 5af1 1c       ???
; 5af2 2f       ???
; 5af3 d3       ???
; 5af4 bc 14 2b ldy $2b14,x
; 5af7 c2       ???
; 5af8 a7       ???
; 5af9 0c       ???
; 5afa 27       ???
; 5afb 51 36    eor ($36),y
; 5afd 1c       ???
; 5afe 37       ???
; 5aff 50 39    bvc $5b3a
; 5b01 20 37 60 jsr $6037
; 5b04 49 1c    eor #$1c
; 5b06 33       ???
; 5b07 2f       ???
; 5b08 24 2c    bit $2c
; 5b0a 37       ???
; 5b0b 7f       ???
; 5b0c 60       rts 
; 5b0d 14       ???
; 5b0e 33       ???
; 5b0f 73       ???
; 5b10 60       rts 
; 5b11 20 33 3f jsr $3f33
; 5b14 20 18 37 jsr $3718
; 5b17 84 75    sty $75
; 5b19 24 33    bit $33
; 5b1b c7       ???
; 5b1c ac 24 3f ldy $3f24
; 5b1f a6 8b    ldx $8b
; 5b21 20 3b f6 jsr $f63b
; 5b24 d7       ???
; 5b25 1c       ???
; 5b26 3b       ???
; 5b27 fb       ???
; 5b28 ec 2c 3b cpx $3b2c
; 5b2b e8       inx 
; 5b2c d5 28    cmp $28,x
; 5b2e 3b       ???
; 5b2f d8       cld 
; 5b30 c5 2c    cmp $2c
; 5b32 3f       ???
; 5b33 d9 c2 28 cmp $28c2,y
; 5b36 3f       ???
; 5b37 b7       ???
; 5b38 b4 3c    ldy $3c,x
; 5b3a 3f       ???
; 5b3b 28       plp 
; 5b3c 4b       ???
; 5b3d 93       ???
; 5b3e b0 68    bcs $5ba8
; 5b40 4b       ???
; 5b41 93       ???
; 5b42 f0 e7    beq $5b2b
; 5b44 88       dey 
; 5b45 5f       ???
; 5b46 fe 1f 89 inc $891f,x
; 5b49 78       sei 
; 5b4a 8e 8c 7c stx $7c8c
; 5b4d 90 60    bcc $5baf
; 5b4f a6 96    ldx $96
; 5b51 32       ???
; 5b52 42       ???
; 5b53 45 72    eor $72
; 5b55 92       ???
; 5b56 05 01    ora $01
; 5b58 7d 62 26 adc $2662,x
; 5b5b 42       ???
; 5b5c 52       ???
; 5b5d 5f       ???
; 5b5e cf       ???
; 5b5f c1 50    cmp ($50,x)
; 5b61 59 4a 45 eor $454a,y
; 5b64 96 78    stx $78,y
; 5b66 a7       ???
; 5b67 b9 a0 99 lda $99a0,y
; 5b6a 72       ???
; 5b6b 90 5a    bcc $5bc7
; 5b6d 4c 82 6e jmp $6e82
; 5b70 8d 9d ef sta $ef9d
; 5b73 b0 01    bcs $5b76
; 5b75 79 bc 61 adc $61bc,y
; 5b78 1d 16 2e ora $2e16,x
; 5b7b 1e 06 00 asl $0006,x
; 5b7e 10 18    bpl $5b98
; 5b80 1c       ???
; 5b81 1e 07 fd asl $fd07,x
; 5b84 05 05    ora $05
; 5b86 18       clc 
; 5b87 31 29    and ($29),y
; 5b89 ef       ???
; 5b8a f1 45    sbc ($45),y
; 5b8c 33       ???
; 5b8d 0c       ???
; 5b8e 16 49    asl $49,x
; 5b90 41 35    eor ($35,x)
; 5b92 3e 11 08 rol $0811,x
; 5b95 61 60    adc ($60,x)
; 5b97 34       ???
; 5b98 3f       ???
; 5b99 36 31    rol $31,x
; 5b9b 26 20    rol $20
; 5b9d 23       ???
; 5b9e 41 42    eor ($42,x)
; 5ba0 23       ???
; 5ba1 04       ???
; 5ba2 23       ???
; 5ba3 22       ???
; 5ba4 07       ???
; 5ba5 0c       ???
; 5ba6 27       ???
; 5ba7 20 09 14 jsr $1409
; 5baa 2b       ???
; 5bab 31 1e    and ($1e),y
; 5bad 0c       ???
; 5bae 0f       ???
; 5baf d3       ???
; 5bb0 cd 8f 84 cmp $848f
; 5bb3 6f       ???
; 5bb4 71 26    adc ($26),y
; 5bb6 98       tya 
; 5bb7 90 1e    bcc $5bd7
; 5bb9 00       brk 
; 5bba 34       ???
; 5bbb 4a       lsr a
; 5bbc 36 28    rol $28,x
; 5bbe 08       php 
; 5bbf 00       brk 
; 5bc0 02       ???
; 5bc1 02       ???
; 5bc2 00       brk 
; 5bc3 11 28    ora ($28),y
; 5bc5 76 5e    ror $5e,x
; 5bc7 fe 10 11 inc $1110,x
; 5bca 17       ???
; 5bcb b6 9e    ldx $9e,y
; 5bcd fe ff 12 inc $12ff,x
; 5bd0 29 36    and #$36
; 5bd2 1e fe 11 asl $11fe,x
; 5bd5 12       ???
; 5bd6 17       ???
; 5bd7 36 1e    rol $1e,x
; 5bd9 fe 13 28 inc $2813,x
; 5bdc 2f       ???
; 5bdd 1a       ???
; 5bde 11 4b    ora ($4b),y
; 5be0 4d 28 2f eor $2f28
; 5be3 da       ???
; 5be4 f3       ???
; 5be5 8d 6d 28 sta $286d
; 5be8 2f       ???
; 5be9 5a       ???
; 5bea 95 cf    sta $cf,x
; 5bec 8d 28 2f sta $2f28
; 5bef 9a       txs 
; 5bf0 96 a0    stx $a0,y
; 5bf2 8e 05 1b stx $1b05
; 5bf5 4b       ???
; 5bf6 c9 32    cmp #$32
; 5bf8 99 02 1d sta $1d02,y
; 5bfb 8b       ???
; 5bfc 09 32    ora #$32
; 5bfe 9e       ???
; 5bff 05 1b    ora $1b
; 5c01 c4 42    cpy $42
; 5c03 32       ???
; 5c04 99 03 1e sta $1e03,y
; 5c07 44       ???
; 5c08 c2       ???
; 5c09 32       ???
; 5c0a 99 09 2c sta $2c09,y
; 5c0d 73       ???
; 5c0e 5a       ???
; 5c0f c6 bf    dec $bf
; 5c11 04       ???
; 5c12 20 66 46 jsr $4666
; 5c15 01 06    ora ($06,x)
; 5c17 0f       ???
; 5c18 24 21    bit $21
; 5c1a 09 f5    ora #$f5
; 5c1c ff       ???
; 5c1d 0f       ???
; 5c1e 1d 21 a9 ora $a921,x
; 5c21 e0 42    cpx #$42
; 5c23 04       ???
; 5c24 20 e6 32 jsr $32e6
; 5c27 8e 26 0e stx $0e26
; 5c2a 24 a1    bit $a1
; 5c2c 80       ???
; 5c2d b8       clv 
; 5c2e ca       dex 
; 5c2f 0e 1d a1 asl $a11d
; 5c32 d7       ???
; 5c33 67       ???
; 5c34 37       ???
; 5c35 21 02    and ($02,x)
; 5c37 04       ???
; 5c38 23       ???
; 5c39 69 4e    adc #$4e
; 5c3b 0c       ???
; 5c3c 27       ???
; 5c3d 8a       txa 
; 5c3e 73       ???
; 5c3f 14       ???
; 5c40 2b       ???
; 5c41 ab       ???
; 5c42 8c 0c 2b sty $2b0c
; 5c45 37       ???
; 5c46 18       clc 
; 5c47 1c       ???
; 5c48 34       ???
; 5c49 2a       rol a
; 5c4a 12       ???
; 5c4b 10 2f    bpl $5c7c
; 5c4d 42       ???
; 5c4e 27       ???
; 5c4f 14       ???
; 5c50 28       plp 
; 5c51 4c 38 18 jmp $1838
; 5c54 33       ???
; 5c55 64       ???
; 5c56 4d 1c 20 eor $201c
; 5c59 62       ???
; 5c5a 5e 20 37 lsr $3720,x
; 5c5d 86 73    stx $73
; 5c5f 24 30    bit $30
; 5c61 90 84    bcc $5be7
; 5c63 28       plp 
; 5c64 3b       ???
; 5c65 58       cli 
; 5c66 49 24    eor #$24
; 5c68 33       ???
; 5c69 78       sei 
; 5c6a 6d 2c 37 adc $372c
; 5c6d 98       tya 
; 5c6e 91 34    sta ($34),y
; 5c70 3b       ???
; 5c71 38       sec 
; 5c72 29 2c    and #$2c
; 5c74 2c 1c 0c bit $0c1c
; 5c77 30 40    bmi $5cb9
; 5c79 1a       ???
; 5c7a 0e 34 40 asl $4034
; 5c7d bb       ???
; 5c7e b3       ???
; 5c7f 38       sec 
; 5c80 40       rti 
; 5c81 cc c8 3c cpy $3cc8
; 5c84 40       rti 
; 5c85 a9 b9    lda #$b9
; 5c87 44       ???
; 5c88 2b       ???
; 5c89 a0 bd    ldy #$bd
; 5c8b 4c 31 a2 jmp $a231
; 5c8e c1 54    cmp ($54,x)
; 5c90 33       ???
; 5c91 a0 b9    ldy #$b9
; 5c93 4c 31 c0 jmp $c031
; 5c96 ef       ???
; 5c97 6c 40 c3 jmp ($c340)
; 5c9a f3       ???
; 5c9b 74       ???
; 5c9c 43       ???
; 5c9d c2       ???
; 5c9e ef       ???
; 5c9f 70 41    bvs $5ce2
; 5ca1 af       ???
; 5ca2 ea       nop 
; 5ca3 84 4c    sty $4c
; 5ca5 b2       ???
; 5ca6 ee 8c 4f inc $4f8c
; 5ca9 b1 ea    lda ($ea),y
; 5cab 88       dey 
; 5cac 27       ???
; 5cad 16 6e    asl $6e,x
; 5caf 5f       ???
; 5cb0 87       ???
; 5cb1 5f       ???
; 5cb2 4a       lsr a
; 5cb3 4e e3 12 lsr $12e3
; 5cb6 66 4a    ror $4a
; 5cb8 b6 e9    ldx $e9,y
; 5cba 4a       lsr a
; 5cbb 04       ???
; 5cbc a3       ???
; 5cbd d2       ???
; 5cbe 66 4a    ror $4a
; 5cc0 36 1f    rol $1f,x
; 5cc2 4a       lsr a
; 5cc3 4e 23 52 lsr $5223
; 5cc6 66 4a    ror $4a
; 5cc8 36 69    rol $69,x
; 5cca 4a       lsr a
; 5ccb 04       ???
; 5ccc 63       ???
; 5ccd 92       ???
; 5cce 66 4a    ror $4a
; 5cd0 56 3f    lsr $3f,x
; 5cd2 00       brk 
; 5cd3 6b       ???
; 5cd4 0a       asl a
; 5cd5 c8       iny 
; 5cd6 52       ???
; 5cd7 83       ???
; 5cd8 79 48 52 adc $5248,y
; 5cdb 83       ???
; 5cdc b9 96 6e lda $6e96,y
; 5cdf 5f       ???
; 5ce0 28       plp 
; 5ce1 c4 cd    cpy $cd
; 5ce3 fb       ???
; 5ce4 9c       ???
; 5ce5 3f       ???
; 5ce6 c5 4a    cmp $4a
; 5ce8 f8       sed 
; 5ce9 0c       ???
; 5cea 2e 00 38 rol $3800
; 5ced 48       pha 
; 5cee 30 2a    bmi $5d1a
; 5cf0 0a       asl a
; 5cf1 01 03    ora ($03,x)
; 5cf3 02       ???
; 5cf4 00       brk 
; 5cf5 0a       asl a
; 5cf6 24 59    bit $59
; 5cf8 45 7d    eor $7d
; 5cfa 90 1d    bcc $5d19
; 5cfc 1e d9 c0 asl $c0d9,x
; 5cff 78       sei 
; 5d00 93       ???
; 5d01 1f       ???
; 5d02 1d 19 00 ora $0019,x
; 5d05 23       ???
; 5d06 3b       ???
; 5d07 21 22    and ($22,x)
; 5d09 19 01 35 ora $3501,y
; 5d0c 4d 22 22 eor $2222
; 5d0f 99 82 47 sta $4782,y
; 5d12 61 20    adc ($20,x)
; 5d14 1d 99 83 ora $8399,x
; 5d17 59 6f 1e eor $1e6f,y
; 5d1a 1e 59 44 asl $4459,x
; 5d1d 6b       ???
; 5d1e 66 06    ror $06
; 5d20 12       ???
; 5d21 1f       ???
; 5d22 12       ???
; 5d23 fe 1d 1f inc $1f1d,x
; 5d26 0d eb f6 ora $f6eb
; 5d29 a0 aa    ldy #$aa
; 5d2b 29 14    and #$14
; 5d2d eb       ???
; 5d2e f1 4b    sbc ($4b),y
; 5d30 5a       ???
; 5d31 29 14    and #$14
; 5d33 6b       ???
; 5d34 93       ???
; 5d35 8e 78 1f stx $1f78
; 5d38 0d 6b b5 ora $b56b
; 5d3b 01 b6    ora ($b6,x)
; 5d3d 0d 20 fd ora $fd20
; 5d40 68       pla 
; 5d41 56 da    lsr $da,x
; 5d43 15 26    ora $26,x
; 5d45 fd 18 16 sbc $1618,x
; 5d48 eb       ???
; 5d49 16 26    asl $26,x
; 5d4b 7d 99 17 adc $1799,x
; 5d4e e8       inx 
; 5d4f 0d 20 7d ora $7d20
; 5d52 0a       asl a
; 5d53 78       sei 
; 5d54 d2       ???
; 5d55 0b       ???
; 5d56 08       php 
; 5d57 89       ???
; 5d58 fe ee 89 inc $89ee,x
; 5d5b 15 05    ora $05,x
; 5d5d 89       ???
; 5d5e fe ee 7c inc $7cee,x
; 5d61 0c       ???
; 5d62 0e ae 1e asl $1eae
; 5d65 ee 89 16 inc $1689
; 5d68 0b       ???
; 5d69 ae 1e ee ldx $ee1e
; 5d6c 82       ???
; 5d6d 11 14    ora ($14),y
; 5d6f b5 1e    lda $1e,x
; 5d71 ee 82 10 inc $1082
; 5d74 0c       ???
; 5d75 ae 1e ee ldx $ee1e
; 5d78 7c       ???
; 5d79 0c       ???
; 5d7a 15 35    ora $35,x
; 5d7c 8d cc 78 sta $78cc
; 5d7f 16 12    asl $12,x
; 5d81 35 8d    and $8d,x
; 5d83 cc 71 10 cpy $1071
; 5d86 0c       ???
; 5d87 2e 8d cc rol $cc8d
; 5d8a 6b       ???
; 5d8b 0b       ???
; 5d8c 09 2a    ora #$2a
; 5d8e 8d cc 78 sta $78cc
; 5d91 15 06    ora $06,x
; 5d93 2a       rol a
; 5d94 8d cc 71 sta $71cc
; 5d97 0f       ???
; 5d98 0c       ???
; 5d99 0f       ???
; 5d9a 6d cc 71 adc $71cc
; 5d9d 10 08    bpl $5da7
; 5d9f 2a       rol a
; 5da0 8d cc 76 sta $76cc
; 5da3 18       clc 
; 5da4 15 f3    ora $f3,x
; 5da6 19 66 43 ora $4366,y
; 5da9 18       clc 
; 5daa 18       clc 
; 5dab d6 f9    dec $f9,x
; 5dad 66 44    ror $44
; 5daf 19 15 73 ora $7315,y
; 5db2 99 66 44 sta $4466,y
; 5db5 19 18 56 ora $5618,y
; 5db8 79 66 40 adc $4066,y
; 5dbb 10 1d    bpl $5dda
; 5dbd 02       ???
; 5dbe e8       inx 
; 5dbf 00       brk 
; 5dc0 0d 10 1d ora $1d10
; 5dc3 82       ???
; 5dc4 68       pla 
; 5dc5 00       brk 
; 5dc6 09 0c    ora #$0c
; 5dc8 1d 3f 25 ora $253f,x
; 5dcb 00       brk 
; 5dcc 08       php 
; 5dcd 0b       ???
; 5dce 1d bf a5 ora $a5bf,x
; 5dd1 00       brk 
; 5dd2 1f       ???
; 5dd3 26 07    rol $07
; 5dd5 04       ???
; 5dd6 23       ???
; 5dd7 20 05 0c jsr $0c05
; 5dda 27       ???
; 5ddb 21 0a    and ($0a,x)
; 5ddd 14       ???
; 5dde 2b       ???
; 5ddf 22       ???
; 5de0 0f       ???
; 5de1 1c       ???
; 5de2 2f       ???
; 5de3 23       ???
; 5de4 14       ???
; 5de5 24 33    bit $33
; 5de7 24 19    bit $19
; 5de9 2c 37 25 bit $2537
; 5dec 06 18    asl $18
; 5dee 28       plp 
; 5def 77       ???
; 5df0 67       ???
; 5df1 1c       ???
; 5df2 3b       ???
; 5df3 36 1b    rol $1b,x
; 5df5 24 2b    bit $2b
; 5df7 1d 1a 2c ora $2c1a,x
; 5dfa 43       ???
; 5dfb 42       ???
; 5dfc 2f       ???
; 5dfd 30 43    bmi $5e42
; 5dff 53       ???
; 5e00 44       ???
; 5e01 38       sec 
; 5e02 33       ???
; 5e03 50 59    bvc $5e5e
; 5e05 3c       ???
; 5e06 47       ???
; 5e07 75 6e    adc $6e,x
; 5e09 44       ???
; 5e0a 3d 89 94 and $9489,x
; 5e0d 3c       ???
; 5e0e 31 2a    and ($2a),y
; 5e10 39 44 35 and $3544,y
; 5e13 6b       ???
; 5e14 82       ???
; 5e15 54       ???
; 5e16 3d 7c 87 and $877c,x
; 5e19 48       pha 
; 5e1a 3f       ???
; 5e1b cf       ???
; 5e1c d8       cld 
; 5e1d 58       cli 
; 5e1e 4f       ???
; 5e1f 9f       ???
; 5e20 a8       tay 
; 5e21 4c 40 99 jmp $9940
; 5e24 a9 50    lda #$50
; 5e26 4f       ???
; 5e27 58       cli 
; 5e28 5d 58 53 eor $5358,x
; 5e2b 59 62 60 eor $6062,y
; 5e2e 48       pha 
; 5e2f bb       ???
; 5e30 d7       ???
; 5e31 68       pla 
; 5e32 5b       ???
; 5e33 bc cd 64 ldy $64cd,x
; 5e36 53       ???
; 5e37 5c       ???
; 5e38 71 6c    adc ($6c),y
; 5e3a 57       ???
; 5e3b cc e5 74 cpy $74e5
; 5e3e 5b       ???
; 5e3f ec fd 6c cpx $6cfd
; 5e42 43       ???
; 5e43 7e b7 84 ror $84b7,x
; 5e46 4b       ???
; 5e47 7e bf 94 ror $94bf,x
; 5e4a 53       ???
; 5e4b 7e c3 9c ror $9cc3,x
; 5e4e 57       ???
; 5e4f 7e bf 98 ror $98bf,x
; 5e52 57       ???
; 5e53 7e c7 a4 ror $a4c7,x
; 5e56 5b       ???
; 5e57 6d be b4 adc $b4be
; 5e5a 63       ???
; 5e5b 6d c2 bc adc $bcc2
; 5e5e 67       ???
; 5e5f 6d c6 b8 adc $b8c6
; 5e62 5f       ???
; 5e63 6d ca cc adc $ccca
; 5e66 6f       ???
; 5e67 6d ce d4 adc $d4ce
; 5e6a 73       ???
; 5e6b 6d ca d0 adc $d0ca
; 5e6e 73       ???
; 5e6f 6d d2 dc adc $dcd2
; 5e72 76 39    ror $39,x
; 5e74 a7       ???
; 5e75 ec 7e 39 cpx $397e
; 5e78 af       ???
; 5e79 fc       ???
; 5e7a 88       dey 
; 5e7b 08       php 
; 5e7c 84 0c    sty $0c
; 5e7e 8d 05 88 sta $8805
; 5e81 14       ???
; 5e82 91 05    sta ($05),y
; 5e84 8c 1c 95 sty $951c
; 5e87 05 90    ora $90
; 5e89 14       ???
; 5e8a c3       ???
; 5e8b 3f       ???
; 5e8c 00       brk 
; 5e8d 67       ???
; 5e8e 26 2e    rol $2e
; 5e90 9f       ???
; 5e91 37       ???
; 5e92 06 68    asl $68
; 5e94 a8       tay 
; 5e95 54       ???
; 5e96 74       ???
; 5e97 5f       ???
; 5e98 22       ???
; 5e99 22       ???
; 5e9a 7f       ???
; 5e9b e8       inx 
; 5e9c a8       tay 
; 5e9d 54       ???
; 5e9e 54       ???
; 5e9f ae 9f 37 ldx $379f
; 5ea2 26 27    rol $27
; 5ea4 28       plp 
; 5ea5 23       ???
; 5ea6 a2 a7    ldx #$a7
; 5ea8 28       plp 
; 5ea9 23       ???
; 5eaa 96 9b    stx $9b,y
; 5eac 2a       rol a
; 5ead 2d aa ea and $eaaa
; 5eb0 6b       ???
; 5eb1 6f       ???
; 5eb2 6e 6a 6b ror $6b6a
; 5eb5 6f       ???
; 5eb6 62       ???
; 5eb7 1b       ???
; 5eb8 2a       rol a
; 5eb9 2d 2a 1f and $1f2a
; 5ebc 26 37    rol $37
; 5ebe 30 1f    bmi $5edf
; 5ec0 00       brk 
; 5ec1 79 7c 44 adc $447c,y
; 5ec4 64       ???
; 5ec5 df       ???
; 5ec6 10 f1    bpl $5eb9
; 5ec8 f1 7e    sbc ($7e),y
; 5eca d2       ???
; 5ecb ce 26 00 dec $0026
; 5ece 34       ???
; 5ecf 66 c8    ror $c8
; 5ed1 b2       ???
; 5ed2 1c       ???
; 5ed3 01 02    ora ($02,x)
; 5ed5 14       ???
; 5ed6 33       ???
; 5ed7 20 4c 6b jsr $6b4c
; 5eda 1e fe 1f asl $1ffe,x
; 5edd 20 4c eb jsr $eb4c
; 5ee0 9e       ???
; 5ee1 fe ff 1a inc $1aff,x
; 5ee4 32       ???
; 5ee5 37       ???
; 5ee6 1e fe 77 asl $77fe,x
; 5ee9 7b       ???
; 5eea 0b       ???
; 5eeb 07       ???
; 5eec 72       ???
; 5eed 1d 22 7b ora $7b22,x
; 5ef0 0b       ???
; 5ef1 87       ???
; 5ef2 03       ???
; 5ef3 50 24    bvc $5f19
; 5ef5 68       pla 
; 5ef6 38       sec 
; 5ef7 e7       ???
; 5ef8 be fe 57 ldx $57fe,y
; 5efb 68       pla 
; 5efc 38       sec 
; 5efd 67       ???
; 5efe 3e fe 7f rol $7ffe,x
; 5f01 88       dey 
; 5f02 30 a7    bmi $5eab
; 5f04 17       ???
; 5f05 64       ???
; 5f06 4c 88 30 jmp $3088
; 5f09 27       ???
; 5f0a 96 41    stx $41,y
; 5f0c aa       tax 
; 5f0d 1a       ???
; 5f0e 42       ???
; 5f0f 67       ???
; 5f10 a4 fe    ldy $fe
; 5f12 b9 38 40 lda $4038,y
; 5f15 27       ???
; 5f16 a8       tay 
; 5f17 64       ???
; 5f18 db       ???
; 5f19 38       sec 
; 5f1a 40       rti 
; 5f1b a7       ???
; 5f1c 38       sec 
; 5f1d 85 f0    sta $f0
; 5f1f 2c 30 dc bit $dc30
; 5f22 4d 32 a1 eor $a132
; 5f25 14       ???
; 5f26 34       ???
; 5f27 dc       ???
; 5f28 4d 32 a1 eor $a132
; 5f2b 14       ???
; 5f2c 34       ???
; 5f2d 5c       ???
; 5f2e cd 32 bd cmp $bd32
; 5f31 2c 30 5c bit $5c30
; 5f34 cd 32 bd cmp $bd32
; 5f37 30 34    bmi $5f6d
; 5f39 9c       ???
; 5f3a 0d 32 a1 ora $a132
; 5f3d 18       clc 
; 5f3e 38       sec 
; 5f3f 9c       ???
; 5f40 0d 32 a1 ora $a132
; 5f43 18       clc 
; 5f44 38       sec 
; 5f45 1c       ???
; 5f46 8d 32 bd sta $bd32
; 5f49 30 34    bmi $5f7f
; 5f4b 1c       ???
; 5f4c 8d 32 99 sta $9932
; 5f4f 00       brk 
; 5f50 4c 52 b6 jmp $b652
; 5f53 6b       ???
; 5f54 bb       ???
; 5f55 00       brk 
; 5f56 5a       ???
; 5f57 79 cf 6b adc $6bcf,y
; 5f5a 0b       ???
; 5f5b 56 2e    lsr $2e,x
; 5f5d 10 81    bpl $5ee0
; 5f5f 32       ???
; 5f60 e9 56    sbc #$56
; 5f62 2e d0 41 rol $41d0
; 5f65 32       ???
; 5f66 f1 58    sbc ($58),y
; 5f68 28       plp 
; 5f69 ce 3f 32 dec $323f
; 5f6c e9 56    sbc #$56
; 5f6e 2e 50 c1 rol $c150
; 5f71 32       ???
; 5f72 f1 58    sbc ($58),y
; 5f74 28       plp 
; 5f75 4e bf 32 lsr $32bf
; 5f78 e9 56    sbc #$56
; 5f7a 2e 90 01 rol $0190
; 5f7d 32       ???
; 5f7e b8       clv 
; 5f7f cf       ???
; 5f80 b0 04    bcs $5f86
; 5f82 23       ???
; 5f83 e3       ???
; 5f84 c4 10    cpy $10
; 5f86 2f       ???
; 5f87 c2       ???
; 5f88 a7       ???
; 5f89 10 2b    bpl $5fb6
; 5f8b c6 b3    dec $b3
; 5f8d 2c 3f e7 bit $e73f
; 5f90 d8       cld 
; 5f91 2c 3b b7 bit $b73b
; 5f94 b0 34    bcs $5fca
; 5f96 3b       ???
; 5f97 b5 ae    lda $ae,x
; 5f99 3c       ???
; 5f9a 43       ???
; 5f9b b4 a9    ldy $a9,x
; 5f9d 38       sec 
; 5f9e 43       ???
; 5f9f b6 ab    ldx $ab,y
; 5fa1 34       ???
; 5fa2 3f       ???
; 5fa3 70 59    bvs $5ffe
; 5fa5 1c       ???
; 5fa6 33       ???
; 5fa7 81 6a    sta ($6a,x)
; 5fa9 20 37 92 jsr $9237
; 5fac 7f       ???
; 5fad 20 33 a3 jsr $a333
; 5fb0 94 28    sty $28,x
; 5fb2 37       ???
; 5fb3 2f       ???
; 5fb4 14       ???
; 5fb5 0c       ???
; 5fb6 27       ???
; 5fb7 3f       ???
; 5fb8 20 08 27 jsr $2708
; 5fbb c8       iny 
; 5fbc c9 48    cmp #$48
; 5fbe 47       ???
; 5fbf d8       cld 
; 5fc0 e1 54    sbc ($54,x)
; 5fc2 4b       ???
; 5fc3 e8       inx 
; 5fc4 e5 48    sbc $48
; 5fc6 4b       ???
; 5fc7 d9 be 2c cmp $2cbe,y
; 5fca 47       ???
; 5fcb ea       nop 
; 5fcc cb       ???
; 5fcd 2c 49 4e bit $4e49
; 5fd0 35 18    and $18,x
; 5fd2 31 5f    and ($5f),y
; 5fd4 42       ???
; 5fd5 18       clc 
; 5fd6 1e b6 00 asl $00b6,x
; 5fd9 a4 68    ldy $68
; 5fdb ad c9 64 lda $64c9
; 5fde 48       pha 
; 5fdf ad e1 94 lda $94e1
; 5fe2 60       rts 
; 5fe3 ad d1 74 lda $74d1
; 5fe6 50 ad    bvc $5f95
; 5fe8 d9 84 57 cmp $5784,y
; 5feb ac d5 7c ldy $7cd5
; 5fee 51 aa    eor ($aa),y
; 5ff0 d1 7c    cmp ($7c),y
; 5ff2 57       ???
; 5ff3 ac cd 7c ldy $7ccd
; 5ff6 5b       ???
; 5ff7 ac c9 7c ldy $7cc9
; 5ffa 6a       ror a
; 5ffb 83       ???
; 5ffc 6d 2c 2a adc $2a2c
; 5fff 9f       ???
; 6000 f1 b8    sbc ($b8),y
; 6002 66 9f    ror $9f
; 6004 f5 bc    sbc $bc,x
; 6006 68       pla 
; 6007 a1 f1    lda ($f1,x)
; 6009 b4 62    ldy $62,x
; 600b 9f       ???
; 600c fd cc 6e sbc $6ecc,x
; 600f 9f       ???
; 6010 01 d4    ora ($d4,x)
; 6012 74       ???
; 6013 a1 fd    lda ($fd,x)
; 6015 d0 8b    bne $5fa2
; 6017 1f       ???
; 6018 3e 5d be rol $be5d,x
; 601b b1 49    lda ($49),y
; 601d 47       ???
; 601e 2f       ???
; 601f 31 49    and ($49),y
; 6021 47       ???
; 6022 af       ???
; 6023 af       ???
; 6024 44       ???
; 6025 42       ???
; 6026 2d 2f 44 and $442f
; 6029 42       ???
; 602a ad ad 3d lda $3dad
; 602d 2f       ???
; 602e 1f       ???
; 602f 2d 3d 2f and $2f3d
; 6032 9f       ???
; 6033 dc       ???
; 6034 a3       ???
; 6035 66 1f    ror $1f
; 6037 5c       ???
; 6038 a3       ???
; 6039 66 3f    ror $3f
; 603b 3f       ???
; 603c 00       brk 
; 603d 50 2f    bvc $606e
; 603f e6 31    inc $31
; 6041 33       ???
; 6042 68       pla 
; 6043 5f       ???
; 6044 1e 24 65 asl $6524,x
; 6047 66 31    ror $31
; 6049 33       ???
; 604a 0e 05 19 asl $1905
; 604d 6f       ???
; 604e 14       ???
; 604f 17       ???
; 6050 59 2a 6c eor $6c2a,y
; 6053 5c       ???
; 6054 1a       ???
; 6055 00       brk 
; 6056 34       ???
; 6057 5c       ???
; 6058 22       ???
; 6059 0e 14 00 asl $0014
; 605c 00       brk 
; 605d 1b       ???
; 605e 1b       ???
; 605f 00       brk 
; 6060 e0 ff    cpx #$ff
; 6062 2f       ???
; 6063 42       ???
; 6064 32       ???
; 6065 30 60    bmi $60c7
; 6067 4f       ???
; 6068 2f       ???
; 6069 64       ???
; 606a b4 60    ldy $60,x
; 606c 10 4f    bpl $60bd
; 606e 3e fe 5f rol $5ffe,x
; 6071 60       rts 
; 6072 10 cf    bpl $6043
; 6074 be fe ff ldx $fffe,y
; 6077 30 50    bmi $60c9
; 6079 5f       ???
; 607a 93       ???
; 607b ec 98 18 cpx $1898
; 607e 88       dey 
; 607f af       ???
; 6080 c8       iny 
; 6081 55 fc    eor $fc,x
; 6083 30 70    bmi $60f5
; 6085 2f       ???
; 6086 77       ???
; 6087 84 fc    sty $fc
; 6089 30 70    bmi $60fb
; 608b af       ???
; 608c e8       inx 
; 608d 75 cc    adc $cc,x
; 608f 30 60    bmi $60f1
; 6091 8f       ???
; 6092 91 a8    sta ($a8),y
; 6094 76 30    ror $30,x
; 6096 50 9f    bvc $6037
; 6098 f5 30    sbc $30,x
; 609a ba       tsx 
; 609b 18       clc 
; 609c 88       dey 
; 609d ef       ???
; 609e 39 86 eb and $eb86,y
; 60a1 51 32    eor ($32),y
; 60a3 20 3f 3f jsr $3f3f
; 60a6 20 0c 2b jsr $2b0c
; 60a9 50 31    bvc $60dc
; 60ab 08       php 
; 60ac 27       ???
; 60ad 2f       ???
; 60ae 10 04    bpl $60b4
; 60b0 23       ???
; 60b1 78       sei 
; 60b2 61 18    adc ($18,x)
; 60b4 2f       ???
; 60b5 70 55    bvs $610c
; 60b7 0c       ???
; 60b8 27       ???
; 60b9 56 3f    lsr $3f,x
; 60bb 28       plp 
; 60bc 3f       ???
; 60bd 5f       ???
; 60be 44       ???
; 60bf 10 2b    bpl $60ec
; 60c1 81 6e    sta ($6e,x)
; 60c3 2c 3f c6 bit $c63f
; 60c6 af       ???
; 60c7 2c 43 a3 bit $a343
; 60ca 90 1c    bcc $60e8
; 60cc 2f       ???
; 60cd d5 c2    cmp $c2,x
; 60cf 30 2b    bmi $60fc
; 60d1 8f       ???
; 60d2 94 20    sty $20,x
; 60d4 1b       ???
; 60d5 c2       ???
; 60d6 c7       ???
; 60d7 34       ???
; 60d8 2f       ???
; 60d9 a0 a1    ldy #$a1
; 60db 1c       ???
; 60dc 1b       ???
; 60dd b1 b2    lda ($b2),y
; 60df 30 47    bmi $6128
; 60e1 c8       iny 
; 60e2 b1 24    lda ($24),y
; 60e4 3b       ???
; 60e5 d7       ???
; 60e6 c4 24    cpy $24
; 60e8 37       ???
; 60e9 e7       ???
; 60ea dc       ???
; 60eb 2c 37 e8 bit $e837
; 60ee dd 30 3b cmp $3b30,x
; 60f1 cb       ???
; 60f2 c8       iny 
; 60f3 44       ???
; 60f4 47       ???
; 60f5 ea       nop 
; 60f6 e3       ???
; 60f7 40       rti 
; 60f8 47       ???
; 60f9 b7       ???
; 60fa a8       tay 
; 60fb 24 33    bit $33
; 60fd d9 de 4c cmp $4cde,y
; 6100 47       ???
; 6101 73       ???
; 6102 58       cli 
; 6103 14       ???
; 6104 2f       ???
; 6105 95 96    sta $96,x
; 6107 44       ???
; 6108 c3       ???
; 6109 ba       tsx 
; 610a 43       ???
; 610b 33       ???
; 610c 2a       rol a
; 610d 3a       ???
; 610e 43       ???
; 610f 33       ???
; 6110 ea       nop 
; 6111 fa       ???
; 6112 43       ???
; 6113 33       ???
; 6114 6a       ror a
; 6115 7a       ???
; 6116 43       ???
; 6117 33       ???
; 6118 aa       tax 
; 6119 b2       ???
; 611a 39 26 1f and $1f26,y
; 611d 32       ???
; 611e 39 26 df and $df26,y
; 6121 f2       ???
; 6122 39 26 5f and $5f26,y
; 6125 72       ???
; 6126 39 26 bf and $bf26,y
; 6129 d8       cld 
; 612a 3e 30 4a rol $4a30,x
; 612d 58       cli 
; 612e 3e 30 8a rol $8a30,x
; 6131 98       tya 
; 6132 3e 30 0a rol $0a30,x
; 6135 18       clc 
; 6136 3e 30 4a rol $4a30,x
; 6139 3f       ???
; 613a 00       brk 
; 613b 70 75    bvs $61b2
; 613d 29 37    and #$37
; 613f 75 24    adc $24,x
; 6141 1f       ???
; 6142 5d 26 74 eor $7426,x
; 6145 66 18    ror $18
; 6147 00       brk 
; 6148 34       ???
; 6149 5c       ???
; 614a 22       ???
; 614b 12       ???
; 614c 18       clc 
; 614d 00       brk 
; 614e 00       brk 
; 614f 1c       ???
; 6150 1c       ???
; 6151 00       brk 
; 6152 5d 7c 1e eor $1e7c,x
; 6155 fe ff 28 inc $28ff,x
; 6158 7f       ???
; 6159 8f       ???
; 615a 3a       ???
; 615b 35 59    and $59,x
; 615d 3f       ???
; 615e 7c       ???
; 615f db       ???
; 6160 79 45 6a adc $6a45,y
; 6163 3f       ???
; 6164 7c       ???
; 6165 5b       ???
; 6166 0a       asl a
; 6167 67       ???
; 6168 7b       ???
; 6169 4e 63 fa lsr $fa63
; 616c e2       ???
; 616d 8c 8f 4e sty $4e8f
; 6170 63       ???
; 6171 7a       ???
; 6172 42       ???
; 6173 6e a9 3e ror $3ea9
; 6176 43       ???
; 6177 82       ???
; 6178 43       ???
; 6179 8f       ???
; 617a a3       ???
; 617b 59 90 ce eor $ce90,y
; 617e 93       ???
; 617f 9e       ???
; 6180 a2 59    ldx #$59
; 6182 90 4e    bcc $61d2
; 6184 14       ???
; 6185 8f       ???
; 6186 b8       clv 
; 6187 3e 43 02 rol $0243,x
; 618a e4 9e    cpx $9e
; 618c 79 07 72 adc $7207,y
; 618f a1 38    lda ($38,x)
; 6191 ac b7 16 ldy $16b7
; 6194 74       ???
; 6195 e1 77    sbc ($77,x)
; 6197 ab       ???
; 6198 b7       ???
; 6199 16 74    asl $74,x
; 619b 61 08    adc ($08,x)
; 619d de eb 8a dec $8aeb,x
; 61a0 6b       ???
; 61a1 14       ???
; 61a2 33       ???
; 61a3 a9 8a    lda #$8a
; 61a5 1c       ???
; 61a6 3b       ???
; 61a7 98       tya 
; 61a8 79 24 41 adc $4124,y
; 61ab 86 69    stx $69
; 61ad 10 2d    bpl $61dc
; 61af a8       tay 
; 61b0 8b       ???
; 61b1 18       clc 
; 61b2 35 97    and $97,x
; 61b4 7a       ???
; 61b5 20 3f 55 jsr $553f
; 61b8 46 24    lsr $24
; 61ba 33       ???
; 61bb 2a       rol a
; 61bc 1f       ???
; 61bd 2c 37 67 bit $6737
; 61c0 60       rts 
; 61c1 34       ???
; 61c2 3b       ???
; 61c3 39 36 3c and $3c36,y
; 61c6 3f       ???
; 61c7 76 77    ror $77,x
; 61c9 44       ???
; 61ca 43       ???
; 61cb 48       pha 
; 61cc 39 34 3c and $3c34,y
; 61cf 3b       ???
; 61d0 27       ???
; 61d1 14       ???
; 61d2 28       plp 
; 61d3 1b       ???
; 61d4 07       ???
; 61d5 18       clc 
; 61d6 2c 3d 31 bit $313d
; 61d9 30 3c    bmi $6217
; 61db 2d 21 2c and $2c21
; 61de 38       sec 
; 61df 1c       ???
; 61e0 0c       ???
; 61e1 20 30 2c jsr $2c30
; 61e4 1c       ???
; 61e5 24 32    bit $32
; 61e7 18       clc 
; 61e8 06 2c    asl $2c
; 61ea 3e 17 09 rol $0917,x
; 61ed 34       ???
; 61ee 42       ???
; 61ef 28       plp 
; 61f0 1e 3c 3e asl $3e3c,x
; 61f3 1a       ???
; 61f4 34       ???
; 61f5 54       ???
; 61f6 3a       ???
; 61f7 2a       rol a
; 61f8 48       pha 
; 61f9 5c       ???
; 61fa 3e 3a 5c rol $5c3a,x
; 61fd 58       cli 
; 61fe 67       ???
; 61ff 6a       ror a
; 6200 50 61    bvc $6263
; 6202 bb       ???
; 6203 7f       ???
; 6204 2d 86 18 and $1886
; 6207 ea       nop 
; 6208 50 61    bvc $626b
; 620a 5b       ???
; 620b 1f       ???
; 620c 28       plp 
; 620d 28       plp 
; 620e 7f       ???
; 620f bd 5e 34 lda $345e,x
; 6212 13       ???
; 6213 3d 5e 34 and $345e,x
; 6216 33       ???
; 6217 1f       ???
; 6218 17       ???
; 6219 1d e5 f6 ora $f6e5,x
; 621c 26 18    rol $18
; 621e 68       pla 
; 621f 76 26    ror $26,x
; 6221 18       clc 
; 6222 a8       tay 
; 6223 b9 27 17 lda $1727,y
; 6226 69 5f    adc #$5f
; 6228 1f       ???
; 6229 2b       ???
; 622a 2b       ???
; 622b 39 27 17 and $1727,y
; 622e 38       sec 
; 622f 2e 00 6b rol $6b00
; 6232 72       ???
; 6233 17       ???
; 6234 37       ???
; 6235 95 40    sta $40,x
; 6237 2f       ???
; 6238 8d 5e 88 sta $885e
; 623b 73       ???
; 623c 19 00 30 ora $3000,y
; 623f 54       ???
; 6240 20 0a 0e jsr $0e0a
; 6243 00       brk 
; 6244 01 40    ora ($40,x)
; 6246 3f       ???
; 6247 07       ???
; 6248 41 78    eor ($78,x)
; 624a 3f       ???
; 624b 56 80    lsr $80,x
; 624d 38       sec 
; 624e 32       ???
; 624f 23       ???
; 6250 ff       ???
; 6251 23       ???
; 6252 3c       ???
; 6253 49 32    eor #$32
; 6255 01 00    ora ($00,x)
; 6257 35 4d    and $4d,x
; 6259 49 32    eor #$32
; 625b 81 81    sta ($81,x)
; 625d 47       ???
; 625e 6f       ???
; 625f 38       sec 
; 6260 32       ???
; 6261 a3       ???
; 6262 82       ???
; 6263 59 55 30 eor $3055,y
; 6266 61 6f    adc ($6f,x)
; 6268 53       ???
; 6269 7b       ???
; 626a ab       ???
; 626b 54       ???
; 626c 1e cd d0 asl $d0cd,x
; 626f 89       ???
; 6270 a2 52    ldx #$52
; 6272 4f       ???
; 6273 07       ???
; 6274 02       ???
; 6275 ab       ???
; 6276 b3       ???
; 6277 52       ???
; 6278 4f       ???
; 6279 87       ???
; 627a 93       ???
; 627b cd de 54 cmp $54de
; 627e 1e 4d 83 asl $834d,x
; 6281 ef       ???
; 6282 d5 60    cmp $60,x
; 6284 4c d6 be jmp $bed6
; 6287 fe 44 46 inc $4644,x
; 628a 21 ff    and ($ff,x)
; 628c 06 af    asl $af
; 628e 88       dey 
; 628f 00       brk 
; 6290 fe 1d 1e inc $1e1d,x
; 6293 fe 44 46 inc $4644,x
; 6296 21 7f    and ($7f,x)
; 6298 a8       tay 
; 6299 f3       ???
; 629a d5 60    cmp $60,x
; 629c 4c 56 3e jmp $3e56
; 629f fe 1d 1f inc $1f1d,x
; 62a2 01 04    ora ($04,x)
; 62a4 22       ???
; 62a5 20 06 0c jsr $0c06
; 62a8 26 21    rol $21
; 62aa 0b       ???
; 62ab 14       ???
; 62ac 2a       rol a
; 62ad 22       ???
; 62ae 10 1c    bpl $62cc
; 62b0 2e 23 05 rol $0523
; 62b3 10 2d    bpl $62e2
; 62b5 32       ???
; 62b6 15 14    ora $14,x
; 62b8 31 2f    and ($2f),y
; 62ba 16 1c    asl $1c,x
; 62bc 35 40    and $40,x
; 62be 2b       ???
; 62bf 24 39    bit $39
; 62c1 51 40    eor ($40),y
; 62c3 2c 3d 62 bit $623d
; 62c6 55 34    eor $34,x
; 62c8 42       ???
; 62c9 34       ???
; 62ca 2a       rol a
; 62cb 3c       ???
; 62cc 46 35    lsr $35
; 62ce 2f       ???
; 62cf 40       rti 
; 62d0 46 45    lsr $45
; 62d2 3f       ???
; 62d3 44       ???
; 62d4 4a       lsr a
; 62d5 46 44    lsr $44
; 62d7 48       pha 
; 62d8 4b       ???
; 62d9 57       ???
; 62da 54       ???
; 62db 4c 4f 58 jmp $584f
; 62de 59 50 4e eor $4e50,y
; 62e1 67       ???
; 62e2 69 54    adc #$54
; 62e4 52       ???
; 62e5 68       pla 
; 62e6 6e 58 52 ror $5258
; 62e9 78       sei 
; 62ea 7e 5c 56 ror $565c,x
; 62ed 74       ???
; 62ee 6a       ror a
; 62ef 4c 56 89 jmp $8956
; 62f2 93       ???
; 62f3 60       rts 
; 62f4 57       ???
; 62f5 9a       txs 
; 62f6 a3       ???
; 62f7 58       cli 
; 62f8 4f       ???
; 62f9 97       ???
; 62fa a4 5c    ldy $5c
; 62fc 4f       ???
; 62fd b9 ca 64 lda $64ca,y
; 6300 53       ???
; 6301 ca       dex 
; 6302 db       ???
; 6303 68       pla 
; 6304 b6 7e    ldx $7e,y
; 6306 33       ???
; 6307 64       ???
; 6308 ef       ???
; 6309 f1 45    sbc ($45),y
; 630b 69 55    adc #$55
; 630d 4b       ???
; 630e 86 4c    stx $4c
; 6310 72       ???
; 6311 5f       ???
; 6312 5a       ???
; 6313 6a       ror a
; 6314 8e cb 86 stx $86cb
; 6317 4c 51 71 jmp $7151
; 631a 45 69    eor $69
; 631c 95 3e    sta $3e,x
; 631e 6f       ???
; 631f 83       ???
; 6320 b3       ???
; 6321 00       brk 
; 6322 a9 60    lda #$60
; 6324 f7       ???
; 6325 4b       ???
; 6326 b0 66    bcs $638e
; 6328 81 cb    sta ($cb,x)
; 632a b0 66    bcs $6392
; 632c 41 80    eor ($80,x)
; 632e a9 60    lda #$60
; 6330 37       ???
; 6331 1f       ???
; 6332 5e 70 19 lsr $1970,x
; 6335 07       ???
; 6336 19 63 e8 ora $e863,y
; 6339 e3       ???
; 633a 45 32    eor $32
; 633c 68       pla 
; 633d 4b       ???
; 633e 15 00    ora $00,x
; 6340 38       sec 
; 6341 6a       ror a
; 6342 e6 d2    inc $d2
; 6344 1e 00 01 asl $0100,x
; 6347 03       ???
; 6348 02       ???
; 6349 50 50    bvc $639b
; 634b 1f       ???
; 634c 1e fe 4f asl $4ffe,x
; 634f 5a       ???
; 6350 0a       asl a
; 6351 df       ???
; 6352 de fe ff dec $fffe,x
; 6355 50 50    bvc $63a7
; 6357 5f       ???
; 6358 5e fe 45 lsr $45fe,x
; 635b 6e 28 5f ror $5f28
; 635e 5e fe 3b lsr $3bfe,x
; 6361 6e 32 1f ror $1f32
; 6364 84 41    sty $41
; 6366 0e 32 3c asl $3c32
; 6369 5b       ???
; 636a 1e fe 27 asl $27fe,x
; 636d 28       plp 
; 636e 46 e5    lsr $e5
; 6370 af       ???
; 6371 42       ???
; 6372 32       ???
; 6373 1e 69 8a asl $8a69,x
; 6376 3e fe ff rol $fffe,x
; 6379 32       ???
; 637a 6e bb 17 ror $17bb
; 637d 52       ???
; 637e d9 91 72 cmp $7291,y
; 6381 04       ???
; 6382 23       ???
; 6383 f5 d6    sbc $d6,x
; 6385 10 2f    bpl $63b6
; 6387 e4 d1    cpx $d1
; 6389 1c       ???
; 638a 2f       ???
; 638b d3       ???
; 638c bc 14 2b ldy $2b14,x
; 638f c2       ???
; 6390 a7       ???
; 6391 0c       ???
; 6392 27       ???
; 6393 51 36    eor ($36),y
; 6395 1c       ???
; 6396 37       ???
; 6397 50 39    bvc $63d2
; 6399 20 37 60 jsr $6037
; 639c 49 1c    eor #$1c
; 639e 33       ???
; 639f 2f       ???
; 63a0 24 2c    bit $2c
; 63a2 37       ???
; 63a3 7f       ???
; 63a4 60       rts 
; 63a5 14       ???
; 63a6 33       ???
; 63a7 73       ???
; 63a8 60       rts 
; 63a9 20 33 3f jsr $3f33
; 63ac 20 18 37 jsr $3718
; 63af 84 75    sty $75
; 63b1 24 33    bit $33
; 63b3 c7       ???
; 63b4 ac 24 3f ldy $3f24
; 63b7 a6 8b    ldx $8b
; 63b9 20 3b f6 jsr $f63b
; 63bc d7       ???
; 63bd 1c       ???
; 63be 3b       ???
; 63bf fb       ???
; 63c0 ec 2c 3b cpx $3b2c
; 63c3 e8       inx 
; 63c4 d5 28    cmp $28,x
; 63c6 3b       ???
; 63c7 d8       cld 
; 63c8 c5 2c    cmp $2c
; 63ca 3f       ???
; 63cb d9 c2 28 cmp $28c2,y
; 63ce 3f       ???
; 63cf b7       ???
; 63d0 b4 3c    ldy $3c,x
; 63d2 3f       ???
; 63d3 28       plp 
; 63d4 4b       ???
; 63d5 93       ???
; 63d6 b0 68    bcs $6440
; 63d8 4b       ???
; 63d9 93       ???
; 63da f0 e7    beq $63c3
; 63dc 88       dey 
; 63dd 5f       ???
; 63de fe 1f 89 inc $891f,x
; 63e1 78       sei 
; 63e2 8e 8c 7c stx $7c8c
; 63e5 90 60    bcc $6447
; 63e7 a6 96    ldx $96
; 63e9 32       ???
; 63ea 42       ???
; 63eb 45 72    eor $72
; 63ed 92       ???
; 63ee 05 01    ora $01
; 63f0 7d 62 26 adc $2662,x
; 63f3 42       ???
; 63f4 52       ???
; 63f5 5f       ???
; 63f6 cf       ???
; 63f7 c1 50    cmp ($50,x)
; 63f9 59 4a 45 eor $454a,y
; 63fc 96 78    stx $78,y
; 63fe a7       ???
; 63ff b9 a0 99 lda $99a0,y
; 6402 72       ???
; 6403 90 5a    bcc $645f
; 6405 4c 82 6e jmp $6e82
; 6408 8d 9d 3f sta $3f9d
; 640b f9 0e 83 sbc $830e,y
; 640e 2c 0f 51 bit $510f
; 6411 2a       rol a
; 6412 84 6e    sty $6e
; 6414 14       ???
; 6415 00       brk 
; 6416 1c       ???
; 6417 33       ???
; 6418 a3       ???
; 6419 ac 20 00 ldy $0020
; 641c 01 12    ora ($12,x)
; 641e 11 00    ora ($00),y
; 6420 48       pha 
; 6421 67       ???
; 6422 40       rti 
; 6423 64       ???
; 6424 43       ???
; 6425 10 28    bpl $644f
; 6427 36 2e    rol $2e,x
; 6429 32       ???
; 642a 22       ???
; 642b 10 28    bpl $6455
; 642d 76 a1    ror $a1,x
; 642f 98       tya 
; 6430 85 30    sta $30
; 6432 18       clc 
; 6433 57       ???
; 6434 81 a8    sta ($a8,x)
; 6436 96 30    stx $30,y
; 6438 18       clc 
; 6439 d7       ???
; 643a f0 97    beq $63d3
; 643c 7e 28 28 ror $2828,x
; 643f 96 d2    stx $d2,y
; 6441 ba       tsx 
; 6442 7e 28 28 ror $2828,x
; 6445 16 33    asl $33,x
; 6447 9b       ???
; 6448 7e 28 28 ror $2828,x
; 644b 57       ???
; 644c 5f       ???
; 644d 86 7e    stx $7e
; 644f 28       plp 
; 6450 28       plp 
; 6451 d7       ???
; 6452 cf       ???
; 6453 76 86    ror $86,x
; 6455 20 18 cb jsr $cb18
; 6458 19 cc 86 ora $86cc,y
; 645b 20 18 4b jsr $4b18
; 645e 99 cc 6e sta $6ecc,y
; 6461 10 20    bpl $6483
; 6463 4b       ???
; 6464 99 cc 6e sta $6ecc,y
; 6467 10 20    bpl $6489
; 6469 cb       ???
; 646a 19 cc 6e ora $6ecc,y
; 646d 10 20    bpl $648f
; 646f 0a       asl a
; 6470 58       cli 
; 6471 cc 6e 10 cpy $106e
; 6474 20 8a d8 jsr $d88a
; 6477 cc 85 61 cpy $6185
; 647a 42       ???
; 647b 0c       ???
; 647c 2a       rol a
; 647d 3f       ???
; 647e 21 04    and ($04,x)
; 6480 22       ???
; 6481 61 43    adc ($43,x)
; 6483 08       php 
; 6484 27       ???
; 6485 50 31    bvc $64b8
; 6487 10 2e    bpl $64b7
; 6489 3e 24 20 rol $2024,x
; 648c 3a       ???
; 648d 2e 14 24 rol $2414
; 6490 3e 72 5c rol $5c72,x
; 6493 1c       ???
; 6494 32       ???
; 6495 71 5b    adc ($5b),y
; 6497 20 37 7f jsr $7f37
; 649a 7c       ???
; 649b 3c       ???
; 649c 3e 83 79 rol $7983,x
; 649f 2c 37 80 bit $8037
; 64a2 71 30    adc ($30),y
; 64a4 3e 81 73 rol $7381,x
; 64a7 28       plp 
; 64a8 37       ???
; 64a9 81 6e    sta ($6e,x)
; 64ab 28       plp 
; 64ac 3a       ???
; 64ad 64       ???
; 64ae 52       ???
; 64af 20 27 79 jsr $7927
; 64b2 8a       txa 
; 64b3 54       ???
; 64b4 42       ???
; 64b5 78       sei 
; 64b6 8a       txa 
; 64b7 58       cli 
; 64b8 47       ???
; 64b9 79 8e 54 adc $548e,y
; 64bc 3e 78 8e rol $8e78,x
; 64bf 60       rts 
; 64c0 48       pha 
; 64c1 76 92    ror $92,x
; 64c3 64       ???
; 64c4 48       pha 
; 64c5 76 96    ror $96,x
; 64c7 64       ???
; 64c8 53       ???
; 64c9 1f       ???
; 64ca 20 20 9f jsr $9f20
; 64cd b5 37    lda $37,x
; 64cf 2c 2a 35 bit $352a
; 64d2 37       ???
; 64d3 2c ea f5 bit $f5ea
; 64d6 37       ???
; 64d7 2c 6a 75 bit $756a
; 64da 37       ???
; 64db 2c 6a 5f bit $5f6a
; 64de 20 20 3f jsr $3f20
; 64e1 3f       ???
; 64e2 00       brk 
; 64e3 30 30    bmi $6515
; 64e5 81 91    sta ($91,x)
; 64e7 60       rts 
; 64e8 dc       ???
; 64e9 cd 41 1e cmp $1e41
; 64ec 5a       ???
; 64ed 4b       ???
; 64ee 41 32    eor ($32,x)
; 64f0 1c       ???
; 64f1 30 5a    bmi $654d
; 64f3 6b       ???
; 64f4 25 00    and $00
; 64f6 02       ???
; 64f7 12       ???
; 64f8 30 20    bmi $651a
; 64fa 24 c3    bit $c3
; 64fc af       ???
; 64fd 64       ???
; 64fe 74       ???
; 64ff 20 24 43 jsr $4324
; 6502 3f       ???
; 6503 85 a5    sta $a5
; 6505 40       rti 
; 6506 1c       ???
; 6507 5b       ???
; 6508 71 98    adc ($98),y
; 650a a6 40    ldx $40
; 650c 1c       ???
; 650d db       ???
; 650e f0 75    beq $6585
; 6510 44       ???
; 6511 10 2c    bpl $653f
; 6513 5b       ???
; 6514 4f       ???
; 6515 42       ???
; 6516 32       ???
; 6517 10 2c    bpl $6545
; 6519 9b       ???
; 651a c2       ???
; 651b a8       tay 
; 651c 71 12    adc ($12),y
; 651e 22       ???
; 651f cb       ???
; 6520 e2       ???
; 6521 66 3f    ror $3f
; 6523 12       ???
; 6524 22       ???
; 6525 4b       ???
; 6526 62       ???
; 6527 66 3f    ror $3f
; 6529 12       ???
; 652a 22       ???
; 652b 88       dey 
; 652c 9f       ???
; 652d 66 3f    ror $3f
; 652f 12       ???
; 6530 22       ???
; 6531 08       php 
; 6532 1f       ???
; 6533 66 52    ror $52
; 6535 6f       ???
; 6536 50 04    bvc $653c
; 6538 23       ???
; 6539 81 66    sta ($66,x)
; 653b 0c       ???
; 653c 27       ???
; 653d 3f       ???
; 653e 24 14    bit $14
; 6540 2f       ???
; 6541 2f       ???
; 6542 10 10    bpl $6554
; 6544 2f       ???
; 6545 60       rts 
; 6546 41 0c    eor ($0c,x)
; 6548 2b       ???
; 6549 50 3d    bvc $6588
; 654b 1c       ???
; 654c 2f       ???
; 654d 51 3a    eor ($3a),y
; 654f 18       clc 
; 6550 2f       ???
; 6551 62       ???
; 6552 4f       ???
; 6553 20 33 82 jsr $8233
; 6556 6b       ???
; 6557 1c       ???
; 6558 33       ???
; 6559 84 69    sty $69
; 655b 18       clc 
; 655c 33       ???
; 655d 73       ???
; 655e 54       ???
; 655f 14       ???
; 6560 23       ???
; 6561 42       ???
; 6562 4b       ???
; 6563 34       ???
; 6564 28       plp 
; 6565 3f       ???
; 6566 4f       ???
; 6567 3c       ???
; 6568 2c 3f 4b bit $4b3f
; 656b 3c       ???
; 656c 30 3f    bmi $65ad
; 656e 53       ???
; 656f 44       ???
; 6570 43       ???
; 6571 1f       ???
; 6572 20 28 a7 jsr $a728
; 6575 ab       ???
; 6576 3b       ???
; 6577 35 25    and $25,x
; 6579 2b       ???
; 657a 3b       ???
; 657b 35 45    and $45,x
; 657d 3f       ???
; 657e 00       brk 
; 657f 70 4f    bvs $65d0
; 6581 eb       ???
; 6582 3b       ???
; 6583 35 65    and $65,x
; 6585 5f       ???
; 6586 20 28 67 jsr $6728
; 6589 6b       ???
; 658a 3b       ???
; 658b 35 07    and $07,x
; 658d 25 37    and $37
; 658f bd c4 7b lda $7bc4,x
; 6592 61 22    adc ($22,x)
; 6594 b8       clv 
; 6595 b2       ???
; 6596 b2       ???
; 6597 96 14    stx $14,y
; 6599 2d 73 78 and $7873
; 659c 1e 01 03 asl $0301,x
; 659f 14       ???
; 65a0 12       ???
; 65a1 00       brk 
; 65a2 40       rti 
; 65a3 5f       ???
; 65a4 2f       ???
; 65a5 42       ???
; 65a6 72       ???
; 65a7 48       pha 
; 65a8 28       plp 
; 65a9 1f       ???
; 65aa 1f       ???
; 65ab 64       ???
; 65ac 64       ???
; 65ad 28       plp 
; 65ae 28       plp 
; 65af de df 65 dec $65df,x
; 65b2 64       ???
; 65b3 28       plp 
; 65b4 28       plp 
; 65b5 5e 6f 75 lsr $756f,x
; 65b8 84 48    sty $48
; 65ba 28       plp 
; 65bb 9f       ???
; 65bc af       ???
; 65bd 74       ???
; 65be 48       pha 
; 65bf 08       php 
; 65c0 14       ???
; 65c1 9e       ???
; 65c2 9f       ???
; 65c3 22       ???
; 65c4 15 08    ora $08,x
; 65c6 14       ???
; 65c7 1e 1f 22 asl $221f,x
; 65ca 19 0b 1f ora $1f0b,y
; 65cd 29 1e    and #$1e
; 65cf 22       ???
; 65d0 19 0b 1f ora $1f0b,y
; 65d3 a9 9e    lda #$9e
; 65d5 22       ???
; 65d6 25 18    and $18
; 65d8 14       ???
; 65d9 e4 d4    cpx $d4
; 65db 00       brk 
; 65dc 14       ???
; 65dd 18       clc 
; 65de 14       ???
; 65df 64       ???
; 65e0 54       ???
; 65e1 00       brk 
; 65e2 18       clc 
; 65e3 1f       ???
; 65e4 1b       ???
; 65e5 08       php 
; 65e6 f4       ???
; 65e7 00       brk 
; 65e8 10 17    bpl $6601
; 65ea 1b       ???
; 65eb 04       ???
; 65ec f0 00    beq $65ee
; 65ee 10 17    bpl $6607
; 65f0 1b       ???
; 65f1 84 70    sty $70
; 65f3 00       brk 
; 65f4 18       clc 
; 65f5 1f       ???
; 65f6 1b       ???
; 65f7 88       dey 
; 65f8 74       ???
; 65f9 00       brk 
; 65fa 08       php 
; 65fb 0c       ???
; 65fc 24 cd    bit $cd
; 65fe f1 88    sbc ($88),y
; 6600 4c 0c 24 jmp $240c
; 6603 4d 71 88 eor $8871
; 6606 4c 0c 24 jmp $240c
; 6609 8e b2 88 stx $88b2
; 660c 4c 0c 24 jmp $240c
; 660f 0e 32 88 asl $8832
; 6612 64       ???
; 6613 24 24    bit $24
; 6615 c7       ???
; 6616 eb       ???
; 6617 88       dey 
; 6618 64       ???
; 6619 24 24    bit $24
; 661b 47       ???
; 661c 6b       ???
; 661d 88       dey 
; 661e 68       pla 
; 661f 28       plp 
; 6620 24 87    bit $87
; 6622 ab       ???
; 6623 88       dey 
; 6624 68       pla 
; 6625 28       plp 
; 6626 24 07    bit $07
; 6628 2b       ???
; 6629 88       dey 
; 662a 6a       ror a
; 662b 26 20    rol $20
; 662d c5 e9    cmp $e9
; 662f 88       dey 
; 6630 6a       ror a
; 6631 26 20    rol $20
; 6633 45 69    eor $69
; 6635 88       dey 
; 6636 63       ???
; 6637 3f       ???
; 6638 20 04 23 jsr $2304
; 663b 4f       ???
; 663c 30 10    bmi $664e
; 663e 2f       ???
; 663f 5f       ???
; 6640 44       ???
; 6641 14       ???
; 6642 2e 60 46 rol $4660
; 6645 0c       ???
; 6646 26 5f    rol $5f
; 6648 49 14    eor #$14
; 664a 2a       rol a
; 664b 61 4f    adc ($4f,x)
; 664d 1c       ???
; 664e 1e 1f 25 asl $251f,x
; 6651 2c 24 1d bit $1d24
; 6654 29 34    and #$34
; 6656 29 1e    and #$1e
; 6658 2d 3c 2c and $2c3c
; 665b 1d 25 34 ora $3425,x
; 665e 34       ???
; 665f 14       ???
; 6660 24 50    bit $50
; 6662 3c       ???
; 6663 10 24    bpl $6689
; 6665 54       ???
; 6666 40       rti 
; 6667 10 28    bpl $6691
; 6669 5c       ???
; 666a 48       pha 
; 666b 14       ???
; 666c 28       plp 
; 666d 60       rts 
; 666e 46 0e    lsr $0e
; 6670 34       ???
; 6671 6c 46 0e jmp ($0e46)
; 6674 2c 5c 3d bit $3d5c
; 6677 51 80    eor ($80),y
; 6679 7c       ???
; 667a 4e 52 88 lsr $8852
; 667d 8c 54 50 sty $5054
; 6680 80       ???
; 6681 84 54    sty $54
; 6683 50 84    bvc $6609
; 6685 84 4b    sty $4b
; 6687 4b       ???
; 6688 94 a4    sty $a4,x
; 668a 59 49 94 eor $9449,y
; 668d b0 65    bcs $66f4
; 668f 49 98    eor #$98
; 6691 b4 67    ldy $67,x
; 6693 4b       ???
; 6694 90 a4    bcc $663a
; 6696 5d 49 90 eor $9049,x
; 6699 a8       tay 
; 669a 61 49    adc ($49,x)
; 669c 9c       ???
; 669d b4 7a    ldy $7a,x
; 669f 3f       ???
; 66a0 21 08    and ($08,x)
; 66a2 26 4f    rol $4f
; 66a4 31 0c    and ($0c),y
; 66a6 6a       ror a
; 66a7 5e 18 1a lsr $1a18,x
; 66aa 20 1e 18 jsr $181e
; 66ad 1a       ???
; 66ae a0 be    ldy #$be
; 66b0 60       rts 
; 66b1 50 2e    bvc $66e1
; 66b3 3e 60 50 rol $5060,x
; 66b6 4e 3e 00 lsr $003e
; 66b9 7f       ???
; 66ba 80       ???
; 66bb 11 1e    ora ($1e),y
; 66bd 88       dey 
; 66be 48       pha 
; 66bf 27       ???
; 66c0 59 12 78 eor $7812,y
; 66c3 7b       ???
; 66c4 79 64 18 adc $1864,y
; 66c7 2c 64 6e bit $6e64
; 66ca 1e 00 01 asl $0100,x
; 66cd 11 10    ora ($10),y
; 66cf 00       brk 
; 66d0 60       rts 
; 66d1 7f       ???
; 66d2 20 24 23 jsr $2324
; 66d5 12       ???
; 66d6 42       ???
; 66d7 6f       ???
; 66d8 42       ???
; 66d9 48       pha 
; 66da 45 12    eor $12
; 66dc 42       ???
; 66dd af       ???
; 66de 91 57    sta ($57),y
; 66e0 9f       ???
; 66e1 5a       ???
; 66e2 03       ???
; 66e3 42       ???
; 66e4 40       rti 
; 66e5 45 9e    eor $9e
; 66e7 5a       ???
; 66e8 03       ???
; 66e9 c2       ???
; 66ea e2       ???
; 66eb 78       sei 
; 66ec af       ???
; 66ed 5a       ???
; 66ee 57       ???
; 66ef 75 1f    adc $1f,x
; 66f1 12       ???
; 66f2 6b       ???
; 66f3 5a       ???
; 66f4 57       ???
; 66f5 f5 c1    sbc $c1,x
; 66f7 56 33    lsr $33,x
; 66f9 05 3a    ora $3a
; 66fb 3e 09 33 rol $3309,x
; 66fe 33       ???
; 66ff 07       ???
; 6700 2d 2c 06 and $062c
; 6703 33       ???
; 6704 45 19    eor $19
; 6706 1a       ???
; 6707 9c       ???
; 6708 bc 66 45 ldy $4566,x
; 670b 19 1a 1c ora $1c1a,y
; 670e 09 00    ora #$00
; 6710 12       ???
; 6711 1d 32 4f ora $4f32,x
; 6714 6c 88 56 jmp ($5688)
; 6717 1d 32 8f ora $8f32,x
; 671a ac 88 68 ldy $6888
; 671d 24 1e    bit $1e
; 671f 46 6c    lsr $6c
; 6721 88       dey 
; 6722 56 1d    lsr $1d,x
; 6724 32       ???
; 6725 cf       ???
; 6726 fd aa 67 sbc $67aa,x
; 6729 1d 32 0f ora $0f32,x
; 672c 3d aa 79 and $79aa,x
; 672f 24 1e    bit $1e
; 6731 c6 fd    dec $fd
; 6733 aa       tax 
; 6734 74       ???
; 6735 22       ???
; 6736 03       ???
; 6737 04       ???
; 6738 23       ???
; 6739 31 12    and ($12),y
; 673b 08       php 
; 673c 27       ???
; 673d 20 01 0c jsr $0c01
; 6740 2b       ???
; 6741 42       ???
; 6742 23       ???
; 6743 10 2f    bpl $6774
; 6745 54       ???
; 6746 39 14 2f and $2f14,y
; 6749 44       ???
; 674a 35 18    and $18,x
; 674c 27       ???
; 674d 33       ???
; 674e 1c       ???
; 674f 14       ???
; 6750 2b       ???
; 6751 23       ???
; 6752 10 10    bpl $6764
; 6754 22       ???
; 6755 1f       ???
; 6756 0d 20 32 ora $3220
; 6759 41 33    eor ($33,x)
; 675b 28       plp 
; 675c 20 4d 49 jsr $494d
; 675f 0c       ???
; 6760 11 09    ora ($09),y
; 6762 1c       ???
; 6763 44       ???
; 6764 2e 06 20 rol $2006
; 6767 48       pha 
; 6768 31 3c    and ($3c),y
; 676a 4f       ???
; 676b 40       rti 
; 676c 2a       rol a
; 676d 39 53 44 and $4453,y
; 6770 2c 4c 70 bit $704c
; 6773 60       rts 
; 6774 3c       ???
; 6775 4c 78 64 jmp $6478
; 6778 37       ???
; 6779 4b       ???
; 677a 74       ???
; 677b 5c       ???
; 677c 33       ???
; 677d 5c       ???
; 677e 8d 74 44 sta $4474
; 6781 5d 91 7c eor $7c91,x
; 6784 48       pha 
; 6785 5d 95 78 eor $7895,x
; 6788 57       ???
; 6789 22       ???
; 678a 1b       ???
; 678b 1b       ???
; 678c 62       ???
; 678d 62       ???
; 678e 1b       ???
; 678f 1b       ???
; 6790 e2       ???
; 6791 e2       ???
; 6792 1b       ???
; 6793 1b       ???
; 6794 a2 a2    ldx #$a2
; 6796 1b       ???
; 6797 1b       ???
; 6798 42       ???
; 6799 65 26    adc $26
; 679b 4d 0c e5 eor $e50c
; 679e 26 4d    rol $4d
; 67a0 4d c4 cd eor $cdc4
; 67a3 89       ???
; 67a4 74       ???
; 67a5 59 65 16 eor $1665,y
; 67a8 82       ???
; 67a9 89       ???
; 67aa 45 28    eor $28
; 67ac 3c       ???
; 67ad 50 69    bvc $6818
; 67af 6d 18 00 adc $0018
; 67b2 02       ???
; 67b3 12       ???
; 67b4 22       ???
; 67b5 12       ???
; 67b6 28       plp 
; 67b7 c7       ???
; 67b8 a0 bd    ldy #$bd
; 67ba ce 12 28 dec $2812
; 67bd 47       ???
; 67be 20 24 41 jsr $4124
; 67c1 1e 18 57 asl $5718,x
; 67c4 62       ???
; 67c5 68       pla 
; 67c6 63       ???
; 67c7 1e 28 67 asl $6728,x
; 67ca 84 ab    sty $ab
; 67cc 78       sei 
; 67cd 19 2f a7 ora $a72f,y
; 67d0 d5 d4    cmp $d4,x
; 67d2 90 19    bcc $67ed
; 67d4 2f       ???
; 67d5 27       ???
; 67d6 77       ???
; 67d7 26 cc    rol $cc
; 67d9 1e 28 e7 asl $e728,x
; 67dc 48       pha 
; 67dd 33       ???
; 67de c8       iny 
; 67df 1e 18 d7 asl $d718,x
; 67e2 59 56 ce eor $ce56,y
; 67e5 19 2f e7 ora $e72f,y
; 67e8 37       ???
; 67e9 15 af    ora $af,x
; 67eb 19 2f 67 ora $672f,y
; 67ee 85 c3    sta $c3
; 67f0 8f       ???
; 67f1 19 14 ac ora $ac14,y
; 67f4 a8       tay 
; 67f5 c6 cf    dec $cf
; 67f7 19 14 2c ora $2c14,y
; 67fa 21 4f    and ($4f,x)
; 67fc 5f       ???
; 67fd 19 14 ec ora $ec14,y
; 6800 f9 e8 e0 sbc $e0e8,y
; 6803 19 14 6c ora $6c14,y
; 6806 72       ???
; 6807 71 69    adc ($69),y
; 6809 0e 20 a2 asl $a220
; 680c 85 00    sta $00
; 680e 0b       ???
; 680f 0e 20 22 asl $2220
; 6812 05 00    ora $00
; 6814 0b       ???
; 6815 0f       ???
; 6816 1c       ???
; 6817 1c       ???
; 6818 04       ???
; 6819 00       brk 
; 681a 0b       ???
; 681b 0f       ???
; 681c 1c       ???
; 681d 9c       ???
; 681e 84 00    sty $00
; 6820 1f       ???
; 6821 20 01 04 jsr $0401
; 6824 0b       ???
; 6825 2a       rol a
; 6826 27       ???
; 6827 0c       ???
; 6828 27       ???
; 6829 64       ???
; 682a 4d 14 2b eor $2b14
; 682d 75 62    adc $62,x
; 682f 1c       ???
; 6830 2f       ???
; 6831 9d 8e 24 sta $248e,x
; 6834 33       ???
; 6835 a9 9e    lda #$9e
; 6837 2c 37 b9 bit $b937
; 683a b2       ???
; 683b 34       ???
; 683c 23       ???
; 683d c3       ???
; 683e d8       cld 
; 683f 1c       ???
; 6840 1f       ???
; 6841 65 52    adc $52
; 6843 30 43    bmi $6888
; 6845 9c       ???
; 6846 a1 44    lda ($44,x)
; 6848 3f       ???
; 6849 a8       tay 
; 684a a9 38    lda #$38
; 684c 37       ???
; 684d 2a       rol a
; 684e 0b       ???
; 684f 28       plp 
; 6850 47       ???
; 6851 ba       tsx 
; 6852 b7       ???
; 6853 44       ???
; 6854 47       ???
; 6855 21 06    and ($06,x)
; 6857 30 4b    bmi $68a4
; 6859 43       ???
; 685a 2c 34 4b bit $4b34
; 685d 3b       ???
; 685e 1c       ???
; 685f 30 4f    bmi $68b0
; 6861 cb       ???
; 6862 c8       iny 
; 6863 4c 4f 32 jmp $324f
; 6866 17       ???
; 6867 38       sec 
; 6868 53       ???
; 6869 54       ???
; 686a 3d 3c 53 and $533c,x
; 686d 2c 35 54 bit $5435
; 6870 4b       ???
; 6871 3d 4e 64 and $644e,x
; 6874 53       ???
; 6875 bc bd 48 ldy $48bd,x
; 6878 47       ???
; 6879 6c 71 50 jmp ($5071)
; 687c 4b       ???
; 687d cd c2 44 cmp $44c2
; 6880 4f       ???
; 6881 7d 6e 44 adc $446e,x
; 6884 39 05 38 and $3805,y
; 6887 74       ???
; 6888 3f       ???
; 6889 03       ???
; 688a 3c       ???
; 688b 7c       ???
; 688c 44       ???
; 688d 04       ???
; 688e 40       rti 
; 688f 84 47    sty $47
; 6891 03       ???
; 6892 44       ???
; 6893 7c       ???
; 6894 57       ???
; 6895 1f       ???
; 6896 27       ???
; 6897 31 69    and ($69),y
; 6899 5f       ???
; 689a 27       ???
; 689b 31 29    and ($29),y
; 689d 64       ???
; 689e 77       ???
; 689f 3f       ???
; 68a0 6c a4 77 jmp ($77a4)
; 68a3 3f       ???
; 68a4 2c 3d 52 bit $523d
; 68a7 34       ???
; 68a8 5f       ???
; 68a9 7d 52 34 adc $3452,x
; 68ac 3f       ???
; 68ad 3f       ???
; 68ae 00       brk 
; 68af a0 df    ldy #$df
; 68b1 3f       ???
; 68b2 00       brk 
; 68b3 a0 df    ldy #$df
; 68b5 3f       ???
; 68b6 00       brk 
; 68b7 a0 3f    ldy #$3f
; 68b9 bd 52 34 lda $3452,x
; 68bc df       ???
; 68bd fd 52 34 sbc $3452,x
; 68c0 9f       ???
; 68c1 e4 77    cpx $77
; 68c3 3f       ???
; 68c4 ec 24 77 cpx $7724
; 68c7 3f       ???
; 68c8 2c 1f 1c bit $1c1f
; 68cb 1c       ???
; 68cc 5f       ???
; 68cd 5f       ???
; 68ce 1c       ???
; 68cf 1c       ???
; 68d0 00       brk 
; 68d1 49 6f    eor #$6f
; 68d3 82       ???
; 68d4 fc       ???
; 68d5 e5 45    sbc $45
; 68d7 1a       ???
; 68d8 62       ???
; 68d9 59 48 37 eor $3748,y
; 68dc 24 36    bit $36
; 68de 58       cli 
; 68df 64       ???
; 68e0 1e 00 03 asl $0300,x
; 68e3 13       ???
; 68e4 1a       ???
; 68e5 0e 33 0e asl $0e33
; 68e8 e2       ???
; 68e9 48       pha 
; 68ea 4f       ???
; 68eb 0e 33 8e asl $8e33
; 68ee 60       rts 
; 68ef 24 33    bit $33
; 68f1 18       clc 
; 68f2 1f       ???
; 68f3 d6 c4    dec $c4,x
; 68f5 6c 77 18 jmp ($1877)
; 68f8 1f       ???
; 68f9 56 40    lsr $40,x
; 68fb 79 ba 42 adc $42ba,y
; 68fe 03       ???
; 68ff c2       ???
; 6900 04       ???
; 6901 ab       ???
; 6902 a8       tay 
; 6903 42       ???
; 6904 03       ???
; 6905 42       ???
; 6906 51 9a    eor ($9a),y
; 6908 9c       ???
; 6909 22       ???
; 690a 25 16    and $16
; 690c 33       ???
; 690d 9b       ???
; 690e 7b       ???
; 690f 22       ???
; 6910 25 96    and $96
; 6912 a2 9b    ldx #$9b
; 6914 80       ???
; 6915 0e 27 f1 asl $f127
; 6918 03       ???
; 6919 66 3b    ror $3b
; 691b 0e 27 72 asl $7227
; 691e 84 66    sty $66
; 6920 3b       ???
; 6921 15 1d    ora $1d,x
; 6923 00       brk 
; 6924 23       ???
; 6925 66 3b    ror $3b
; 6927 15 1d    ora $1d,x
; 6929 81 a4    sta ($a4,x)
; 692b 66 52    ror $52
; 692d 22       ???
; 692e 03       ???
; 692f 04       ???
; 6930 23       ???
; 6931 31 16    and ($16),y
; 6933 18       clc 
; 6934 33       ???
; 6935 37       ???
; 6936 2c 20 2b bit $2b20
; 6939 26 13    rol $13
; 693b 14       ???
; 693c 27       ???
; 693d 75 5e    adc $5e,x
; 693f 18       clc 
; 6940 2f       ???
; 6941 64       ???
; 6942 55 10    eor $10,x
; 6944 1f       ???
; 6945 47       ???
; 6946 3c       ???
; 6947 30 3b    bmi $6984
; 6949 56 53    lsr $53,x
; 694b 34       ???
; 694c 37       ???
; 694d 65 5e    adc $5e
; 694f 28       plp 
; 6950 2d 22 05 and $0522
; 6953 08       php 
; 6954 26 1f    rol $1f
; 6956 05 10    ora $10
; 6958 29 51    and #$51
; 695a 34       ???
; 695b 18       clc 
; 695c 36 41    rol $41,x
; 695e 27       ???
; 695f 20 30 7b jsr $7b30
; 6962 6f       ???
; 6963 20 2c 8c jsr $8c2c
; 6966 84 28    sty $28
; 6968 2c 43 53 bit $5343
; 696b 48       pha 
; 696c 39 44 57 and $5744,y
; 696f 50 4b    bvc $69bc
; 6971 1f       ???
; 6972 1f       ???
; 6973 24 24    bit $24
; 6975 23       ???
; 6976 31 35    and ($35),y
; 6978 67       ???
; 6979 78       sei 
; 697a 85 7f    sta $7f
; 697c 72       ???
; 697d 5f       ???
; 697e 54       ???
; 697f 60       rts 
; 6980 eb       ???
; 6981 f8       sed 
; 6982 85 7f    sta $7f
; 6984 b2       ???
; 6985 a3       ???
; 6986 31 35    and ($35),y
; 6988 c7       ???
; 6989 17       ???
; 698a 68       pla 
; 698b e6 15    inc $15
; 698d 3f       ???
; 698e 00       brk 
; 698f bb       ???
; 6990 fa       ???
; 6991 97       ???
; 6992 68       pla 
; 6993 e6 d9    inc $d9
; 6995 4c 6f 7c jmp $7c6f
; 6998 f4       ???
; 6999 e7       ???
; 699a 71 42    adc ($42),y
; 699c 5c       ???
; 699d 54       ???
; 699e 5d 4b 28 eor $284b,x
; 69a1 3b       ???
; 69a2 6d 74 1a adc $1a74
; 69a5 00       brk 
; 69a6 02       ???
; 69a7 14       ???
; 69a8 24 13    bit $13
; 69aa 33       ???
; 69ab 11 e0    ora ($e0),y
; 69ad 24 35    bit $35
; 69af 13       ???
; 69b0 33       ???
; 69b1 91 60    sta ($60),y
; 69b3 46 87    lsr $87
; 69b5 42       ???
; 69b6 07       ???
; 69b7 a6 c2    ldx $c2
; 69b9 ab       ???
; 69ba ca       dex 
; 69bb 42       ???
; 69bc 07       ???
; 69bd 26 64    rol $64
; 69bf de b9 2c dec $2cb9,x
; 69c2 32       ???
; 69c3 e5 e5    sbc $e5
; 69c5 9e       ???
; 69c6 98       tya 
; 69c7 2c 32 65 bit $6532
; 69ca 85 bf    sta $bf
; 69cc af       ???
; 69cd 42       ???
; 69ce 32       ???
; 69cf 25 12    and $12
; 69d1 8b       ???
; 69d2 ae 42 32 ldx $3242
; 69d5 a5 94    lda $94
; 69d7 8e 79 0c stx $0c79
; 69da 12       ???
; 69db 3a       ???
; 69dc 36 48    rol $48,x
; 69de 46 01    lsr $01
; 69e0 33       ???
; 69e1 74       ???
; 69e2 43       ???
; 69e3 12       ???
; 69e4 11 01    ora ($01),y
; 69e6 3d 9b 60 and $609b,x
; 69e9 12       ???
; 69ea 30 20    bmi $6a0c
; 69ec 05 04    ora $04
; 69ee 1f       ???
; 69ef 42       ???
; 69f0 23       ???
; 69f1 08       php 
; 69f2 27       ???
; 69f3 57       ???
; 69f4 40       rti 
; 69f5 20 37 36 jsr $3637
; 69f8 2f       ???
; 69f9 34       ???
; 69fa 3b       ???
; 69fb 78       sei 
; 69fc 75 28    adc $28,x
; 69fe 2b       ???
; 69ff 64       ???
; 6a00 51 10    eor ($10),y
; 6a02 23       ???
; 6a03 47       ???
; 6a04 30 18    bmi $6a1e
; 6a06 2f       ???
; 6a07 86 77    stx $77
; 6a09 24 33    bit $33
; 6a0b 68       pla 
; 6a0c 5d 20 20 eor $2020,x
; 6a0f 16 02    asl $02,x
; 6a11 20 34 18 jsr $1834
; 6a14 24 24    bit $24
; 6a16 14       ???
; 6a17 36 36    rol $36,x
; 6a19 30 30    bmi $6a4b
; 6a1b 56 66    lsr $66,x
; 6a1d 34       ???
; 6a1e 33       ???
; 6a1f 97       ???
; 6a20 88       dey 
; 6a21 28       plp 
; 6a22 37       ???
; 6a23 98       tya 
; 6a24 8d 30 30 sta $3030
; 6a27 27       ???
; 6a28 13       ???
; 6a29 18       clc 
; 6a2a 2c 29 19 bit $1929
; 6a2d 20 1e 03 jsr $031e
; 6a30 29 4c    and #$4c
; 6a32 43       ???
; 6a33 1f       ???
; 6a34 29 33    and #$33
; 6a36 69 5f    adc #$5f
; 6a38 1b       ???
; 6a39 1e a2 a7 asl $a7a2,x
; 6a3c 36 36    rol $36,x
; 6a3e e7       ???
; 6a3f eb       ???
; 6a40 45 45    eor $45
; 6a42 2b       ???
; 6a43 27       ???
; 6a44 36 36    rol $36,x
; 6a46 67       ???
; 6a47 6b       ???
; 6a48 45 45    eor $45
; 6a4a 2b       ???
; 6a4b 1f       ???
; 6a4c 31 31    and ($31),y
; 6a4e 3f       ???
; 6a4f 3f       ???
; 6a50 00       brk 
; 6a51 9a       txs 
; 6a52 59 38 e8 eor $e838,y
; 6a55 ad 7d b8 lda $b87d
; 6a58 e8       inx 
; 6a59 ad 3e 49 lda $493e
; 6a5c 6f       ???
; 6a5d 76 e0    ror $e0,x
; 6a5f dd 4d 12 cmp $124d,x
; 6a62 4e 4c 10 lsr $104c
; 6a65 00       brk 
; 6a66 20 33 31 jsr $3133
; 6a69 35 17    and $17,x
; 6a6b 00       brk 
; 6a6c 03       ???
; 6a6d 0b       ???
; 6a6e 12       ???
; 6a6f 14       ???
; 6a70 2d 82 61 and $6182
; 6a73 79 81 14 adc $1481,y
; 6a76 2d 02 e2 and $e202
; 6a79 7a       ???
; 6a7a 7c       ???
; 6a7b 0b       ???
; 6a7c 15 2e    ora $2e,x
; 6a7e 20 25 29 jsr $2925
; 6a81 0b       ???
; 6a82 15 ae    ora $ae,x
; 6a84 a0 36    ldy #$36
; 6a86 44       ???
; 6a87 19 23 78 ora $7823,y
; 6a8a 83       ???
; 6a8b 9b       ???
; 6a8c 86 19    stx $19
; 6a8e 23       ???
; 6a8f f8       sed 
; 6a90 14       ???
; 6a91 ac 91 24 ldy $2491
; 6a94 23       ???
; 6a95 98       tya 
; 6a96 c5 bd    cmp $bd
; 6a98 91 24    sta ($24),y
; 6a9a 23       ???
; 6a9b 18       clc 
; 6a9c 55 cd    eor $cd,x
; 6a9e 7f       ???
; 6a9f 16 27    asl $27,x
; 6aa1 58       cli 
; 6aa2 53       ???
; 6aa3 7a       ???
; 6aa4 6e 16 27 ror $2716
; 6aa7 d8       cld 
; 6aa8 d4       ???
; 6aa9 7b       ???
; 6aaa 85 26    sta $26
; 6aac 07       ???
; 6aad 04       ???
; 6aae 23       ???
; 6aaf 56 3b    lsr $3b,x
; 6ab1 18       clc 
; 6ab2 33       ???
; 6ab3 76 6b    ror $6b,x
; 6ab5 30 3b    bmi $6af2
; 6ab7 86 83    stx $83
; 6ab9 34       ???
; 6aba 37       ???
; 6abb 66 5f    ror $5f
; 6abd 28       plp 
; 6abe 2f       ???
; 6abf 46 37    lsr $37
; 6ac1 10 1f    bpl $6ae2
; 6ac3 21 02    and ($02,x)
; 6ac5 08       php 
; 6ac6 27       ???
; 6ac7 22       ???
; 6ac8 07       ???
; 6ac9 10 2b    bpl $6af6
; 6acb 43       ???
; 6acc 34       ???
; 6acd 18       clc 
; 6ace 27       ???
; 6acf 54       ???
; 6ad0 49 20    eor #$20
; 6ad2 2b       ???
; 6ad3 33       ???
; 6ad4 1c       ???
; 6ad5 28       plp 
; 6ad6 3f       ???
; 6ad7 65 66    adc $66
; 6ad9 38       sec 
; 6ada 37       ???
; 6adb 34       ???
; 6adc 21 30    and ($30,x)
; 6ade 43       ???
; 6adf 75 7a    adc $7a,x
; 6ae1 40       rti 
; 6ae2 3b       ???
; 6ae3 20 09 14 jsr $1409
; 6ae6 2b       ???
; 6ae7 35 36    and $36,x
; 6ae9 44       ???
; 6aea 43       ???
; 6aeb 1f       ???
; 6aec 58       cli 
; 6aed 9e       ???
; 6aee 65 1f    adc $1f
; 6af0 45 53    eor $53
; 6af2 2d 65 88 and $8865
; 6af5 65 c2    adc $c2
; 6af7 e5 88    sbc $88
; 6af9 65 42    adc $42
; 6afb 5f       ???
; 6afc 71 3f    adc ($3f),y
; 6afe ad df 71 lda $71df
; 6b01 3f       ???
; 6b02 4d 3f 00 eor $003f
; 6b05 c8       iny 
; 6b06 27       ???
; 6b07 5f       ???
; 6b08 50 50    bvc $6b5a
; 6b0a 01 42    ora ($42,x)
; 6b0c 64       ???
; 6b0d df       ???
; 6b0e 10 f1    bpl $6b01
; 6b10 f1 7e    sbc ($7e),y
; 6b12 d2       ???
; 6b13 ce d5 af dec $afd5
; 6b16 34       ???
; 6b17 66 c8    ror $c8
; 6b19 b2       ???
; 6b1a 1c       ???
; 6b1b 01 02    ora ($02,x)
; 6b1d 13       ???
; 6b1e 32       ???
; 6b1f 20 4c 6b jsr $6b4c
; 6b22 1e fe 1f asl $1ffe,x
; 6b25 20 4c eb jsr $eb4c
; 6b28 9e       ???
; 6b29 fe ff 1a inc $1aff,x
; 6b2c 32       ???
; 6b2d 37       ???
; 6b2e 1e fe 77 asl $77fe,x
; 6b31 7b       ???
; 6b32 0b       ???
; 6b33 07       ???
; 6b34 72       ???
; 6b35 1d 22 7b ora $7b22,x
; 6b38 0b       ???
; 6b39 87       ???
; 6b3a 03       ???
; 6b3b 50 24    bvc $6b61
; 6b3d 68       pla 
; 6b3e 38       sec 
; 6b3f e7       ???
; 6b40 be fe 57 ldx $57fe,y
; 6b43 68       pla 
; 6b44 38       sec 
; 6b45 67       ???
; 6b46 3e fe 7f rol $7ffe,x
; 6b49 88       dey 
; 6b4a 30 a7    bmi $6af3
; 6b4c 17       ???
; 6b4d 64       ???
; 6b4e 4c 88 30 jmp $3088
; 6b51 27       ???
; 6b52 96 41    stx $41,y
; 6b54 aa       tax 
; 6b55 1a       ???
; 6b56 42       ???
; 6b57 67       ???
; 6b58 a4 fe    ldy $fe
; 6b5a b9 38 40 lda $4038,y
; 6b5d 27       ???
; 6b5e a8       tay 
; 6b5f 64       ???
; 6b60 db       ???
; 6b61 38       sec 
; 6b62 40       rti 
; 6b63 a7       ???
; 6b64 38       sec 
; 6b65 85 f0    sta $f0
; 6b67 2c 30 dc bit $dc30
; 6b6a 4d 32 a1 eor $a132
; 6b6d 14       ???
; 6b6e 34       ???
; 6b6f dc       ???
; 6b70 4d 32 a1 eor $a132
; 6b73 14       ???
; 6b74 34       ???
; 6b75 5c       ???
; 6b76 cd 32 bd cmp $bd32
; 6b79 2c 30 5c bit $5c30
; 6b7c cd 32 bd cmp $bd32
; 6b7f 30 34    bmi $6bb5
; 6b81 9c       ???
; 6b82 0d 32 a1 ora $a132
; 6b85 18       clc 
; 6b86 38       sec 
; 6b87 9c       ???
; 6b88 0d 32 a1 ora $a132
; 6b8b 18       clc 
; 6b8c 38       sec 
; 6b8d 1c       ???
; 6b8e 8d 32 bd sta $bd32
; 6b91 30 34    bmi $6bc7
; 6b93 1c       ???
; 6b94 8d 32 99 sta $9932
; 6b97 00       brk 
; 6b98 4c 52 b6 jmp $b652
; 6b9b 6b       ???
; 6b9c bb       ???
; 6b9d 00       brk 
; 6b9e 5a       ???
; 6b9f 79 cf 6b adc $6bcf,y
; 6ba2 0b       ???
; 6ba3 56 2e    lsr $2e,x
; 6ba5 10 81    bpl $6b28
; 6ba7 32       ???
; 6ba8 e9 56    sbc #$56
; 6baa 2e d0 41 rol $41d0
; 6bad 32       ???
; 6bae f1 58    sbc ($58),y
; 6bb0 28       plp 
; 6bb1 ce 3f 32 dec $323f
; 6bb4 e9 56    sbc #$56
; 6bb6 2e 50 c1 rol $c150
; 6bb9 32       ???
; 6bba f1 58    sbc ($58),y
; 6bbc 28       plp 
; 6bbd 4e bf 32 lsr $32bf
; 6bc0 e9 56    sbc #$56
; 6bc2 2e 90 01 rol $0190
; 6bc5 32       ???
; 6bc6 b8       clv 
; 6bc7 cf       ???
; 6bc8 b0 04    bcs $6bce
; 6bca 23       ???
; 6bcb e3       ???
; 6bcc c4 10    cpy $10
; 6bce 2f       ???
; 6bcf c2       ???
; 6bd0 a7       ???
; 6bd1 10 2b    bpl $6bfe
; 6bd3 c6 b3    dec $b3
; 6bd5 2c 3f e7 bit $e73f
; 6bd8 d8       cld 
; 6bd9 2c 3b b7 bit $b73b
; 6bdc b0 34    bcs $6c12
; 6bde 3b       ???
; 6bdf b5 ae    lda $ae,x
; 6be1 3c       ???
; 6be2 43       ???
; 6be3 b4 a9    ldy $a9,x
; 6be5 38       sec 
; 6be6 43       ???
; 6be7 b6 ab    ldx $ab,y
; 6be9 34       ???
; 6bea 3f       ???
; 6beb 70 59    bvs $6c46
; 6bed 1c       ???
; 6bee 33       ???
; 6bef 81 6a    sta ($6a,x)
; 6bf1 20 37 92 jsr $9237
; 6bf4 7f       ???
; 6bf5 20 33 a3 jsr $a333
; 6bf8 94 28    sty $28,x
; 6bfa 37       ???
; 6bfb 2f       ???
; 6bfc 14       ???
; 6bfd 0c       ???
; 6bfe 27       ???
; 6bff 3f       ???
; 6c00 20 08 27 jsr $2708
; 6c03 c8       iny 
; 6c04 c9 48    cmp #$48
; 6c06 47       ???
; 6c07 d8       cld 
; 6c08 e1 54    sbc ($54,x)
; 6c0a 4b       ???
; 6c0b e8       inx 
; 6c0c e5 48    sbc $48
; 6c0e 4b       ???
; 6c0f d9 be 2c cmp $2cbe,y
; 6c12 47       ???
; 6c13 ea       nop 
; 6c14 cb       ???
; 6c15 2c 49 4e bit $4e49
; 6c18 35 18    and $18,x
; 6c1a 31 5f    and ($5f),y
; 6c1c 42       ???
; 6c1d 18       clc 
; 6c1e 1e b6 00 asl $00b6,x
; 6c21 a4 68    ldy $68
; 6c23 ad c9 64 lda $64c9
; 6c26 48       pha 
; 6c27 ad e1 94 lda $94e1
; 6c2a 60       rts 
; 6c2b ad d1 74 lda $74d1
; 6c2e 50 ad    bvc $6bdd
; 6c30 d9 84 57 cmp $5784,y
; 6c33 ac d5 7c ldy $7cd5
; 6c36 51 aa    eor ($aa),y
; 6c38 d1 7c    cmp ($7c),y
; 6c3a 57       ???
; 6c3b ac cd 7c ldy $7ccd
; 6c3e 5b       ???
; 6c3f ac c9 7c ldy $7cc9
; 6c42 6a       ror a
; 6c43 83       ???
; 6c44 6d 2c 2a adc $2a2c
; 6c47 9f       ???
; 6c48 f1 b8    sbc ($b8),y
; 6c4a 66 9f    ror $9f
; 6c4c f5 bc    sbc $bc,x
; 6c4e 68       pla 
; 6c4f a1 f1    lda ($f1,x)
; 6c51 b4 62    ldy $62,x
; 6c53 9f       ???
; 6c54 fd cc 6e sbc $6ecc,x
; 6c57 9f       ???
; 6c58 01 d4    ora ($d4,x)
; 6c5a 74       ???
; 6c5b a1 fd    lda ($fd,x)
; 6c5d d0 8b    bne $6bea
; 6c5f 1f       ???
; 6c60 3e 5d be rol $be5d,x
; 6c63 b1 49    lda ($49),y
; 6c65 47       ???
; 6c66 2f       ???
; 6c67 31 49    and ($49),y
; 6c69 47       ???
; 6c6a af       ???
; 6c6b af       ???
; 6c6c 44       ???
; 6c6d 42       ???
; 6c6e 2d 2f 44 and $442f
; 6c71 42       ???
; 6c72 ad ad 3d lda $3dad
; 6c75 2f       ???
; 6c76 1f       ???
; 6c77 2d 3d 2f and $2f3d
; 6c7a 9f       ???
; 6c7b dc       ???
; 6c7c a3       ???
; 6c7d 66 1f    ror $1f
; 6c7f 5c       ???
; 6c80 a3       ???
; 6c81 66 3f    ror $3f
; 6c83 3f       ???
; 6c84 00       brk 
; 6c85 50 2f    bvc $6cb6
; 6c87 e6 31    inc $31
; 6c89 33       ???
; 6c8a 68       pla 
; 6c8b 5f       ???
; 6c8c 1e 24 65 asl $6524,x
; 6c8f 66 31    ror $31
; 6c91 33       ???
; 6c92 09 10    ora #$10
; 6c94 1e 94 7c asl $7c94,x
; 6c97 5f       ???
; 6c98 89       ???
; 6c99 3a       ???
; 6c9a 8c 8e e4 sty $e48e
; 6c9d c8       iny 
; 6c9e 30 58    bmi $6cf8
; 6ca0 be be 28 ldx $28be,y
; 6ca3 00       brk 
; 6ca4 01 2a    ora ($2a,x)
; 6ca6 29 12    and #$12
; 6ca8 12       ???
; 6ca9 56 57    lsr $57,x
; 6cab 23       ???
; 6cac 22       ???
; 6cad 09 36    ora #$36
; 6caf ac 91 cd ldy $cd91
; 6cb2 e6 2b    inc $2b
; 6cb4 2d 6c 55 and $556c
; 6cb7 d1 00    cmp ($00),y
; 6cb9 48       pha 
; 6cba 03       ???
; 6cbb 5f       ???
; 6cbc 75 8f    adc $8f,x
; 6cbe a4 39    ldy $39
; 6cc0 2a       rol a
; 6cc1 7b       ???
; 6cc2 60       rts 
; 6cc3 78       sei 
; 6cc4 a2 2b    ldx #$2b
; 6cc6 2d ec e4 and $e4ec
; 6cc9 e0 00    cpx #$00
; 6ccb 48       pha 
; 6ccc 03       ???
; 6ccd df       ???
; 6cce 04       ???
; 6ccf af       ???
; 6cd0 b5 39    lda $39,x
; 6cd2 2a       rol a
; 6cd3 fb       ???
; 6cd4 e1 8a    sbc ($8a,x)
; 6cd6 a2 21    ldx #$21
; 6cd8 50 a8    bvc $6c82
; 6cda 63       ???
; 6cdb 7d 93 21 adc $2193,x
; 6cde 50 28    bvc $6d08
; 6ce0 e3       ???
; 6ce1 8e b5 39 stx $39b5
; 6ce4 2a       rol a
; 6ce5 3b       ???
; 6ce6 53       ???
; 6ce7 9d 94 39 sta $3994,x
; 6cea 2a       rol a
; 6ceb bb       ???
; 6cec d3       ???
; 6ced 8e 5a 09 stx $095a
; 6cf0 36 6c    rol $6c,x
; 6cf2 74       ???
; 6cf3 a0 7c    ldy #$7c
; 6cf5 11 2d    ora ($2d),y
; 6cf7 d7       ???
; 6cf8 65 76    adc $76
; 6cfa cc 11 2d cpy $2d11
; 6cfd 56 e4    lsr $e4,x
; 6cff 76 bb    ror $bb,x
; 6d01 04       ???
; 6d02 31 97    and ($97),y
; 6d04 25 76    and $76
; 6d06 bb       ???
; 6d07 04       ???
; 6d08 31 55    and ($55),y
; 6d0a e3       ???
; 6d0b 76 bb    ror $bb,x
; 6d0d 07       ???
; 6d0e 50 93    bvc $6ca3
; 6d10 4e 08 04 lsr $0408
; 6d13 07       ???
; 6d14 5a       ???
; 6d15 9d 4e 08 sta $084e,x
; 6d18 1a       ???
; 6d19 28       plp 
; 6d1a 12       ???
; 6d1b 04       ???
; 6d1c 1a       ???
; 6d1d 17       ???
; 6d1e 01 10    ora ($10,x)
; 6d20 26 18    rol $18
; 6d22 02       ???
; 6d23 1c       ???
; 6d24 3b       ???
; 6d25 3a       ???
; 6d26 1f       ???
; 6d27 0c       ???
; 6d28 27       ???
; 6d29 35 1e    and $1e,x
; 6d2b 14       ???
; 6d2c 1c       ???
; 6d2d 89       ???
; 6d2e 85 2c    sta $2c
; 6d30 3f       ???
; 6d31 23       ???
; 6d32 24 44    bit $44
; 6d34 34       ???
; 6d35 9a       txs 
; 6d36 a2 3c    ldx #$3c
; 6d38 43       ???
; 6d39 44       ???
; 6d3a 39 2c 37 and $372c,y
; 6d3d 4a       lsr a
; 6d3e 2f       ???
; 6d3f 18       clc 
; 6d40 33       ???
; 6d41 36 23    rol $23,x
; 6d43 1c       ???
; 6d44 2f       ???
; 6d45 26 17    rol $17
; 6d47 30 3f    bmi $6d88
; 6d49 47       ???
; 6d4a 40       rti 
; 6d4b 34       ???
; 6d4c 3b       ???
; 6d4d 27       ???
; 6d4e 24 40    bit $40
; 6d50 43       ???
; 6d51 8a       txa 
; 6d52 73       ???
; 6d53 38       sec 
; 6d54 4f       ???
; 6d55 7a       ???
; 6d56 6f       ???
; 6d57 44       ???
; 6d58 46 4c    lsr $4c
; 6d5a 5e 58 46 lsr $4658,x
; 6d5d 4b       ???
; 6d5e 61 5c    adc ($5c,x)
; 6d60 46 4a    lsr $4a
; 6d62 5c       ???
; 6d63 54       ???
; 6d64 4b       ???
; 6d65 79 72 44 adc $4472,y
; 6d68 4b       ???
; 6d69 69 6e    adc #$6e
; 6d6b 50 4b    bvc $6db8
; 6d6d 88       dey 
; 6d6e 75 34    adc $34,x
; 6d70 47       ???
; 6d71 68       pla 
; 6d72 69 48    adc #$48
; 6d74 32       ???
; 6d75 c5 ef    cmp $ef
; 6d77 70 45    bvs $6dbe
; 6d79 c4 f7    cpy $f7
; 6d7b 74       ???
; 6d7c 40       rti 
; 6d7d c3       ???
; 6d7e f3       ???
; 6d7f 78       sei 
; 6d80 48       pha 
; 6d81 c3       ???
; 6d82 fb       ???
; 6d83 74       ???
; 6d84 3e 0e 4c rol $4c0e,x
; 6d87 8c a3 5f sty $5fa3
; 6d8a 23       ???
; 6d8b 28       plp 
; 6d8c 84 87    sty $87
; 6d8e 2e 2d 06 rol $062d
; 6d91 07       ???
; 6d92 2e 2d 3d rol $3d2d
; 6d95 36 18    rol $18,x
; 6d97 19 20 1f ora $1f20,y
; 6d9a 2b       ???
; 6d9b 3e d2 c5 rol $c5d2,x
; 6d9e 22       ???
; 6d9f 1e 41 45 asl $4541,x
; 6da2 22       ???
; 6da3 1e 61 9a asl $9a61,x
; 6da6 7b       ???
; 6da7 5f       ???
; 6da8 fe 1a 7b inc $7b1a,x
; 6dab 5f       ???
; 6dac 3e 6f 7e rol $7e6f,x
; 6daf 60       rts 
; 6db0 d1 ef    cmp ($ef),y
; 6db2 7e 60 71 ror $7160,x
; 6db5 3f       ???
; 6db6 00       brk 
; 6db7 5a       ???
; 6db8 b3       ???
; 6db9 93       ???
; 6dba 7d 90 4f adc $4f90,x
; 6dbd 02       ???
; 6dbe 19 6f 14 ora $146f,y
; 6dc1 17       ???
; 6dc2 59 2a 6c eor $6c2a,y
; 6dc5 5c       ???
; 6dc6 e2       ???
; 6dc7 c8       iny 
; 6dc8 34       ???
; 6dc9 5c       ???
; 6dca 22       ???
; 6dcb 0e 14 00 asl $0014
; 6dce 00       brk 
; 6dcf 1b       ???
; 6dd0 1b       ???
; 6dd1 00       brk 
; 6dd2 e0 ff    cpx #$ff
; 6dd4 2f       ???
; 6dd5 42       ???
; 6dd6 32       ???
; 6dd7 30 60    bmi $6e39
; 6dd9 4f       ???
; 6dda 2f       ???
; 6ddb 64       ???
; 6ddc b4 60    ldy $60,x
; 6dde 10 4f    bpl $6e2f
; 6de0 3e fe 5f rol $5ffe,x
; 6de3 60       rts 
; 6de4 10 cf    bpl $6db5
; 6de6 be fe ff ldx $fffe,y
; 6de9 30 50    bmi $6e3b
; 6deb 5f       ???
; 6dec 93       ???
; 6ded ec 98 18 cpx $1898
; 6df0 88       dey 
; 6df1 af       ???
; 6df2 c8       iny 
; 6df3 55 fc    eor $fc,x
; 6df5 30 70    bmi $6e67
; 6df7 2f       ???
; 6df8 77       ???
; 6df9 84 fc    sty $fc
; 6dfb 30 70    bmi $6e6d
; 6dfd af       ???
; 6dfe e8       inx 
; 6dff 75 cc    adc $cc,x
; 6e01 30 60    bmi $6e63
; 6e03 8f       ???
; 6e04 91 a8    sta ($a8),y
; 6e06 76 30    ror $30,x
; 6e08 50 9f    bvc $6da9
; 6e0a f5 30    sbc $30,x
; 6e0c ba       tsx 
; 6e0d 18       clc 
; 6e0e 88       dey 
; 6e0f ef       ???
; 6e10 39 86 eb and $eb86,y
; 6e13 51 32    eor ($32),y
; 6e15 20 3f 3f jsr $3f3f
; 6e18 20 0c 2b jsr $2b0c
; 6e1b 50 31    bvc $6e4e
; 6e1d 08       php 
; 6e1e 27       ???
; 6e1f 2f       ???
; 6e20 10 04    bpl $6e26
; 6e22 23       ???
; 6e23 78       sei 
; 6e24 61 18    adc ($18,x)
; 6e26 2f       ???
; 6e27 70 55    bvs $6e7e
; 6e29 0c       ???
; 6e2a 27       ???
; 6e2b 56 3f    lsr $3f,x
; 6e2d 28       plp 
; 6e2e 3f       ???
; 6e2f 5f       ???
; 6e30 44       ???
; 6e31 10 2b    bpl $6e5e
; 6e33 81 6e    sta ($6e,x)
; 6e35 2c 3f c6 bit $c63f
; 6e38 af       ???
; 6e39 2c 43 a3 bit $a343
; 6e3c 90 1c    bcc $6e5a
; 6e3e 2f       ???
; 6e3f d5 c2    cmp $c2,x
; 6e41 30 2b    bmi $6e6e
; 6e43 8f       ???
; 6e44 94 20    sty $20,x
; 6e46 1b       ???
; 6e47 c2       ???
; 6e48 c7       ???
; 6e49 34       ???
; 6e4a 2f       ???
; 6e4b a0 a1    ldy #$a1
; 6e4d 1c       ???
; 6e4e 1b       ???
; 6e4f b1 b2    lda ($b2),y
; 6e51 30 47    bmi $6e9a
; 6e53 c8       iny 
; 6e54 b1 24    lda ($24),y
; 6e56 3b       ???
; 6e57 d7       ???
; 6e58 c4 24    cpy $24
; 6e5a 37       ???
; 6e5b e7       ???
; 6e5c dc       ???
; 6e5d 2c 37 e8 bit $e837
; 6e60 dd 30 3b cmp $3b30,x
; 6e63 cb       ???
; 6e64 c8       iny 
; 6e65 44       ???
; 6e66 47       ???
; 6e67 ea       nop 
; 6e68 e3       ???
; 6e69 40       rti 
; 6e6a 47       ???
; 6e6b b7       ???
; 6e6c a8       tay 
; 6e6d 24 33    bit $33
; 6e6f d9 de 4c cmp $4cde,y
; 6e72 47       ???
; 6e73 73       ???
; 6e74 58       cli 
; 6e75 14       ???
; 6e76 2f       ???
; 6e77 95 96    sta $96,x
; 6e79 44       ???
; 6e7a c3       ???
; 6e7b ba       tsx 
; 6e7c 43       ???
; 6e7d 33       ???
; 6e7e 2a       rol a
; 6e7f 3a       ???
; 6e80 43       ???
; 6e81 33       ???
; 6e82 ea       nop 
; 6e83 fa       ???
; 6e84 43       ???
; 6e85 33       ???
; 6e86 6a       ror a
; 6e87 7a       ???
; 6e88 43       ???
; 6e89 33       ???
; 6e8a aa       tax 
; 6e8b b2       ???
; 6e8c 39 26 1f and $1f26,y
; 6e8f 32       ???
; 6e90 39 26 df and $df26,y
; 6e93 f2       ???
; 6e94 39 26 5f and $5f26,y
; 6e97 72       ???
; 6e98 39 26 bf and $bf26,y
; 6e9b d8       cld 
; 6e9c 3e 30 4a rol $4a30,x
; 6e9f 58       cli 
; 6ea0 3e 30 8a rol $8a30,x
; 6ea3 98       tya 
; 6ea4 3e 30 0a rol $0a30,x
; 6ea7 18       clc 
; 6ea8 3e 30 4a rol $4a30,x
; 6eab 3f       ???
; 6eac 00       brk 
; 6ead 70 70    bvs $6f1f
; 6eaf 40       rti 
; 6eb0 46 8c    lsr $8c
; 6eb2 78       sei 
; 6eb3 5f       ???
; 6eb4 6d 1a 8c adc $8c1a
; 6eb7 8d 1b 00 sta $001b
; 6eba 28       plp 
; 6ebb 50 c8    bvc $6e85
; 6ebd be 1e 00 ldx $001e,y
; 6ec0 01 13    ora ($13,x)
; 6ec2 12       ???
; 6ec3 0e 7a cb asl $cb7a
; 6ec6 60       rts 
; 6ec7 5a       ???
; 6ec8 81 36    sta ($36,x)
; 6eca 12       ???
; 6ecb 03       ???
; 6ecc 11 ab    ora ($ab),y
; 6ece a5 1a    lda $1a
; 6ed0 42       ???
; 6ed1 33       ???
; 6ed2 22       ???
; 6ed3 bc a5 1a ldy $1aa5,x
; 6ed6 42       ???
; 6ed7 b3       ???
; 6ed8 b3       ???
; 6ed9 cd c1 36 cmp $36c1
; 6edc 12       ???
; 6edd 83       ???
; 6ede c4 de    cpy $de
; 6ee0 c1 36    cmp ($36,x)
; 6ee2 12       ???
; 6ee3 c0 bd    cpy #$bd
; 6ee5 27       ???
; 6ee6 32       ???
; 6ee7 0e 36 f0 asl $f036
; 6eea df       ???
; 6eeb 8a       txa 
; 6eec 73       ???
; 6eed 0e 36 70 asl $7036
; 6ef0 70 ac    bvs $6e9e
; 6ef2 a0 36    ldy #$36
; 6ef4 12       ???
; 6ef5 40       rti 
; 6ef6 40       rti 
; 6ef7 5c       ???
; 6ef8 58       cli 
; 6ef9 12       ???
; 6efa 26 43    rol $43
; 6efc 35 7e    and $7e,x
; 6efe 7b       ???
; 6eff 0e 6c 2c asl $2c6c
; 6f02 cb       ???
; 6f03 00       brk 
; 6f04 1a       ???
; 6f05 22       ???
; 6f06 1a       ???
; 6f07 9b       ???
; 6f08 89       ???
; 6f09 00       brk 
; 6f0a 10 1e    bpl $6f2a
; 6f0c 12       ???
; 6f0d af       ???
; 6f0e ab       ???
; 6f0f 00       brk 
; 6f10 03       ???
; 6f11 0e 6c ac asl $ac6c
; 6f14 4b       ???
; 6f15 00       brk 
; 6f16 1a       ???
; 6f17 22       ???
; 6f18 1a       ???
; 6f19 1b       ???
; 6f1a 09 00    ora #$00
; 6f1c 10 1e    bpl $6f3c
; 6f1e 12       ???
; 6f1f 2f       ???
; 6f20 2b       ???
; 6f21 00       brk 
; 6f22 00       brk 
; 6f23 0e 22 80 asl $8022
; 6f26 05 32    ora $32
; 6f28 a7       ???
; 6f29 1c       ???
; 6f2a 3a       ???
; 6f2b f8       sed 
; 6f2c 65 32    adc $32
; 6f2e a7       ???
; 6f2f 1c       ???
; 6f30 3a       ???
; 6f31 78       sei 
; 6f32 e5 32    sbc $32
; 6f34 b8       clv 
; 6f35 38       sec 
; 6f36 19 04 23 ora $2304,y
; 6f39 48       pha 
; 6f3a 2d 0c 27 and $270c
; 6f3d 58       cli 
; 6f3e 41 14    eor ($14,x)
; 6f40 2b       ???
; 6f41 68       pla 
; 6f42 55 1c    eor $1c,x
; 6f44 2f       ???
; 6f45 78       sei 
; 6f46 59 10 2c eor $2c10,y
; 6f49 1d 01 14 ora $1401,x
; 6f4c 30 42    bmi $6f90
; 6f4e 3a       ???
; 6f4f 2c 34 53 bit $5334
; 6f52 4f       ???
; 6f53 34       ???
; 6f54 38       sec 
; 6f55 64       ???
; 6f56 64       ???
; 6f57 3c       ???
; 6f58 3c       ???
; 6f59 21 05    and ($05,x)
; 6f5b 20 2f 15 jsr $152f
; 6f5e 1a       ???
; 6f5f 38       sec 
; 6f60 2f       ???
; 6f61 72       ???
; 6f62 7f       ???
; 6f63 3c       ???
; 6f64 2f       ???
; 6f65 83       ???
; 6f66 94 40    sty $40,x
; 6f68 33       ???
; 6f69 17       ???
; 6f6a 28       plp 
; 6f6b 44       ???
; 6f6c 32       ???
; 6f6d 20 16 18 jsr $1816
; 6f70 22       ???
; 6f71 31 2b    and ($2b),y
; 6f73 20 26 42 jsr $4226
; 6f76 40       rti 
; 6f77 28       plp 
; 6f78 2a       rol a
; 6f79 53       ???
; 6f7a 55 30    eor $30,x
; 6f7c 28       plp 
; 6f7d 08       php 
; 6f7e 28       plp 
; 6f7f 54       ???
; 6f80 35 09    and $09,x
; 6f82 2c 5c 3b bit $3b5c
; 6f85 0b       ???
; 6f86 28       plp 
; 6f87 58       cli 
; 6f88 38       sec 
; 6f89 08       php 
; 6f8a 34       ???
; 6f8b 6c 41 09 jmp ($0941)
; 6f8e 38       sec 
; 6f8f 74       ???
; 6f90 47       ???
; 6f91 0b       ???
; 6f92 34       ???
; 6f93 70 48    bvs $6fdd
; 6f95 a5 d9    lda $d9
; 6f97 84 50    sty $50
; 6f99 a5 d9    lda $d9
; 6f9b 88       dey 
; 6f9c 50 a1    bvc $6f3f
; 6f9e dd 8c 64 cmp $648c,x
; 6fa1 1c       ???
; 6fa2 18       clc 
; 6fa3 1e a5 e3 asl $e3a5,x
; 6fa6 44       ???
; 6fa7 18       clc 
; 6fa8 d7       ???
; 6fa9 fe 3f 25 inc $253f,x
; 6fac 64       ???
; 6fad 3f       ???
; 6fae 00       brk 
; 6faf 68       pla 
; 6fb0 a7       ???
; 6fb1 7e 3f 25 ror $253f,x
; 6fb4 44       ???
; 6fb5 63       ???
; 6fb6 44       ???
; 6fb7 18       clc 
; 6fb8 d4       ???
; 6fb9 c8       iny 
; 6fba 3a       ???
; 6fbb 41 4f    eor ($4f,x)
; 6fbd 3c       ???
; 6fbe 2d 43 52 and $5243
; 6fc1 48       pha 
; 6fc2 3a       ???
; 6fc3 41 72    eor ($72,x)
; 6fc5 5f       ???
; 6fc6 1c       ???
; 6fc7 1c       ???
; 6fc8 01 85    ora ($85,x)
; 6fca 87       ???
; 6fcb 6b       ???
; 6fcc 1c       ???
; 6fcd fd 49 1a sbc $1a49,x
; 6fd0 6e 67 45 ror $4567
; 6fd3 32       ???
; 6fd4 24 4c    bit $4c
; 6fd6 8c 7d 19 sty $197d
; 6fd9 00       brk 
; 6fda 02       ???
; 6fdb 12       ???
; 6fdc 1f       ???
; 6fdd 0f       ???
; 6fde 41 60    eor ($60,x)
; 6fe0 21 7a    and ($7a,x)
; 6fe2 87       ???
; 6fe3 0f       ???
; 6fe4 41 e0    eor ($e0,x)
; 6fe6 a0 68    ldy #$68
; 6fe8 67       ???
; 6fe9 12       ???
; 6fea 3a       ???
; 6feb 59 30 fe eor $fe30,y
; 6fee 3b       ???
; 6fef 3c       ???
; 6ff0 00       brk 
; 6ff1 9f       ???
; 6ff2 b2       ???
; 6ff3 79 a2 3c adc $3ca2,y
; 6ff6 00       brk 
; 6ff7 1f       ???
; 6ff8 44       ???
; 6ff9 ad a6 39 lda $39a6
; 6ffc 25 82    and $82
; 6ffe bd bd 96 lda $96bd,x
; 7001 39 25 02 and $0225,y
; 7004 2c 9b 70 bit $709b
; 7007 0d 1d 00 ora $001d
; 700a 2b       ???
; 700b 88       dey 
; 700c 4d 0d 1d eor $1d0d
; 700f 80       ???
; 7010 ab       ???
; 7011 88       dey 
; 7012 44       ???
; 7013 12       ???
; 7014 22       ???
; 7015 77       ???
; 7016 ab       ???
; 7017 88       dey 
; 7018 51 10    eor ($10),y
; 701a 34       ???
; 701b 36 05    rol $05,x
; 701d 00       brk 
; 701e 06 06    asl $06
; 7020 41 46    eor ($46,x)
; 7022 05 00    ora $00
; 7024 0d 10 34 ora $3410
; 7027 b6 85    ldx $85,y
; 7029 00       brk 
; 702a 06 06    asl $06
; 702c 41 c6    eor ($c6,x)
; 702e 85 00    sta $00
; 7030 1f       ???
; 7031 26 07    rol $07
; 7033 04       ???
; 7034 23       ???
; 7035 35 1a    and $1a,x
; 7037 10 24    bpl $705d
; 7039 4e 42 24 lsr $2442
; 703c 30 5f    bmi $709d
; 703e 5b       ???
; 703f 2c 30 70 bit $7030
; 7042 68       pla 
; 7043 24 33    bit $33
; 7045 47       ???
; 7046 28       plp 
; 7047 10 1f    bpl $7068
; 7049 76 6b    ror $6b,x
; 704b 1c       ???
; 704c 27       ???
; 704d 87       ???
; 704e 78       sei 
; 704f 14       ???
; 7050 23       ???
; 7051 11 02    ora ($02),y
; 7053 08       php 
; 7054 17       ???
; 7055 10 05    bpl $705c
; 7057 0c       ???
; 7058 19 24 1b ora $1b24,y
; 705b 14       ???
; 705c 1d 36 2d ora $2d36,x
; 705f 18       clc 
; 7060 1d 52 4d ora $4d52,x
; 7063 1c       ???
; 7064 21 41    and ($41,x)
; 7066 3c       ???
; 7067 20 1d 49 jsr $491d
; 706a 60       rts 
; 706b 3c       ???
; 706c 27       ???
; 706d 4b       ???
; 706e 60       rts 
; 706f 40       rti 
; 7070 2b       ???
; 7071 4b       ???
; 7072 64       ???
; 7073 44       ???
; 7074 29 05    and #$05
; 7076 28       plp 
; 7077 54       ???
; 7078 31 05    and ($05),y
; 707a 30 64    bmi $70e0
; 707c 53       ???
; 707d 1f       ???
; 707e 2b       ???
; 707f 32       ???
; 7080 a6 a9    ldx $a9
; 7082 3b       ???
; 7083 38       sec 
; 7084 26 29    rol $29
; 7086 3b       ???
; 7087 38       sec 
; 7088 ff       ???
; 7089 33       ???
; 708a 57       ???
; 708b 81 dd    sta ($dd,x)
; 708d 78       sei 
; 708e 34       ???
; 708f 82       ???
; 7090 c6 b3    dec $b3
; 7092 57       ???
; 7093 81 44    sta ($44,x)
; 7095 27       ???
; 7096 ab       ???
; 7097 95 91    sta $91,x
; 7099 5f       ???
; 709a 53       ???
; 709b 71 7d    adc ($7d),y
; 709d a7       ???
; 709e ab       ???
; 709f 95 32    sta $32,x
; 70a1 49 6f    eor #$6f
; 70a3 b2       ???
; 70a4 80       ???
; 70a5 5d a5 62 eor $62a5,x
; 70a8 9e       ???
; 70a9 92       ???
; 70aa 0e f5 29 asl $29f5
; 70ad 5f       ???
; 70ae 27       ???
; 70af 17       ???
; 70b0 27       ???
; 70b1 00       brk 
; 70b2 02       ???
; 70b3 18       clc 
; 70b4 36 50    rol $50,x
; 70b6 60       rts 
; 70b7 8f       ???
; 70b8 9f       ???
; 70b9 c8       iny 
; 70ba a8       tay 
; 70bb 64       ???
; 70bc 44       ???
; 70bd 5f       ???
; 70be 6f       ???
; 70bf 54       ???
; 70c0 64       ???
; 70c1 50 60    bvc $7123
; 70c3 af       ???
; 70c4 a0 65    ldy #$65
; 70c6 64       ???
; 70c7 20 44 83 jsr $8344
; 70ca 71 76    adc ($76),y
; 70cc 64       ???
; 70cd 50 60    bvc $712f
; 70cf 6f       ???
; 70d0 82       ???
; 70d1 98       tya 
; 70d2 75 64    adc $64,x
; 70d4 44       ???
; 70d5 1f       ???
; 70d6 73       ???
; 70d7 ba       tsx 
; 70d8 86 50    stx $50
; 70da 60       rts 
; 70db 4f       ???
; 70dc 83       ???
; 70dd db       ???
; 70de 97       ???
; 70df 20 44 63 jsr $6344
; 70e2 93       ???
; 70e3 fc       ???
; 70e4 a0 8c    ldy #$8c
; 70e6 e8       inx 
; 70e7 53       ???
; 70e8 5f       ???
; 70e9 19 b1 bc ora $bcb1,y
; 70ec a4 df    ldy $df
; 70ee ef       ???
; 70ef a9 b1    lda #$b1
; 70f1 8c e8 73 sty $73e8
; 70f4 20 ba b1 jsr $b1ba
; 70f7 18       clc 
; 70f8 a4 63    ldy $63
; 70fa f1 cb    sbc ($cb),y
; 70fc b1 8c    lda ($8c),y
; 70fe e8       inx 
; 70ff 33       ???
; 7100 12       ???
; 7101 ec b1 bc cpx $bcb1
; 7104 a4 9f    ldy $9f
; 7106 04       ???
; 7107 fe b1 8c inc $8cb1,x
; 710a e8       inx 
; 710b 13       ???
; 710c 15 0f    ora $0f,x
; 710e b1 18    lda ($18),y
; 7110 a4 43    ldy $43
; 7112 26 20    rol $20
; 7114 b1 58    lda ($58),y
; 7116 90 ee    bcc $7106
; 7118 37       ???
; 7119 32       ???
; 711a b1 58    lda ($58),y
; 711c 90 0e    bcc $712c
; 711e 57       ???
; 711f 32       ???
; 7120 b1 58    lda ($58),y
; 7122 90 4e    bcc $7172
; 7124 97       ???
; 7125 32       ???
; 7126 b1 58    lda ($58),y
; 7128 90 2e    bcc $7158
; 712a 77       ???
; 712b 32       ???
; 712c b8       clv 
; 712d a3       ???
; 712e 84 1c    sty $1c
; 7130 3b       ???
; 7131 5f       ???
; 7132 40       rti 
; 7133 04       ???
; 7134 23       ???
; 7135 60       rts 
; 7136 45 0c    eor $0c
; 7138 27       ???
; 7139 61 4a    adc ($4a,x)
; 713b 14       ???
; 713c 2b       ???
; 713d 62       ???
; 713e 4f       ???
; 713f 1c       ???
; 7140 2f       ???
; 7141 73       ???
; 7142 64       ???
; 7143 24 33    bit $33
; 7145 83       ???
; 7146 78       sei 
; 7147 2c 37 93 bit $9337
; 714a 8c 34 3b sty $3b34
; 714d 9f       ???
; 714e 80       ???
; 714f 20 3f 2f jsr $2f3f
; 7152 14       ???
; 7153 28       plp 
; 7154 43       ???
; 7155 40       rti 
; 7156 29 30    and #$30
; 7158 47       ???
; 7159 51 3e    eor ($3e),y
; 715b 38       sec 
; 715c 4b       ???
; 715d 72       ???
; 715e 63       ???
; 715f 40       rti 
; 7160 4f       ???
; 7161 84 79    sty $79
; 7163 48       pha 
; 7164 53       ???
; 7165 95 8e    sta $8e,x
; 7167 50 57    bvc $71c0
; 7169 a6 a3    ldx $a3
; 716b 58       cli 
; 716c 5b       ???
; 716d b7       ???
; 716e b8       clv 
; 716f 5c       ???
; 7170 5b       ???
; 7171 af       ???
; 7172 b0 44    bcs $71b8
; 7174 43       ???
; 7175 b0 b5    bcs $712c
; 7177 4c 47 b1 jmp $b147
; 717a ba       tsx 
; 717b 54       ???
; 717c 4b       ???
; 717d b2       ???
; 717e bf       ???
; 717f 5c       ???
; 7180 4f       ???
; 7181 b4 c5    ldy $c5,x
; 7183 64       ???
; 7184 53       ???
; 7185 b5 ca    lda $ca,x
; 7187 6c 57 b6 jmp ($b657)
; 718a cf       ???
; 718b 74       ???
; 718c 5a       ???
; 718d b7       ???
; 718e d9 84 62 cmp $6284,y
; 7191 b7       ???
; 7192 e1 94    sbc ($94,x)
; 7194 ab       ???
; 7195 c6 a3    dec $a3
; 7197 55 98    eor $98,x
; 7199 e6 a3    inc $a3
; 719b 55 98    eor $98,x
; 719d e6 80    inc $80
; 719f 55 7b    eor $7b,x
; 71a1 a6 80    ldx $80
; 71a3 55 5b    eor $5b,x
; 71a5 5f       ???
; 71a6 40       rti 
; 71a7 00       brk 
; 71a8 3f       ???
; 71a9 a6 a3    ldx $a3
; 71ab 55 38    eor $38,x
; 71ad 86 a3    stx $a3
; 71af 55 38    eor $38,x
; 71b1 86 80    stx $80
; 71b3 55 9b    eor $9b,x
; 71b5 c6 80    dec $80
; 71b7 55 db    eor $db,x
; 71b9 cf       ???
; 71ba 30 00    bmi $71bc
; 71bc f0 30    beq $71ee
; 71be 46 ec    lsr $ec
; 71c0 36 95    rol $95,x
; 71c2 45 12    eor $12
; 71c4 4e 4b 41 lsr $414b
; 71c7 32       ???
; 71c8 1c       ???
; 71c9 30 28    bmi $71f3
; 71cb 32       ???
; 71cc 05 e7    ora $e7
; 71ce 02       ???
; 71cf 12       ???
; 71d0 19 09 28 ora $2809,y
; 71d3 c7       ???
; 71d4 a0 56    ldy #$56
; 71d6 5e 2f 32 lsr $322f,x
; 71d9 eb       ???
; 71da e0 23    cpx #$23
; 71dc 2b       ???
; 71dd 21 38    and ($38,x)
; 71df 1f       ???
; 71e0 01 35    ora ($35,x)
; 71e2 3c       ???
; 71e3 21 38    and ($38,x)
; 71e5 df       ???
; 71e6 c2       ???
; 71e7 47       ???
; 71e8 4d 2f 32 eor $322f
; 71eb ab       ???
; 71ec a3       ???
; 71ed 59 5e 09 eor $095e,y
; 71f0 08       php 
; 71f1 47       ???
; 71f2 54       ???
; 71f3 7b       ???
; 71f4 6f       ???
; 71f5 13       ???
; 71f6 19 8e 91 ora $918e,y
; 71f9 78       sei 
; 71fa 6f       ???
; 71fb 0f       ???
; 71fc 20 99 a2 jsr $a299
; 71ff 89       ???
; 7200 6f       ???
; 7201 0f       ???
; 7202 20 59 73 jsr $7359
; 7205 9a       txs 
; 7206 6f       ???
; 7207 13       ???
; 7208 19 4e 84 ora $844e,y
; 720b ab       ???
; 720c 05 c3    ora $c3
; 720e 24 00    bit $00
; 7210 5f       ???
; 7211 73       ???
; 7212 19 0c 86 ora $860c,y
; 7215 ad 58 38 lda $3858
; 7218 4d 63 24 eor $2463
; 721b 68       pla 
; 721c a7       ???
; 721d 6d 58 38 adc $3858
; 7220 2d 33 19 and $1933
; 7223 0c       ???
; 7224 26 43    rol $43
; 7226 24 00    bit $00
; 7228 03       ???
; 7229 84 91    sty $91
; 722b 8a       txa 
; 722c 54       ???
; 722d 2b       ???
; 722e 51 2e    eor ($2e),y
; 7230 94 7e    sty $7e,x
; 7232 18       clc 
; 7233 00       brk 
; 7234 28       plp 
; 7235 55 29    eor $29,x
; 7237 20 24 00 jsr $0024
; 723a 02       ???
; 723b 36 48    rol $48,x
; 723d 1b       ???
; 723e 57       ???
; 723f af       ???
; 7240 61 9b    adc ($9b,x)
; 7242 ad 1b 57 lda $571b
; 7245 2f       ???
; 7246 e0 9a    cpx #$9a
; 7248 cf       ???
; 7249 3d 2f 07 and $072f,x
; 724c f3       ???
; 724d ad cf 3d lda $3dcf
; 7250 2f       ???
; 7251 27       ???
; 7252 44       ???
; 7253 ce 9d 21 dec $219d
; 7256 35 e7    and $e7,x
; 7258 15 de    ora $de,x
; 725a 9c       ???
; 725b 21 35    and ($35,x)
; 725d 67       ???
; 725e a6 ef    ldx $ef
; 7260 be 3d 2f ldx $2f3d,y
; 7263 a7       ???
; 7264 b6 c0    ldx $c0,y
; 7266 bf       ???
; 7267 3d 2f 87 and $872f,x
; 726a 82       ???
; 726b bc ad 21 ldy $21ad,x
; 726e 12       ???
; 726f 24 1e    bit $1e
; 7271 fe 13 21 inc $2113,x
; 7274 12       ???
; 7275 a4 9e    ldy $9e
; 7277 fe 13 1b inc $1b13,x
; 727a 45 90    eor $90
; 727c eb       ???
; 727d 32       ???
; 727e ad 1b 45 lda $451b
; 7281 10 6b    bpl $72ee
; 7283 32       ???
; 7284 b2       ???
; 7285 20 20 8b jsr $8b20
; 7288 0b       ???
; 7289 32       ???
; 728a b2       ???
; 728b 20 20 0b jsr $0b20
; 728e 8b       ???
; 728f 32       ???
; 7290 a8       tay 
; 7291 16 16    asl $16,x
; 7293 79 03 32 adc $3203,y
; 7296 a8       tay 
; 7297 16 16    asl $16,x
; 7299 f9 83 32 sbc $3283,y
; 729c 99 07 07 sta $0707,y
; 729f 40       rti 
; 72a0 df       ???
; 72a1 a0 20    ldy #$20
; 72a3 28       plp 
; 72a4 09 04    ora #$04
; 72a6 23       ???
; 72a7 38       sec 
; 72a8 1d 0c 27 ora $270c,x
; 72ab 20 05 28 jsr $2805
; 72ae 43       ???
; 72af 21 02    and ($02,x)
; 72b1 20 3f 48 jsr $483f
; 72b4 29 1c    and #$1c
; 72b6 3b       ???
; 72b7 42       ???
; 72b8 3f       ???
; 72b9 3c       ???
; 72ba 3f       ???
; 72bb 33       ???
; 72bc 1c       ???
; 72bd 2c 43 68 bit $6843
; 72c0 51 14    eor ($14),y
; 72c2 2b       ???
; 72c3 58       cli 
; 72c4 51 34    eor ($34),y
; 72c6 3b       ???
; 72c7 56 4f    lsr $4f,x
; 72c9 38       sec 
; 72ca 3f       ???
; 72cb 86 7b    stx $7b
; 72cd 34       ???
; 72ce 3f       ???
; 72cf 75 66    adc $66,x
; 72d1 34       ???
; 72d2 43       ???
; 72d3 64       ???
; 72d4 51 30    eor ($30),y
; 72d6 43       ???
; 72d7 77       ???
; 72d8 64       ???
; 72d9 1c       ???
; 72da 2f       ???
; 72db 87       ???
; 72dc 78       sei 
; 72dd 24 33    bit $33
; 72df 97       ???
; 72e0 8c 2c 37 sty $372c
; 72e3 a8       tay 
; 72e4 95 24    sta $24,x
; 72e6 37       ???
; 72e7 25 26    and $26
; 72e9 44       ???
; 72ea 36 ab    rol $ab,x
; 72ec c1 58    cmp ($58,x)
; 72ee 35 9e    and $9e,x
; 72f0 c9 68    cmp #$68
; 72f2 42       ???
; 72f3 a3       ???
; 72f4 d1 60    cmp ($60),y
; 72f6 32       ???
; 72f7 a3       ???
; 72f8 c5 68    cmp $68
; 72fa 41 9e    eor ($9e,x)
; 72fc cd 70 4e cmp $4e70
; 72ff ab       ???
; 7300 c5 60    cmp $60
; 7302 53       ???
; 7303 1f       ???
; 7304 37       ???
; 7305 46 ae    lsr $ae
; 7307 b7       ???
; 7308 63       ???
; 7309 5f       ???
; 730a 33       ???
; 730b 37       ???
; 730c 63       ???
; 730d 5f       ???
; 730e 33       ???
; 730f 4b       ???
; 7310 77       ???
; 7311 4b       ???
; 7312 9f       ???
; 7313 cb       ???
; 7314 77       ???
; 7315 4b       ???
; 7316 9f       ???
; 7317 cb       ???
; 7318 77       ???
; 7319 4b       ???
; 731a 1f       ???
; 731b 1f       ???
; 731c 35 35    and $35,x
; 731e 1f       ???
; 731f 4b       ???
; 7320 77       ???
; 7321 4b       ???
; 7322 3f       ???
; 7323 3f       ???
; 7324 00       brk 
; 7325 a0 ff    ldy #$ff
; 7327 5f       ???
; 7328 1b       ???
; 7329 1b       ???
; 732a 03       ???
; 732b 27       ???
; 732c 37       ???
; 732d 99 70 53 sta $5370,y
; 7330 69 2a    adc #$2a
; 7332 9c       ???
; 7333 8b       ???
; 7334 19 00 18 ora $1800,y
; 7337 3a       ???
; 7338 1e 24 28 asl $2824,x
; 733b 00       brk 
; 733c 02       ???
; 733d 36 34    rol $34,x
; 733f 05 48    ora $48
; 7341 62       ???
; 7342 21 46    and ($46,x)
; 7344 58       cli 
; 7345 14       ???
; 7346 28       plp 
; 7347 c7       ???
; 7348 a0 23    ldy #$23
; 734a 4a       lsr a
; 734b 28       plp 
; 734c 28       plp 
; 734d e7       ???
; 734e c0 56    cpy #$56
; 7350 55 0e    eor $0e,x
; 7352 36 66    rol $66,x
; 7354 42       ???
; 7355 59 55 0e eor $0e55,y
; 7358 36 a6    rol $a6,x
; 735a 90 47    bcc $73a3
; 735c 49 14    eor #$14
; 735e 28       plp 
; 735f 47       ???
; 7360 42       ???
; 7361 67       ???
; 7362 6c 28 28 jmp ($2828)
; 7365 67       ???
; 7366 73       ???
; 7367 89       ???
; 7368 79 24 38 adc $3824,y
; 736b d7       ???
; 736c a0 12    ldy #$12
; 736e 4d 3c 14 eor $143c
; 7371 d3       ???
; 7372 c0 12    cpy #$12
; 7374 35 24    and $24,x
; 7376 38       sec 
; 7377 57       ???
; 7378 53       ???
; 7379 78       sei 
; 737a 80       ???
; 737b 3c       ???
; 737c 14       ???
; 737d 53       ???
; 737e 73       ???
; 737f 78       sei 
; 7380 44       ???
; 7381 07       ???
; 7382 2a       rol a
; 7383 35 12    and $12,x
; 7385 44       ???
; 7386 44       ???
; 7387 08       php 
; 7388 21 2d    and ($2d,x)
; 738a 14       ???
; 738b 44       ???
; 738c 50 0e    bvc $739c
; 738e 2f       ???
; 738f c1 94    cmp ($94,x)
; 7391 00       brk 
; 7392 0c       ???
; 7393 0e 2f 41 asl $412f
; 7396 58       cli 
; 7397 88       dey 
; 7398 4e 10 2e lsr $2e10
; 739b dc       ???
; 739c 09 aa    ora #$aa
; 739e 5f       ???
; 739f 10 2e    bpl $73cf
; 73a1 1c       ???
; 73a2 49 aa    eor #$aa
; 73a4 5f       ???
; 73a5 10 2e    bpl $73d5
; 73a7 9c       ???
; 73a8 c9 aa    cmp #$aa
; 73aa 5f       ???
; 73ab 10 2e    bpl $73db
; 73ad 5c       ???
; 73ae 89       ???
; 73af aa       tax 
; 73b0 74       ???
; 73b1 21 02    and ($02,x)
; 73b3 04       ???
; 73b4 23       ???
; 73b5 20 05 20 jsr $2005
; 73b8 3b       ???
; 73b9 20 1d 3c jsr $3c1d
; 73bc 3f       ???
; 73bd 20 21 28 jsr $2821
; 73c0 26 23    rol $23
; 73c2 0d 14 2a ora $2a14
; 73c5 63       ???
; 73c6 51 24    eor ($24),y
; 73c8 36 33    rol $33,x
; 73ca 1d 18 2e ora $2e18,x
; 73cd 53       ???
; 73ce 45 28    eor $28
; 73d0 37       ???
; 73d1 53       ???
; 73d2 4c 40 47 jmp $4740
; 73d5 53       ???
; 73d6 5c       ???
; 73d7 4c 43 53 jmp $5343
; 73da 58       cli 
; 73db 38       sec 
; 73dc 33       ???
; 73dd 43       ???
; 73de 38       sec 
; 73df 14       ???
; 73e0 1b       ???
; 73e1 1f       ???
; 73e2 04       ???
; 73e3 0c       ???
; 73e4 27       ???
; 73e5 2d 16 14 and $1416
; 73e8 2b       ???
; 73e9 3e 37 24 rol $2437,x
; 73ec 2a       rol a
; 73ed 1b       ???
; 73ee 05 0c    ora $0c
; 73f0 22       ???
; 73f1 4e 48 2c lsr $2c48
; 73f4 2c 14 30 bit $3014
; 73f7 64       ???
; 73f8 46 12    lsr $12
; 73fa 34       ???
; 73fb 60       rts 
; 73fc 3e 56 70 rol $7056,x
; 73ff 64       ???
; 7400 4c 58 7c jmp $7c58
; 7403 68       pla 
; 7404 42       ???
; 7405 67       ???
; 7406 91 7c    sta ($7c),y
; 7408 54       ???
; 7409 69 95    adc #$95
; 740b 88       dey 
; 740c 5a       ???
; 740d 67       ???
; 740e 9d 8c 58 sta $588c,x
; 7411 69 99    adc #$99
; 7413 80       ???
; 7414 db       ???
; 7415 af       ???
; 7416 3e 32 e3 rol $e332,x
; 7419 ef       ???
; 741a 3e 32 63 rol $6332,x
; 741d 5f       ???
; 741e 1b       ???
; 741f 20 64 6f jsr $6f64
; 7422 3e 32 23 rol $2332,x
; 7425 2f       ???
; 7426 3e 32 42 rol $4232,x
; 7429 3e 00 a0 rol $a000,x
; 742c a0 90    ldy #$90
; 742e 0e 22 d0 asl $d022
; 7431 91 65    sta ($65),y
; 7433 36 c6    rol $c6,x
; 7435 b2       ???
; 7436 22       ???
; 7437 00       brk 
; 7438 30 ad    bmi $73e7
; 743a 6d f0 00 adc $00f0
; 743d 01 01    ora ($01,x)
; 743f 00       brk 
; 7440 00       brk 
; 7441 96 5a    stx $5a,y
; 7443 e3       ???
; 7444 20 56 e4 jsr $e456
; 7447 bd f2 e3 lda $e3f2,x
; 744a 20 23 7a jsr $7a23
; 744d d1 3d    cmp ($3d),y
; 744f 23       ???
; 7450 61 35    adc ($35,x)
; 7452 8b       ???
; 7453 d1 3d    cmp ($3d),y
; 7455 a3       ???
; 7456 e2       ???
; 7457 47       ???
; 7458 d3       ???
; 7459 bd f2 63 lda $63f2,x
; 745c a3       ???
; 745d 59 55 f3 eor $f355,y
; 7460 21 4d    and ($4d,x)
; 7462 34       ???
; 7463 7b       ???
; 7464 4d 32 79 eor $7932
; 7467 4d 31 89 eor $8931
; 746a 06 53    asl $53
; 746c f2       ???
; 746d 8d 82 ab sta $ab82
; 7470 17       ???
; 7471 53       ???
; 7472 f2       ???
; 7473 0d 13 cd ora $cd13
; 7476 80       ???
; 7477 32       ???
; 7478 79 cd e4 adc $e4cd,y
; 747b ef       ???
; 747c 39 53 f2 and $f253,y
; 747f 6d 55 8d adc $8d55
; 7482 5e 32 79 lsr $7932,x
; 7485 ad a6 af lda $afa6
; 7488 88       dey 
; 7489 f3       ???
; 748a 21 ad    and ($ad,x)
; 748c b7       ???
; 748d d1 80    cmp ($80),y
; 748f 32       ???
; 7490 79 2d 48 adc $482d,y
; 7493 f3       ???
; 7494 39 53 f2 and $f253,y
; 7497 ed 15 00 sbc $0015
; 749a 02       ???
; 749b d1 3d    cmp ($3d),y
; 749d 03       ???
; 749e a6 22    ldx $22
; 74a0 4a       lsr a
; 74a1 bd f2 43 lda $43f2,x
; 74a4 f7       ???
; 74a5 33       ???
; 74a6 bb       ???
; 74a7 96 5a    stx $5a,y
; 74a9 43       ???
; 74aa 08       php 
; 74ab 44       ???
; 74ac 4a       lsr a
; 74ad bd f2 c3 lda $c3f2,x
; 74b0 99 55 13 sta $1355,y
; 74b3 d1 3d    cmp ($3d),y
; 74b5 83       ???
; 74b6 29 25    and #$25
; 74b8 cb       ???
; 74b9 30 e4    bmi $749f
; 74bb 62       ???
; 74bc 9e       ???
; 74bd 00       brk 
; 74be 10 30    bpl $74f0
; 74c0 e4 a2    cpx $a2
; 74c2 de 00 10 dec $1000,x
; 74c5 30 e4    bmi $74ab
; 74c7 db       ???
; 74c8 17       ???
; 74c9 00       brk 
; 74ca 10 30    bpl $74fc
; 74cc e4 1b    cpx $1b
; 74ce 57       ???
; 74cf 00       brk 
; 74d0 1f       ???
; 74d1 20 01 04 jsr $0401
; 74d4 23       ???
; 74d5 21 06    and ($06,x)
; 74d7 0c       ???
; 74d8 27       ???
; 74d9 22       ???
; 74da 0b       ???
; 74db 14       ???
; 74dc 2b       ???
; 74dd 23       ???
; 74de 10 1c    bpl $74fc
; 74e0 2f       ???
; 74e1 24 15    bit $15
; 74e3 10 1f    bpl $7504
; 74e5 35 2a    and $2a,x
; 74e7 3c       ???
; 74e8 47       ???
; 74e9 36 3f    rol $3f,x
; 74eb 40       rti 
; 74ec 37       ???
; 74ed 46 3f    lsr $3f
; 74ef 44       ???
; 74f0 4b       ???
; 74f1 47       ???
; 74f2 54       ???
; 74f3 48       pha 
; 74f4 3b       ???
; 74f5 57       ???
; 74f6 54       ???
; 74f7 4c 4f 58 jmp $584f
; 74fa 69 50    adc #$50
; 74fc 3f       ???
; 74fd 68       pla 
; 74fe 69 54    adc #$54
; 7500 53       ???
; 7501 69 7e    adc #$7e
; 7503 58       cli 
; 7504 43       ???
; 7505 79 7e 5c adc $5c7e,y
; 7508 57       ???
; 7509 75 8e    adc $8e,x
; 750b 4c 33 9a jmp $9a33
; 750e b7       ???
; 750f 7c       ???
; 7510 5f       ???
; 7511 aa       tax 
; 7512 cb       ???
; 7513 84 63    sty $63
; 7515 ba       tsx 
; 7516 df       ???
; 7517 8c 67 ca sty $ca67
; 751a f3       ???
; 751b 94 6b    sty $6b,x
; 751d 8a       txa 
; 751e b7       ???
; 751f 88       dey 
; 7520 5b       ???
; 7521 34       ???
; 7522 15 14    ora $14,x
; 7524 33       ???
; 7525 31 16    and ($16),y
; 7527 1c       ???
; 7528 37       ???
; 7529 42       ???
; 752a 2b       ???
; 752b 24 3b    bit $3b
; 752d 53       ???
; 752e 40       rti 
; 752f 2c 3f 64 bit $643f
; 7532 55 34    eor $34,x
; 7534 43       ???
; 7535 86 8f    stx $8f
; 7537 64       ???
; 7538 5b       ???
; 7539 97       ???
; 753a a4 6c    ldy $6c
; 753c 5f       ???
; 753d a8       tay 
; 753e b9 74 63 lda $6374,y
; 7541 b9 ce 7c lda $7cce,y
; 7544 67       ???
; 7545 89       ???
; 7546 a2 84    ldx #$84
; 7548 6a       ror a
; 7549 1e 50 a4 asl $a450,x
; 754c 68       pla 
; 754d 14       ???
; 754e 54       ???
; 754f b0 73    bcs $75c4
; 7551 17       ???
; 7552 5c       ???
; 7553 b4 6c    ldy $6c,x
; 7555 14       ???
; 7556 58       cli 
; 7557 a8       tay 
; 7558 6f       ???
; 7559 1f       ???
; 755a 00       brk 
; 755b c4 e3    cpy $e3
; 755d 86 f5    stx $f5
; 755f e6 b7    inc $b7
; 7561 08       php 
; 7562 e0 90    cpx #$90
; 7564 b8       clv 
; 7565 5f       ???
; 7566 b0 08    bcs $7570
; 7568 37       ???
; 7569 88       dey 
; 756a e0 90    cpx #$90
; 756c f8       sed 
; 756d 06 f5    asl $f5
; 756f e6 97    inc $97
; 7571 3f       ???
; 7572 b0 08    bcs $757c
; 7574 97       ???
; 7575 e8       inx 
; 7576 e0 90    cpx #$90
; 7578 d8       cld 
; 7579 e6 f5    inc $f5
; 757b e6 57    inc $57
; 757d 66 f5    ror $f5
; 757f e6 17    inc $17
; 7581 68       pla 
; 7582 e0 90    cpx #$90
; 7584 98       tya 
; 7585 3f       ???
; 7586 00       brk 
; 7587 c4 10    cpy $10
; 7589 90 85    bcc $7510
; 758b 93       ???
; 758c 71 5e    adc ($5e),y
; 758e 97       ???
; 758f c4 4c    cpy $4c
; 7591 85 01    sta $01
; 7593 20 34 01 jsr $0134

_7596:
; 7596 d8       cld 
; 7597 a9 e3    lda #$e3
; 7599 8d 93 75 sta $7593
; 759c a9 75    lda #$75
; 759e 8d 94 75 sta $7594
; 75a1 a9 86    lda #$86
; 75a3 a0 5a    ldy #$5a
; 75a5 a2 8e    ldx #$8e
; 75a7 20 c0 75 jsr $75c0
; 75aa a9 ff    lda #$ff
; 75ac 8d 93 75 sta $7593
; 75af a9 3f    lda #$3f
; 75b1 8d 94 75 sta $7594
; 75b4 a9 75    lda #$75
; 75b6 a0 8f    ldy #$8f
; 75b8 a2 6c    ldx #$6c
; 75ba 20 c0 75 jsr $75c0
; 75bd 4c e4 75 jmp $75e4
; 75c0 86 1a    stx $1a
; 75c2 85 19    sta $19
; 75c4 a9 00    lda #$00
; 75c6 85 18    sta $18
; 75c8 b1 18    lda ($18),y
; 75ca 38       sec 
; 75cb e5 1a    sbc $1a
; 75cd 91 18    sta ($18),y
; 75cf 85 1a    sta $1a
; 75d1 98       tya 
; 75d2 d0 02    bne $75d6
; 75d4 c6 19    dec $19
; 75d6 88       dey 
; 75d7 cc 93 75 cpy $7593
; 75da d0 ec    bne $75c8
; 75dc a5 19    lda $19
; 75de cd 94 75 cmp $7594
; 75e1 d0 e5    bne $75c8
; 75e3 60       rts 
; 75e4 b8       clv 
; 75e5 bf       ???
; 75e6 a9 85    lda #$85
; 75e8 9d c1 b0 sta $b0c1,x
; 75eb 8c 9e c2 sty $c29e
; 75ee a9 85    lda #$85
; 75f0 9f       ???
; 75f1 c3       ???
; 75f2 e9 60    sbc #$60
; 75f4 34       ???
; 75f5 8c f0 1d sty $1df0
; 75f8 a6 2a    ldx $2a
; 75fa 21 01    and ($01,x)
; 75fc 0d 89 86 ora $8689
; 75ff a3       ???
; 7600 cb       ???
; 7601 d2       ???
; 7602 a9 85    lda #$85
; 7604 9d c1 79 sta $79c1,x
; 7607 55 9e    eor $9e,x
; 7609 c2       ???
; 760a a9 85    lda #$85
; 760c 9f       ???
; 760d c3       ???
; 760e ff       ???
; 760f 76 34    ror $34,x
; 7611 8c 1d a6 sty $a61d
; 7614 2a       rol a
; 7615 21 01    and ($01,x)
; 7617 0e 8a 86 asl $868a
; 761a ae af df ldx $dfaf
; 761d e6 0c    inc $0c
; 761f 90 8f    bcc $75b0
; 7621 df       ???
; 7622 8a       txa 
; 7623 ad dd 06 lda $06dd
; 7626 25 05    and $05
; 7628 0b       ???
; 7629 8f       ???
; 762a 8d dd 86 sta $86dd
; 762d ac 90 9a ldy $9a90
; 7630 e9 69    sbc #$69
; 7632 9a       txs 
; 7633 ea       nop 
; 7634 86 2a    stx $2a
; 7636 0e a5 e8 asl $e8a5
; 7639 79 a9 8d adc $8da9,y
; 763c ad f0 79 lda $79f0
; 763f a9 8d    lda #$8d
; 7641 ae f1 79 ldx $79f1
; 7644 e4 c8    cpx $c8
; 7646 9e       ???
; 7647 e1 79    sbc ($79,x)
; 7649 69 4d    adc #$4d
; 764b a3       ???
; 764c e6 79    inc $79
; 764e a9 8d    lda #$8d
; 7650 a2 e5    ldx #$e5
; 7652 79 b2 96 adc $96b2,y
; 7655 b6 f9    ldx $f9,y
; 7657 79 b5 99 adc $99b5,y
; 765a b7       ???
; 765b fa       ???
; 765c 79 af 93 adc $93af,y
; 765f b8       clv 
; 7660 fb       ???
; 7661 79 aa 8e adc $8eaa,y
; 7664 b9 fc 79 lda $79fc,y
; 7667 ae 92 ba ldx $ba92
; 766a fd 79 b2 sbc $b279,x
; 766d 96 bb    stx $bb,y
; 766f fe 79 b1 inc $b179,x
; 7672 95 b2    sta $b2,x
; 7674 f5 79    sbc $79,x
; 7676 b0 94    bcs $760c
; 7678 b3       ???
; 7679 f6 79    inc $79,x
; 767b a9 8d    lda #$8d
; 767d a9 ec    lda #$ec
; 767f 79 a8 8c adc $8ca8,y
; 7682 a4 e7    ldy $e7
; 7684 5d aa ed eor $edaa,x
; 7687 79 a9 8d adc $8da9,y
; 768a 9d e0 72 sta $72e0,x
; 768d 43       ???
; 768e 41 05    eor ($05,x)
; 7690 f3       ???
; 7691 8e d0 5c stx $5cd0
; 7694 8d d1 79 sta $79d1
; 7697 bb       ???
; 7698 b2       ???
; 7699 ac 99 8f ldy $8f99
; 769c d2       ???
; 769d 5c       ???
; 769e 8f       ???
; 769f d3       ???
; 76a0 da       ???
; 76a1 97       ???
; 76a2 91 d4    sta ($d4),y
; 76a4 5c       ???
; 76a5 91 d5    sta ($d5),y
; 76a7 da       ???
; 76a8 97       ???
; 76a9 93       ???
; 76aa d6 5c    dec $5c,x
; 76ac 93       ???
; 76ad d7       ???
; 76ae da       ???
; 76af 97       ???
; 76b0 95 d8    sta $d8,x
; 76b2 5c       ???
; 76b3 95 d9    sta $d9,x
; 76b5 79 b7 9b adc $9bb7,y
; 76b8 97       ???
; 76b9 da       ???
; 76ba 5c       ???
; 76bb 97       ???
; 76bc db       ???
; 76bd da       ???
; 76be 97       ???
; 76bf 99 dc 5c sta $5cdc,y
; 76c2 99 dd da sta $dadd,y
; 76c5 97       ???
; 76c6 9b       ???
; 76c7 de 5c 9b dec $9b5c,x
; 76ca df       ???
; 76cb 79 ab 8f adc $8fab,y
; 76ce a8       tay 
; 76cf eb       ???
; 76d0 79 a9 85 adc $85a9,y
; 76d3 9d c0 4a sta $4ac0,x
; 76d6 e2       ???
; 76d7 c6 9f    dec $9f
; 76d9 aa       tax 
; 76da a9 e0    lda #$e0
; 76dc 98       tya 
; 76dd cb       ???
; 76de a1 bf    lda ($bf,x)
; 76e0 01 c8    ora ($c8,x)
; 76e2 40       rti 
; 76e3 30 c2    bmi $76a7
; 76e5 9b       ???
; 76e6 b9 96 9f lda $9f96,y
; 76e9 aa       tax 
; 76ea a9 e0    lda #$e0
; 76ec 98       tya 
; 76ed cb       ???
; 76ee a1 bf    lda ($bf,x)
; 76f0 01 c8    ora ($c8,x)
; 76f2 48       pha 
; 76f3 38       sec 
; 76f4 c2       ???
; 76f5 9b       ???
; 76f6 79 55 9d adc $9d55,y
; 76f9 c1 0f    cmp ($0f,x)
; 76fb eb       ???
; 76fc 9e       ???
; 76fd c2       ???
; 76fe e3       ???
; 76ff bf       ???
; 7700 9f       ???
; 7701 c3       ???
; 7702 21 98    and ($98,x)
; 7704 47       ???
; 7705 9f       ???
; 7706 21 a9    and ($a9,x)
; 7708 85 9d    sta $9d
; 770a c1 09    cmp ($09,x)
; 770c e5 9e    sbc $9e
; 770e bb       ???
; 770f bb       ???
; 7710 c2       ???
; 7711 19 10 c4 ora $c410,y
; 7714 b5 a9    lda $a9,x
; 7716 b8       clv 
; 7717 a3       ???
; 7718 94 a9    sty $a9,x
; 771a a0 31    ldy #$31
; 771c a9 91    lda #$91
; 771e a9 a0    lda #$a0
; 7720 98       tya 
; 7721 0b       ???
; 7722 9b       ???
; 7723 c5 b6    cmp $b6
; 7725 a9 e0    lda #$e0
; 7727 59 a9 e0 eor $e0a9,y
; 772a 59 a9 bd eor $bda9,y
; 772d bd 30 81 lda $8130,x
; 7730 91 ad    sta ($ad),y
; 7732 9d a8 92 sta $92a8,x
; 7735 e8       inx 
; 7736 ff       ???
; 7737 e3       ???
; 7738 9a       txs 
; 7739 a6 7f    ldx $7f
; 773b a9 85    lda #$85
; 773d 9d c1 0d sta $0dc1,x
; 7740 e9 9e    sbc #$9e
; 7742 bb       ???
; 7743 b4 bb    ldy $bb,x
; 7745 19 10 c4 ora $c410,y
; 7748 b5 a9    lda $a9,x
; 774a b8       clv 
; 774b a3       ???
; 774c 94 a9    sty $a9,x
; 774e a0 31    ldy #$31
; 7750 a9 91    lda #$91
; 7752 a9 a0    lda #$a0
; 7754 98       tya 
; 7755 0b       ???
; 7756 9b       ???
; 7757 c5 b6    cmp $b6
; 7759 a9 e0    lda #$e0
; 775b 59 a9 e0 eor $e0a9,y
; 775e 59 a9 bd eor $bda9,y
; 7761 bd 30 81 lda $8130,x
; 7764 91 ad    sta ($ad),y
; 7766 9d a8 92 sta $92a8,x
; 7769 e8       inx 
; 776a ff       ???
; 776b e3       ???
; 776c 9a       txs 
; 776d a6 7f    ldx $7f
; 776f 19 10 bf ora $bf10,y
; 7772 b8       clv 
; 7773 5d 27 eb eor $eb27,x
; 7776 98       tya 
; 7777 0a       asl a
; 7778 a3       ???
; 7779 a9 85    lda #$85
; 777b 9d c0 4a sta $4ac0,x
; 777e 7a       ???
; 777f 5e 9f bb lsr $bb9f,x
; 7782 a6 95    ldx $95
; 7784 a9 e0    lda #$e0
; 7786 98       tya 
; 7787 cb       ???
; 7788 e1 ff    sbc ($ff,x)
; 778a e3       ???
; 778b 9a       txs 
; 778c c6 9f    dec $9f
; 778e 79 55 9d adc $9d55,y
; 7791 c1 83    cmp ($83,x)
; 7793 5f       ???
; 7794 9e       ???
; 7795 c2       ???
; 7796 03       ???
; 7797 df       ???
; 7798 9f       ???
; 7799 c3       ???
; 779a 22       ???
; 779b 99 47 9f sta $9f47,y
; 779e 18       clc 
; 779f c2       ???
; 77a0 cb       ???
; 77a1 b0 a0    bcs $7743
; 77a3 9b       ???
; 77a4 da       ???
; 77a5 60       rts 
; 77a6 58       cli 
; 77a7 ca       dex 
; 77a8 a3       ???
; 77a9 49 2d    eor #$2d
; 77ab 85 5b    sta $5b
; 77ad f0 85    beq $7734
; 77af 5f       ???
; 77b0 10 4d    bpl $77ff
; 77b2 31 86    and ($86),y
; 77b4 5c       ???
; 77b5 f0 86    beq $773d
; 77b7 60       rts 
; 77b8 10 4e    bpl $7808
; 77ba 32       ???
; 77bb 87       ???
; 77bc 5d f0 87 eor $87f0,x
; 77bf 61 f4    adc ($f4,x)
; 77c1 89       ???
; 77c2 5f       ???
; 77c3 f0 89    beq $774e
; 77c5 63       ???
; 77c6 f4       ???
; 77c7 8b       ???
; 77c8 61 f0    adc ($f0,x)
; 77ca 8b       ???
; 77cb 65 10    adc $10
; 77cd 4f       ???
; 77ce 33       ???
; 77cf 88       dey 
; 77d0 5e f0 88 lsr $88f0,x
; 77d3 62       ???
; 77d4 f4       ???
; 77d5 8a       txa 
; 77d6 60       rts 
; 77d7 f0 8a    beq $7763
; 77d9 64       ???
; 77da f4       ???
; 77db 8c 62 f0 sty $f062
; 77de 8c 66 0c sty $0c66
; 77e1 a6 2a    ldx $2a
; 77e3 21 01    and ($01,x)
; 77e5 0f       ???
; 77e6 8b       ???
; 77e7 86 59    stx $59
; 77e9 fa       ???
; 77ea ab       ???
; 77eb b2       ???
; 77ec 39 15 9d and $9d15,y
; 77ef c1 98    cmp ($98,x)
; 77f1 74       ???
; 77f2 9e       ???
; 77f3 c2       ???
; 77f4 23       ???
; 77f5 ff       ???
; 77f6 9f       ???
; 77f7 c3       ???
; 77f8 26 9d    rol $9d
; 77fa 34       ???
; 77fb 8c 18 a0 sty $a018
; 77fe b9 33 f4 lda $f433,y
; 7801 13       ???
; 7802 99 68 f0 sta $f068,y
; 7805 58       cli 
; 7806 c7       ???
; 7807 b0 33    bcs $783c
; 7809 f5 14    sbc $14,x
; 780b 99 69 f1 sta $f169,y
; 780e 58       cli 
; 780f c7       ???
; 7810 43       ???
; 7811 5a       ???
; 7812 dc       ???
; 7813 53       ???
; 7814 a0 bb    ldy #$bb
; 7816 a0 b1    ldy #$b1
; 7818 cb       ???
; 7819 ab       ???
; 781a a9 a0    lda #$a0
; 781c 58       cli 
; 781d c9 df    cmp #$df
; 781f 01 01    ora ($01,x)
; 7821 ff       ???
; 7822 e3       ???
; 7823 9a       txs 
; 7824 c2       ???
; 7825 52       ???
; 7826 02       ???
; 7827 a3       ???
; 7828 21 34    and ($34,x)
; 782a 8c 18 b7 sty $b718
; 782d b9 a3 b2 lda $b2a3,y
; 7830 cb       ???
; 7831 ab       ???
; 7832 a9 a0    lda #$a0
; 7834 98       tya 
; 7835 09 9b    ora #$9b
; 7837 a2 60    ldx #$60
; 7839 60       rts 
; 783a 00       brk 
; 783b 00       brk 
; 783c 07       ???
; 783d 1e 2e 8b asl $8b2e,x
; 7840 e8       inx 
; 7841 e8       inx 
; 7842 e8       inx 
; 7843 9b       ???
; 7844 4e 4e 4e lsr $4e4e
; 7847 4e 4e 4e lsr $4e4e
; 784a 4e 4e 4e lsr $4e4e
; 784d 4e 4e 4e lsr $4e4e
; 7850 4e 4e 4e lsr $4e4e
; 7853 4e 4e 8e lsr $8e4e
; 7856 8e 4e 4e stx $4e4e
; 7859 4e 4e 5e lsr $5e4e
; 785c 6e 3e 07 ror $073e
; 785f 00       brk 
; 7860 00       brk 
; 7861 00       brk 
; 7862 00       brk 
; 7863 00       brk 
; 7864 07       ???
; 7865 1e 2e 3b asl $3b2e,x
; 7868 48       pha 
; 7869 48       pha 
; 786a 48       pha 
; 786b 4b       ???
; 786c 4e 4e 4e lsr $4e4e
; 786f 4e 4e 4e lsr $4e4e
; 7872 4e 4e 4e lsr $4e4e
; 7875 4e 4e 4e lsr $4e4e
; 7878 4e 4e 4e lsr $4e4e
; 787b 8e ce ce stx $cece
; 787e ce 8a 46 dec $468a
; 7881 46 46    lsr $46
; 7883 5a       ???
; 7884 6e 3e 07 ror $073e
; 7887 00       brk 
; 7888 00       brk 
; 7889 00       brk 
; 788a 00       brk 
; 788b 00       brk 
; 788c 07       ???
; 788d 3e 6e 60 rol $606e,x
; 7890 52       ???
; 7891 52       ???
; 7892 52       ???
; 7893 50 4e    bvc $78e3
; 7895 4e 4e 4e lsr $4e4e
; 7898 4e 4e 4e lsr $4e4e
; 789b 4e 4e 4e lsr $4e4e
; 789e 4e 4e 4e lsr $4e4e
; 78a1 4e 4e 4e lsr $4e4e
; 78a4 4e 8e 8e lsr $8e8e
; 78a7 4a       lsr a
; 78a8 46 46    lsr $46
; 78aa 46 5a    lsr $5a
; 78ac 6e 3e 07 ror $073e
; 78af 00       brk 
; 78b0 00       brk 
; 78b1 00       brk 
; 78b2 00       brk 
; 78b3 00       brk 
; 78b4 07       ???
; 78b5 3e 6e 5f rol $5f6e,x
; 78b8 50 50    bvc $790a
; 78ba 50 4f    bvc $790b
; 78bc 4e 4e 4e lsr $4e4e
; 78bf 4e 4e 4e lsr $4e4e
; 78c2 4e 4e 4e lsr $4e4e
; 78c5 4e 4e 4e lsr $4e4e
; 78c8 4e 4e 4e lsr $4e4e
; 78cb 4e 4e 4e lsr $4e4e
; 78ce 4e 4b 48 lsr $484b
; 78d1 48       pha 
; 78d2 48       pha 
; 78d3 3b       ???
; 78d4 2e 1e 07 rol $071e
; 78d7 00       brk 
; 78d8 00       brk 
; 78d9 00       brk 
; 78da 00       brk 
; 78db 00       brk 
; 78dc 07       ???
; 78dd 3e 6e 61 rol $616e,x
; 78e0 54       ???
; 78e1 54       ???
; 78e2 54       ???
; 78e3 51 4e    eor ($4e),y
; 78e5 4e 4e 4e lsr $4e4e
; 78e8 4e 4e 4e lsr $4e4e
; 78eb 4e 4e 4e lsr $4e4e
; 78ee 4e 4e 4e lsr $4e4e
; 78f1 4e 4e 4e lsr $4e4e
; 78f4 4e 4e 4e lsr $4e4e
; 78f7 4b       ???
; 78f8 48       pha 
; 78f9 48       pha 
; 78fa 48       pha 
; 78fb 3b       ???
; 78fc 2e 1e 07 rol $071e
; 78ff 00       brk 
; 7900 00       brk 
; 7901 00       brk 
; 7902 00       brk 
; 7903 00       brk 
; 7904 07       ???
; 7905 3e 6e 64 rol $646e,x
; 7908 5a       ???
; 7909 5a       ???
; 790a 5a       ???
; 790b 54       ???
; 790c 2e 2e 4e rol $4e2e
; 790f 4e 4e 4e lsr $4e4e
; 7912 4e 4e 4e lsr $4e4e
; 7915 4e 4e 4e lsr $4e4e
; 7918 4e 4e 4e lsr $4e4e
; 791b 4e 4e 2e lsr $2e4e
; 791e 2e 4b 48 rol $484b
; 7921 48       pha 
; 7922 48       pha 
; 7923 3b       ???
; 7924 2e 1e 07 rol $071e
; 7927 00       brk 
; 7928 00       brk 
; 7929 00       brk 
; 792a 00       brk 
; 792b 00       brk 
; 792c 07       ???
; 792d ce 8e ce dec $ce8e
; 7930 0e 0e 0e asl $0e0e
; 7933 2e 2e 2e rol $2e2e
; 7936 4e 4e 4e lsr $4e4e
; 7939 4e 4e 4e lsr $4e4e
; 793c 4e 4e 4e lsr $4e4e
; 793f 4e 4e 4e lsr $4e4e
; 7942 4e 4e 4e lsr $4e4e
; 7945 2e 2e 4b rol $4b2e
; 7948 48       pha 
; 7949 48       pha 
; 794a 48       pha 
; 794b 3b       ???
; 794c 2e 1e 07 rol $071e
; 794f 00       brk 
; 7950 00       brk 
; 7951 60       rts 
; 7952 33       ???
; 7953 39 83 bd and $bd83,y
; 7956 e0 f3    cpx #$f3
; 7958 86 d3    stx $d3
; 795a 00       brk 
; 795b 00       brk 
; 795c 00       brk 
; 795d 05 0a    ora $0a
; 795f 0a       asl a
; 7960 0a       asl a
; 7961 0a       asl a
; 7962 0a       asl a
; 7963 12       ???
; 7964 1a       ???
; 7965 1a       ???
; 7966 1a       ???
; 7967 1a       ???
; 7968 1a       ???
; 7969 1a       ???
; 796a 1a       ???
; 796b 1a       ???
; 796c 1a       ???
; 796d 1a       ???
; 796e 1a       ???
; 796f 1a       ???
; 7970 1a       ???
; 7971 1a       ???
; 7972 1a       ???
; 7973 12       ???
; 7974 0a       asl a
; 7975 0a       asl a
; 7976 0a       asl a
; 7977 0a       asl a
; 7978 0a       asl a
; 7979 0a       asl a
; 797a 0a       asl a
; 797b 0a       asl a
; 797c 0a       asl a
; 797d 05 00    ora $00
; 797f 00       brk 
; 7980 00       brk 
; 7981 00       brk 
; 7982 00       brk 
; 7983 00       brk 
; 7984 00       brk 
; 7985 05 0a    ora $0a
; 7987 0a       asl a
; 7988 0a       asl a
; 7989 0a       asl a
; 798a 0a       asl a
; 798b 12       ???
; 798c 1a       ???
; 798d 1a       ???
; 798e 1a       ???
; 798f 1a       ???
; 7990 1a       ???
; 7991 1a       ???
; 7992 1a       ???
; 7993 1a       ???
; 7994 1a       ???
; 7995 1a       ???
; 7996 1a       ???
; 7997 1a       ???
; 7998 1a       ???
; 7999 1a       ???
; 799a 1a       ???
; 799b 12       ???
; 799c 0a       asl a
; 799d 0a       asl a
; 799e 0a       asl a
; 799f 0a       asl a
; 79a0 0a       asl a
; 79a1 0a       asl a
; 79a2 0a       asl a
; 79a3 0a       asl a
; 79a4 0a       asl a
; 79a5 05 00    ora $00
; 79a7 00       brk 
; 79a8 00       brk 
; 79a9 00       brk 
; 79aa 00       brk 
; 79ab 00       brk 
; 79ac 00       brk 
; 79ad 05 0a    ora $0a
; 79af 0a       asl a
; 79b0 0a       asl a
; 79b1 0a       asl a
; 79b2 0a       asl a
; 79b3 12       ???
; 79b4 1a       ???
; 79b5 1a       ???
; 79b6 1a       ???
; 79b7 1a       ???
; 79b8 1a       ???
; 79b9 1a       ???
; 79ba 1a       ???
; 79bb 1a       ???
; 79bc 1a       ???
; 79bd 1a       ???
; 79be 1a       ???
; 79bf 1a       ???
; 79c0 1a       ???
; 79c1 1a       ???
; 79c2 1a       ???
; 79c3 12       ???
; 79c4 0a       asl a
; 79c5 0a       asl a
; 79c6 0a       asl a
; 79c7 0a       asl a
; 79c8 0a       asl a
; 79c9 0a       asl a
; 79ca 0a       asl a
; 79cb 0a       asl a
; 79cc 0a       asl a
; 79cd 05 00    ora $00
; 79cf 00       brk 
; 79d0 00       brk 
; 79d1 00       brk 
; 79d2 00       brk 
; 79d3 00       brk 
; 79d4 00       brk 
; 79d5 05 0a    ora $0a
; 79d7 0a       asl a
; 79d8 0a       asl a
; 79d9 0a       asl a
; 79da 0a       asl a
; 79db 12       ???
; 79dc 1a       ???
; 79dd 1a       ???
; 79de 1a       ???
; 79df 1a       ???
; 79e0 1a       ???
; 79e1 1a       ???
; 79e2 1a       ???
; 79e3 1a       ???
; 79e4 1a       ???
; 79e5 1a       ???
; 79e6 1a       ???
; 79e7 1a       ???
; 79e8 1a       ???
; 79e9 1a       ???
; 79ea 1a       ???
; 79eb 1a       ???
; 79ec 12       ???
; 79ed 0a       asl a
; 79ee 0a       asl a
; 79ef 0a       asl a
; 79f0 0a       asl a
; 79f1 0a       asl a
; 79f2 0a       asl a
; 79f3 0a       asl a
; 79f4 0a       asl a
; 79f5 05 00    ora $00
; 79f7 00       brk 
; 79f8 00       brk 
; 79f9 00       brk 
; 79fa 00       brk 
; 79fb 00       brk 
; 79fc 00       brk 
; 79fd 05 0a    ora $0a
; 79ff 0a       asl a
; 7a00 0a       asl a
; 7a01 0a       asl a
; 7a02 0a       asl a
; 7a03 12       ???
; 7a04 1a       ???
; 7a05 1a       ???
; 7a06 1a       ???
; 7a07 1a       ???
; 7a08 1a       ???
; 7a09 1a       ???
; 7a0a 1a       ???
; 7a0b 1a       ???
; 7a0c 1a       ???
; 7a0d 1a       ???
; 7a0e 1a       ???
; 7a0f 1a       ???
; 7a10 1a       ???
; 7a11 1a       ???
; 7a12 1a       ???
; 7a13 1a       ???
; 7a14 1a       ???
; 7a15 1a       ???
; 7a16 1a       ???
; 7a17 12       ???
; 7a18 0a       asl a
; 7a19 0a       asl a
; 7a1a 0a       asl a
; 7a1b 0a       asl a
; 7a1c 0a       asl a
; 7a1d 05 00    ora $00
; 7a1f 00       brk 
; 7a20 00       brk 
; 7a21 00       brk 
; 7a22 00       brk 
; 7a23 00       brk 
; 7a24 00       brk 
; 7a25 05 0a    ora $0a
; 7a27 0a       asl a
; 7a28 0a       asl a
; 7a29 0a       asl a
; 7a2a 0a       asl a
; 7a2b 12       ???
; 7a2c 1a       ???
; 7a2d 1a       ???
; 7a2e 1a       ???
; 7a2f 1a       ???
; 7a30 1a       ???
; 7a31 1a       ???
; 7a32 1a       ???
; 7a33 1a       ???
; 7a34 1a       ???
; 7a35 1a       ???
; 7a36 1a       ???
; 7a37 1a       ???
; 7a38 1a       ???
; 7a39 1a       ???
; 7a3a 1a       ???
; 7a3b 1a       ???
; 7a3c 1a       ???
; 7a3d 1a       ???
; 7a3e 1a       ???
; 7a3f 12       ???
; 7a40 0a       asl a
; 7a41 0a       asl a
; 7a42 0a       asl a
; 7a43 0a       asl a
; 7a44 0a       asl a
; 7a45 05 00    ora $00
; 7a47 00       brk 
; 7a48 00       brk 
; 7a49 00       brk 
; 7a4a 00       brk 
; 7a4b 00       brk 
; 7a4c 00       brk 
; 7a4d 0f       ???
; 7a4e 1e 16 0e asl $0e16,x
; 7a51 0e 0e 14 asl $140e
; 7a54 1a       ???
; 7a55 1a       ???
; 7a56 1a       ???
; 7a57 1a       ???
; 7a58 1a       ???
; 7a59 1a       ???
; 7a5a 10 06    bpl $7a62
; 7a5c 06 06    asl $06
; 7a5e 06 10    asl $10
; 7a60 1a       ???
; 7a61 1a       ???
; 7a62 1a       ???
; 7a63 1a       ???
; 7a64 1a       ???
; 7a65 1a       ???
; 7a66 1a       ???
; 7a67 14       ???
; 7a68 0e 0e 0e asl $0e0e
; 7a6b 0c       ???
; 7a6c 0a       asl a
; 7a6d 05 00    ora $00
; 7a6f 00       brk 
; 7a70 00       brk 
; 7a71 8d a5 a7 sta $a7a5
; 7a74 df       ???
; 7a75 96 c4    stx $c4,y
; 7a77 22       ???
; 7a78 98       tya 
; 7a79 f4       ???
; 7a7a 00       brk 
; 7a7b 00       brk 
; 7a7c 00       brk 
; 7a7d 00       brk 
; 7a7e 00       brk 
; 7a7f 00       brk 
; 7a80 10 10    bpl $7a92
; 7a82 00       brk 
; 7a83 10 10    bpl $7a95
; 7a85 00       brk 
; 7a86 10 10    bpl $7a98
; 7a88 00       brk 
; 7a89 10 10    bpl $7a9b
; 7a8b 00       brk 
; 7a8c 10 10    bpl $7a9e
; 7a8e 00       brk 
; 7a8f 00       brk 
; 7a90 00       brk 
; 7a91 00       brk 
; 7a92 00       brk 
; 7a93 00       brk 
; 7a94 00       brk 
; 7a95 00       brk 
; 7a96 00       brk 
; 7a97 3e 3e f8 rol $f83e,x
; 7a9a f8       sed 
; 7a9b 00       brk 
; 7a9c 00       brk 
; 7a9d 00       brk 
; 7a9e 00       brk 
; 7a9f 00       brk 
; 7aa0 00       brk 
; 7aa1 00       brk 
; 7aa2 00       brk 
; 7aa3 00       brk 
; 7aa4 10 10    bpl $7ab6
; 7aa6 00       brk 
; 7aa7 10 10    bpl $7ab9
; 7aa9 00       brk 
; 7aaa 10 10    bpl $7abc
; 7aac 00       brk 
; 7aad 10 10    bpl $7abf
; 7aaf 00       brk 
; 7ab0 10 10    bpl $7ac2
; 7ab2 00       brk 
; 7ab3 00       brk 
; 7ab4 00       brk 
; 7ab5 00       brk 
; 7ab6 00       brk 
; 7ab7 00       brk 
; 7ab8 3a       ???
; 7ab9 3a       ???
; 7aba 00       brk 
; 7abb 00       brk 
; 7abc 00       brk 
; 7abd 00       brk 
; 7abe 00       brk 
; 7abf 00       brk 
; 7ac0 10 10    bpl $7ad2
; 7ac2 00       brk 
; 7ac3 10 10    bpl $7ad5
; 7ac5 00       brk 
; 7ac6 10 10    bpl $7ad8
; 7ac8 07       ???
; 7ac9 06 bf    asl $bf
; 7acb c4 04    cpy $04
; 7acd 40       rti 
; 7ace 40       rti 
; 7acf 00       brk 
; 7ad0 00       brk 
; 7ad1 00       brk 
; 7ad2 00       brk 
; 7ad3 00       brk 
; 7ad4 00       brk 
; 7ad5 00       brk 
; 7ad6 00       brk 
; 7ad7 00       brk 
; 7ad8 00       brk 
; 7ad9 00       brk 
; 7ada 00       brk 
; 7adb 00       brk 
; 7adc 00       brk 
; 7add 00       brk 
; 7ade 00       brk 
; 7adf 00       brk 
; 7ae0 00       brk 
; 7ae1 00       brk 
; 7ae2 00       brk 
; 7ae3 04       ???
; 7ae4 04       ???
; 7ae5 40       rti 
; 7ae6 47       ???
; 7ae7 06 bf    asl $bf
; 7ae9 c0 10    cpy #$10
; 7aeb 10 00    bpl $7aed
; 7aed 10 10    bpl $7aff
; 7aef 00       brk 
; 7af0 10 10    bpl $7b02
; 7af2 00       brk 
; 7af3 00       brk 
; 7af4 00       brk 
; 7af5 00       brk 
; 7af6 00       brk 
; 7af7 00       brk 
; 7af8 31 31    and ($31),y
; 7afa 00       brk 
; 7afb 00       brk 
; 7afc 00       brk 
; 7afd 00       brk 
; 7afe 00       brk 
; 7aff 00       brk 
; 7b00 00       brk 
; 7b01 00       brk 
; 7b02 00       brk 
; 7b03 fe fe 00 inc $00fe,x
; 7b06 44       ???
; 7b07 44       ???
; 7b08 00       brk 
; 7b09 28       plp 
; 7b0a 28       plp 
; 7b0b 00       brk 
; 7b0c 10 10    bpl $7b1e
; 7b0e 30 30    bmi $7b40
; 7b10 18       clc 
; 7b11 40       rti 
; 7b12 28       plp 
; 7b13 28       plp 
; 7b14 4c 24 48 jmp $4824
; 7b17 6a       ror a
; 7b18 22       ???
; 7b19 88       dey 
; 7b1a ac 24 48 ldy $4824
; 7b1d 70 28    bvs $7b47
; 7b1f 28       plp 
; 7b20 58       cli 
; 7b21 30 18    bmi $7b3b
; 7b23 18       clc 
; 7b24 10 10    bpl $7b36
; 7b26 00       brk 
; 7b27 28       plp 
; 7b28 28       plp 
; 7b29 00       brk 
; 7b2a 44       ???
; 7b2b 44       ???
; 7b2c 00       brk 
; 7b2d fe fe 00 inc $00fe,x
; 7b30 00       brk 
; 7b31 00       brk 
; 7b32 00       brk 
; 7b33 00       brk 
; 7b34 00       brk 
; 7b35 00       brk 
; 7b36 00       brk 
; 7b37 00       brk 
; 7b38 45 84    eor $84
; 7b3a 3e f7 18 rol $18f7,x
; 7b3d 30 18    bmi $7b57
; 7b3f 28       plp 
; 7b40 58       cli 
; 7b41 40       rti 
; 7b42 10 18    bpl $7b5c
; 7b44 30 e4    bmi $7b2a
; 7b46 fc       ???
; 7b47 7e c8 92 ror $92c8,x
; 7b4a 92       ???
; 7b4b 03       ???
; 7b4c ba       tsx 
; 7b4d 3b       ???
; 7b4e 82       ???
; 7b4f 90 12    bcc $7b63
; 7b51 82       ???
; 7b52 fc       ???
; 7b53 7e a8 ea ror $eaa8,x
; 7b56 0e c6 0c asl $0cc6
; 7b59 8e 24 ea stx $ea24
; 7b5c 0e 4a fc asl $fc4a
; 7b5f 7e 82 90 ror $9082,x
; 7b62 12       ???
; 7b63 83       ???
; 7b64 ba       tsx 
; 7b65 3b       ???
; 7b66 84 92    sty $92
; 7b68 92       ???
; 7b69 46 fc    lsr $fc
; 7b6b 7e 4e 18 ror $184e,x
; 7b6e 30 40    bmi $7bb0
; 7b70 58       cli 
; 7b71 40       rti 
; 7b72 28       plp 
; 7b73 30 18    bmi $7b8d
; 7b75 47       ???
; 7b76 3e f7 9b rol $9bf7,x
; 7b79 a3       ???
; 7b7a 00       brk 
; 7b7b 00       brk 
; 7b7c 00       brk 
; 7b7d 43       ???
; 7b7e 43       ???
; 7b7f 10 d8    bpl $7b59
; 7b81 48       pha 
; 7b82 84 35    sty $35
; 7b84 f1 d3    sbc ($d3),y
; 7b86 17       ???
; 7b87 cc d0 34 cpy $34d0
; 7b8a 50 7d    bvc $7c09
; 7b8c 86 f9    stx $f9
; 7b8e df       ???
; 7b8f 69 8e    adc #$8e
; 7b91 02       ???
; 7b92 38       sec 
; 7b93 84 24    sty $24
; 7b95 7b       ???
; 7b96 f8       sed 
; 7b97 ab       ???
; 7b98 fb       ???
; 7b99 73       ???
; 7b9a 9e       ???
; 7b9b d1 7b    cmp ($7b),y
; 7b9d d3       ???
; 7b9e cc 33 18 cpy $1833
; 7ba1 fb       ???
; 7ba2 f8       sed 
; 7ba3 9e       ???
; 7ba4 37       ???
; 7ba5 ec fb 60 cpx $60fb
; 7ba8 c1 9c    cmp ($9c,x)
; 7baa 6b       ???
; 7bab eb       ???
; 7bac a0 1c    ldy #$1c
; 7bae 24 38    bit $38
; 7bb0 da       ???
; 7bb1 ce 0c c8 dec $c80c
; 7bb4 48       pha 
; 7bb5 80       ???
; 7bb6 06 06    asl $06
; 7bb8 44       ???
; 7bb9 44       ???
; 7bba 2a       rol a
; 7bbb 2a       rol a
; 7bbc 08       php 
; 7bbd b2       ???
; 7bbe 2a       rol a
; 7bbf 8a       txa 
; 7bc0 a3       ???
; 7bc1 39 ca d4 and $d4ca,y
; 7bc4 52       ???
; 7bc5 b2       ???
; 7bc6 b4 54    ldy $54,x
; 7bc8 d0 cc    bne $7b96
; 7bca 4e 52 14 lsr $1452
; 7bcd 14       ???
; 7bce d4       ???
; 7bcf d4       ???
; 7bd0 42       ???
; 7bd1 42       ???
; 7bd2 54       ???
; 7bd3 54       ???
; 7bd4 54       ???
; 7bd5 54       ???
; 7bd6 54       ???
; 7bd7 d4       ???
; 7bd8 d4       ???
; 7bd9 52       ???
; 7bda 53       ???
; 7bdb 95 e4    sta $e4,x
; 7bdd a9 aa    lda #$aa
; 7bdf f9 ad 6a sbc $6aad,y
; 7be2 a9 99    lda #$99
; 7be4 95 e4    sta $e4,x
; 7be6 24 d4    bit $d4
; 7be8 52       ???
; 7be9 b2       ???
; 7bea b4 4a    ldy $4a,x
; 7bec a2 ac    ldx #$ac
; 7bee 2a       rol a
; 7bef 80       ???
; 7bf0 96 96    stx $96,y
; 7bf2 00       brk 
; 7bf3 14       ???
; 7bf4 14       ???
; 7bf5 00       brk 
; 7bf6 00       brk 
; 7bf7 00       brk 
; 7bf8 44       ???
; 7bf9 44       ???
; 7bfa 00       brk 
; 7bfb 00       brk 
; 7bfc 00       brk 
; 7bfd 00       brk 
; 7bfe 00       brk 
; 7bff 00       brk 
; 7c00 0a       asl a
; 7c01 0a       asl a
; 7c02 0a       asl a
; 7c03 34       ???
; 7c04 aa       tax 
; 7c05 aa       tax 
; 7c06 d0 46    bne $7c4e
; 7c08 ca       dex 
; 7c09 d4       ???
; 7c0a 52       ???
; 7c0b 52       ???
; 7c0c 14       ???
; 7c0d 12       ???
; 7c0e d2       ???
; 7c0f d4       ???
; 7c10 52       ???
; 7c11 52       ???
; 7c12 54       ???
; 7c13 54       ???
; 7c14 54       ???
; 7c15 54       ???
; 7c16 54       ???
; 7c17 d4       ???
; 7c18 d4       ???
; 7c19 52       ???
; 7c1a 53       ???
; 7c1b 95 e4    sta $e4,x
; 7c1d a9 aa    lda #$aa
; 7c1f f9 ac a9 sbc $a9ac,y
; 7c22 b9 69 95 lda $9569,y
; 7c25 e4 24    cpx $24
; 7c27 d4       ???
; 7c28 52       ???
; 7c29 b2       ???
; 7c2a b4 4a    ldy $4a,x
; 7c2c a1 ab    lda ($ab,x)
; 7c2e ea       nop 
; 7c2f 40       rti 
; 7c30 96 96    stx $96,y
; 7c32 00       brk 
; 7c33 14       ???
; 7c34 14       ???
; 7c35 00       brk 
; 7c36 00       brk 
; 7c37 00       brk 
; 7c38 54       ???
; 7c39 8c 6d 5a sty $5a6d
; 7c3c 8c 61 af sty $af61
; 7c3f 5a       ???
; 7c40 47       ???
; 7c41 c4 e3    cpy $e3
; 7c43 a0 ca    ldy #$ca
; 7c45 62       ???
; 7c46 45 c2    eor $c2
; 7c48 fb       ???
; 7c49 3e 06 02 rol $0206,x
; 7c4c 80       ???
; 7c4d f2       ???
; 7c4e 2e ff 43 rol $43ff
; 7c51 3a       ???
; 7c52 d6 f6    dec $f6,x
; 7c54 e3       ???
; 7c55 23       ???
; 7c56 61 2c    adc ($2c,x)
; 7c58 8e ae 86 stx $86ae
; 7c5b e2       ???
; 7c5c 27       ???
; 7c5d e4 69    cpx $69
; 7c5f 66 7f    ror $7f
; 7c61 28       plp 
; 7c62 45 c2    eor $c2
; 7c64 10 cd    bpl $7c33
; 7c66 f1 a8    sbc ($a8),y
; 7c68 98       tya 
; 7c69 b7       ???
; 7c6a 54       ???
; 7c6b 76 39    ror $39,x
; 7c6d 42       ???
; 7c6e ba       tsx 
; 7c6f c9 9c    cmp #$9c
; 7c71 aa       tax 
; 7c72 02       ???
; 7c73 7c       ???
; 7c74 c9 eb    cmp #$eb
; 7c76 35 04    and $04,x
; 7c78 09 02    ora #$02
; 7c7a c0 d6    cpy #$d6
; 7c7c 33       ???
; 7c7d 3d 7c 55 and $557c,x
; 7c80 5b       ???
; 7c81 b6 4b    ldx $4b,y
; 7c83 64       ???
; 7c84 10 06    bpl $7c8c
; 7c86 26 43    rol $43
; 7c88 eb       ???
; 7c89 f1 0c    sbc ($0c),y
; 7c8b ed 2b 3f sbc $3f2b
; 7c8e dc       ???
; 7c8f 9e       ???
; 7c90 68       pla 
; 7c91 c0 e3    cpy #$e3
; 7c93 97       ???
; 7c94 1d 72 08 ora $0872,x
; 7c97 62       ???
; 7c98 77       ???
; 7c99 e3       ???
; 7c9a 8a       txa 
; 7c9b 42       ???
; 7c9c c2       ???
; 7c9d 20 7f 0b jsr $0b7f
; 7ca0 aa       tax 
; 7ca1 be 3b e3 ldx $e33b,y
; 7ca4 c8       iny 
; 7ca5 22       ???
; 7ca6 36 ae    rol $ae,x
; 7ca8 bc f3 03 ldy $03f3,x
; 7cab d8       cld 
; 7cac 22       ???
; 7cad b7       ???
; 7cae f0 bd    beq $7c6d
; 7cb0 2e f9 d3 rol $d3f9
; 7cb3 22       ???
; 7cb4 76 71    ror $71,x
; 7cb6 82       ???
; 7cb7 2e f3 d3 rol $d3f3
; 7cba fc       ???
; 7cbb f1 e6    sbc ($e6),y
; 7cbd d7       ???
; 7cbe a9 f8    lda #$f8
; 7cc0 3e 1c d9 rol $d91c,x
; 7cc3 c3       ???
; 7cc4 22       ???
; 7cc5 b1 e7    lda ($e7),y
; 7cc7 bd 29 e9 lda $e929,x
; 7cca cb       ???
; 7ccb 22       ???
; 7ccc 7f       ???
; 7ccd 86 91    stx $91
; 7ccf 40       rti 
; 7cd0 11 df    ora ($df),y
; 7cd2 22       ???
; 7cd3 b7       ???
; 7cd4 f8       sed 
; 7cd5 28       plp 
; 7cd6 63       ???
; 7cd7 82       ???
; 7cd8 eb       ???
; 7cd9 21 ee    and ($ee,x)
; 7cdb 09 db    ora #$db
; 7cdd 22       ???
; 7cde 56 36    lsr $36,x
; 7ce0 6c 0e a9 jmp ($a90e)
; 7ce3 ab       ???
; 7ce4 22       ???
; 7ce5 b1 e5    lda ($e5),y
; 7ce7 b9 11 bd lda $bd11,y
; 7cea bd 06 32 lda $3206,x
; 7ced 78       sei 
; 7cee 8b       ???
; 7cef ad e2 47 lda $47e2
; 7cf2 2c 08 07 bit $0708
; 7cf5 a2 c0    ldx #$c0
; 7cf7 1f       ???
; 7cf8 a3       ???
; 7cf9 bf       ???
; 7cfa 50 f3    bvc $7cef
; 7cfc 3c       ???
; 7cfd e6 3b    inc $3b
; 7cff 2f       ???
; 7d00 29 d5    and #$d5
; 7d02 da       ???
; 7d03 2d 21 c7 and $c721
; 7d06 d6 13    dec $13,x
; 7d08 e8       inx 
; 7d09 88       dey 
; 7d0a 52       ???
; 7d0b d4       ???
; 7d0c fd 72 d2 sbc $d272,x
; 7d0f fc       ???
; 7d10 71 f0    adc ($f0),y
; 7d12 53       ???
; 7d13 66 32    ror $32
; 7d15 2d 17 59 and $5917
; 7d18 b0 62    bcs $7d7c
; 7d1a f7       ???
; 7d1b 75 07    adc $07,x
; 7d1d 31 15    and ($15),y
; 7d1f 5c       ???
; 7d20 55 0b    eor $0b,x
; 7d22 ef       ???
; 7d23 d8       cld 
; 7d24 8f       ???
; 7d25 fe e3 cc inc $cce3,x
; 7d28 1f       ???
; 7d29 2f       ???
; 7d2a 0e b2 99 asl $99b2
; 7d2d df       ???
; 7d2e ba       tsx 
; 7d2f 9d 09 ad sta $ad09,x
; 7d32 41 36    eor ($36,x)
; 7d34 f0 0e    beq $7d44
; 7d36 b2       ???
; 7d37 99 b6 c1 sta $c1b6,y
; 7d3a c6 41    dec $41
; 7d3c 18       clc 
; 7d3d 99 62 7a sta $7a62,y
; 7d40 b2       ???
; 7d41 cd c3 02 cmp $02c3
; 7d44 cb       ???
; 7d45 93       ???
; 7d46 80       ???
; 7d47 44       ???
; 7d48 88       dey 
; 7d49 5d 58 bf eor $bf58,x
; 7d4c 80       ???
; 7d4d 04       ???
; 7d4e 39 d8 1f and $1fd8,y
; 7d51 61 60    adc ($60,x)
; 7d53 ea       nop 
; 7d54 0b       ???
; 7d55 60       rts 
; 7d56 1b       ???
; 7d57 a2 c8    ldx #$c8
; 7d59 3c       ???
; 7d5a 1a       ???
; 7d5b 2e da b1 rol $b1da
; 7d5e c9 38    cmp #$38
; 7d60 74       ???
; 7d61 f5 17    sbc $17,x
; 7d63 92       ???
; 7d64 ca       dex 
; 7d65 da       ???
; 7d66 ce 64 62 dec $6264
; 7d69 09 22    ora #$22
; 7d6b 78       sei 
; 7d6c 79 23 d8 adc $d823,y
; 7d6f 4a       lsr a
; 7d70 0e b2 99 asl $99b2
; 7d73 99 02 ce sta $ce02,y
; 7d76 c0 06    cpy #$06
; 7d78 b4 b9    ldy $b9,x
; 7d7a 00       brk 
; 7d7b 00       brk 
; 7d7c 00       brk 
; 7d7d 00       brk 
; 7d7e 00       brk 
; 7d7f 00       brk 
; 7d80 00       brk 
; 7d81 00       brk 
; 7d82 00       brk 
; 7d83 00       brk 
; 7d84 00       brk 
; 7d85 00       brk 
; 7d86 00       brk 
; 7d87 00       brk 
; 7d88 00       brk 
; 7d89 00       brk 
; 7d8a 00       brk 
; 7d8b 00       brk 
; 7d8c 00       brk 
; 7d8d 00       brk 
; 7d8e 00       brk 
; 7d8f 00       brk 
; 7d90 00       brk 
; 7d91 02       ???
; 7d92 04       ???
; 7d93 04       ???
; 7d94 04       ???
; 7d95 04       ???
; 7d96 04       ???
; 7d97 04       ???
; 7d98 04       ???
; 7d99 ac aa 15 ldy $15aa
; 7d9c 25 25    and $25
; 7d9e 25 20    and $20
; 7da0 10 aa    bpl $7d4c
; 7da2 aa       tax 
; 7da3 14       ???
; 7da4 24 24    bit $24
; 7da6 18       clc 
; 7da7 18       clc 
; 7da8 14       ???
; 7da9 55 55    eor $55,x
; 7dab 00       brk 
; 7dac 00       brk 
; 7dad 00       brk 
; 7dae 00       brk 
; 7daf 00       brk 
; 7db0 ff       ???
; 7db1 54       ???
; 7db2 55 00    eor $00,x
; 7db4 00       brk 
; 7db5 00       brk 
; 7db6 00       brk 
; 7db7 00       brk 
; 7db8 ff       ???
; 7db9 54       ???
; 7dba 55 00    eor $00,x
; 7dbc 00       brk 
; 7dbd 00       brk 
; 7dbe 00       brk 
; 7dbf 00       brk 
; 7dc0 ff       ???
; 7dc1 54       ???
; 7dc2 55 00    eor $00,x
; 7dc4 00       brk 
; 7dc5 00       brk 
; 7dc6 00       brk 
; 7dc7 00       brk 
; 7dc8 ff       ???
; 7dc9 a9 40    lda #$40
; 7dcb 2e 38 20 rol $2038
; 7dce 00       brk 
; 7dcf 00       brk 
; 7dd0 00       brk 
; 7dd1 2a       rol a
; 7dd2 aa       tax 
; 7dd3 00       brk 
; 7dd4 00       brk 
; 7dd5 00       brk 
; 7dd6 00       brk 
; 7dd7 00       brk 
; 7dd8 00       brk 
; 7dd9 aa       tax 
; 7dda aa       tax 
; 7ddb 00       brk 
; 7ddc 00       brk 
; 7ddd 00       brk 
; 7dde 00       brk 
; 7ddf 00       brk 
; 7de0 00       brk 
; 7de1 aa       tax 
; 7de2 aa       tax 
; 7de3 00       brk 
; 7de4 00       brk 
; 7de5 00       brk 
; 7de6 00       brk 
; 7de7 00       brk 
; 7de8 00       brk 
; 7de9 aa       tax 
; 7dea aa       tax 
; 7deb 00       brk 
; 7dec 00       brk 
; 7ded 00       brk 
; 7dee 00       brk 
; 7def 00       brk 
; 7df0 00       brk 
; 7df1 aa       tax 
; 7df2 aa       tax 
; 7df3 00       brk 
; 7df4 00       brk 
; 7df5 00       brk 
; 7df6 00       brk 
; 7df7 00       brk 
; 7df8 00       brk 
; 7df9 aa       tax 
; 7dfa aa       tax 
; 7dfb 00       brk 
; 7dfc 00       brk 
; 7dfd 00       brk 
; 7dfe 00       brk 
; 7dff 00       brk 
; 7e00 00       brk 
; 7e01 aa       tax 
; 7e02 aa       tax 
; 7e03 00       brk 
; 7e04 00       brk 
; 7e05 00       brk 
; 7e06 00       brk 
; 7e07 00       brk 
; 7e08 00       brk 
; 7e09 aa       tax 
; 7e0a aa       tax 
; 7e0b 00       brk 
; 7e0c 00       brk 
; 7e0d 00       brk 
; 7e0e 00       brk 
; 7e0f 00       brk 
; 7e10 00       brk 
; 7e11 aa       tax 
; 7e12 aa       tax 
; 7e13 00       brk 
; 7e14 00       brk 
; 7e15 00       brk 
; 7e16 00       brk 
; 7e17 00       brk 
; 7e18 00       brk 
; 7e19 aa       tax 
; 7e1a aa       tax 
; 7e1b 00       brk 
; 7e1c 00       brk 
; 7e1d 00       brk 
; 7e1e 00       brk 
; 7e1f 00       brk 
; 7e20 00       brk 
; 7e21 aa       tax 
; 7e22 aa       tax 
; 7e23 00       brk 
; 7e24 00       brk 
; 7e25 00       brk 
; 7e26 00       brk 
; 7e27 00       brk 
; 7e28 00       brk 
; 7e29 aa       tax 
; 7e2a aa       tax 
; 7e2b 00       brk 
; 7e2c 00       brk 
; 7e2d 00       brk 
; 7e2e 00       brk 
; 7e2f 00       brk 
; 7e30 00       brk 
; 7e31 aa       tax 
; 7e32 aa       tax 
; 7e33 00       brk 
; 7e34 00       brk 
; 7e35 00       brk 
; 7e36 00       brk 
; 7e37 00       brk 
; 7e38 00       brk 
; 7e39 aa       tax 
; 7e3a aa       tax 
; 7e3b 00       brk 
; 7e3c 00       brk 
; 7e3d 00       brk 
; 7e3e 00       brk 
; 7e3f 00       brk 
; 7e40 00       brk 
; 7e41 aa       tax 
; 7e42 aa       tax 
; 7e43 00       brk 
; 7e44 00       brk 
; 7e45 00       brk 
; 7e46 00       brk 
; 7e47 00       brk 
; 7e48 00       brk 
; 7e49 aa       tax 
; 7e4a aa       tax 
; 7e4b 00       brk 
; 7e4c 00       brk 
; 7e4d 00       brk 
; 7e4e 00       brk 
; 7e4f 00       brk 
; 7e50 00       brk 
; 7e51 aa       tax 
; 7e52 40       rti 
; 7e53 2e 38 40 rol $4038
; 7e56 40       rti 
; 7e57 40       rti 
; 7e58 20 2a ae jsr $ae2a
; 7e5b 04       ???
; 7e5c 14       ???
; 7e5d 14       ???
; 7e5e 14       ???
; 7e5f 14       ???
; 7e60 14       ???
; 7e61 be 40 bc ldx $bc40,y
; 7e64 50 34    bvc $7e9a
; 7e66 14       ???
; 7e67 0c       ???
; 7e68 04       ???
; 7e69 ac aa 00 ldy $00aa
; 7e6c 00       brk 
; 7e6d 00       brk 
; 7e6e 00       brk 
; 7e6f 33       ???
; 7e70 32       ???
; 7e71 a9 aa    lda #$aa
; 7e73 00       brk 
; 7e74 00       brk 
; 7e75 00       brk 
; 7e76 00       brk 
; 7e77 33       ???
; 7e78 32       ???
; 7e79 a9 aa    lda #$aa
; 7e7b 00       brk 
; 7e7c 00       brk 
; 7e7d 00       brk 
; 7e7e 00       brk 
; 7e7f 33       ???
; 7e80 32       ???
; 7e81 a9 aa    lda #$aa
; 7e83 00       brk 
; 7e84 00       brk 
; 7e85 00       brk 
; 7e86 00       brk 
; 7e87 33       ???
; 7e88 32       ???
; 7e89 a9 aa    lda #$aa
; 7e8b 14       ???
; 7e8c 24 24    bit $24
; 7e8e 18       clc 
; 7e8f 18       clc 
; 7e90 14       ???
; 7e91 aa       tax 
; 7e92 aa       tax 
; 7e93 54       ???
; 7e94 98       tya 
; 7e95 98       tya 
; 7e96 94 80    sty $80,x
; 7e98 40       rti 
; 7e99 80       ???
; 7e9a 00       brk 
; 7e9b 00       brk 
; 7e9c 00       brk 
; 7e9d 00       brk 
; 7e9e 00       brk 
; 7e9f 00       brk 
; 7ea0 00       brk 
; 7ea1 80       ???
; 7ea2 00       brk 
; 7ea3 00       brk 
; 7ea4 00       brk 
; 7ea5 00       brk 
; 7ea6 00       brk 
; 7ea7 00       brk 
; 7ea8 00       brk 
; 7ea9 00       brk 
; 7eaa 00       brk 
; 7eab 00       brk 
; 7eac 00       brk 
; 7ead 00       brk 
; 7eae 00       brk 
; 7eaf 00       brk 
; 7eb0 00       brk 
; 7eb1 00       brk 
; 7eb2 00       brk 
; 7eb3 00       brk 
; 7eb4 00       brk 
; 7eb5 00       brk 
; 7eb6 00       brk 
; 7eb7 00       brk 
; 7eb8 00       brk 
; 7eb9 00       brk 
; 7eba 00       brk 
; 7ebb 00       brk 
; 7ebc 00       brk 
; 7ebd 00       brk 
; 7ebe 00       brk 
; 7ebf 00       brk 
; 7ec0 00       brk 
; 7ec1 00       brk 
; 7ec2 00       brk 
; 7ec3 00       brk 
; 7ec4 00       brk 
; 7ec5 00       brk 
; 7ec6 00       brk 
; 7ec7 00       brk 
; 7ec8 00       brk 
; 7ec9 00       brk 
; 7eca 00       brk 
; 7ecb 00       brk 
; 7ecc 00       brk 
; 7ecd 00       brk 
; 7ece 00       brk 
; 7ecf 00       brk 
; 7ed0 00       brk 
; 7ed1 02       ???
; 7ed2 04       ???
; 7ed3 04       ???
; 7ed4 04       ???
; 7ed5 04       ???
; 7ed6 04       ???
; 7ed7 04       ???
; 7ed8 04       ???
; 7ed9 02       ???
; 7eda 15 26    ora $26,x
; 7edc 22       ???
; 7edd 26 26    rol $26
; 7edf 11 00    ora ($00),y
; 7ee1 00       brk 
; 7ee2 14       ???
; 7ee3 24 24    bit $24
; 7ee5 18       clc 
; 7ee6 18       clc 
; 7ee7 14       ???
; 7ee8 00       brk 
; 7ee9 00       brk 
; 7eea 00       brk 
; 7eeb 00       brk 
; 7eec 00       brk 
; 7eed 00       brk 
; 7eee 00       brk 
; 7eef 00       brk 
; 7ef0 ff       ???
; 7ef1 ff       ???
; 7ef2 00       brk 
; 7ef3 00       brk 
; 7ef4 00       brk 
; 7ef5 00       brk 
; 7ef6 00       brk 
; 7ef7 00       brk 
; 7ef8 ff       ???
; 7ef9 ff       ???
; 7efa 00       brk 
; 7efb 00       brk 
; 7efc 00       brk 
; 7efd 00       brk 
; 7efe 00       brk 
; 7eff 00       brk 
; 7f00 ff       ???
; 7f01 ff       ???
; 7f02 00       brk 
; 7f03 00       brk 
; 7f04 00       brk 
; 7f05 00       brk 
; 7f06 00       brk 
; 7f07 00       brk 
; 7f08 ff       ???
; 7f09 7f       ???
; 7f0a 00       brk 
; 7f0b 00       brk 
; 7f0c 00       brk 
; 7f0d 00       brk 
; 7f0e 00       brk 
; 7f0f 00       brk 
; 7f10 00       brk 
; 7f11 80       ???
; 7f12 00       brk 
; 7f13 00       brk 
; 7f14 00       brk 
; 7f15 00       brk 
; 7f16 00       brk 
; 7f17 00       brk 
; 7f18 00       brk 
; 7f19 00       brk 
; 7f1a 00       brk 
; 7f1b 00       brk 
; 7f1c 00       brk 
; 7f1d 00       brk 
; 7f1e 00       brk 
; 7f1f 00       brk 
; 7f20 00       brk 
; 7f21 00       brk 
; 7f22 00       brk 
; 7f23 00       brk 
; 7f24 00       brk 
; 7f25 00       brk 
; 7f26 00       brk 
; 7f27 00       brk 
; 7f28 00       brk 
; 7f29 00       brk 
; 7f2a 00       brk 
; 7f2b 00       brk 
; 7f2c 00       brk 
; 7f2d 00       brk 
; 7f2e 00       brk 
; 7f2f 01 15    ora ($15,x)
; 7f31 14       ???
; 7f32 00       brk 
; 7f33 00       brk 
; 7f34 00       brk 
; 7f35 00       brk 
; 7f36 00       brk 
; 7f37 14       ???
; 7f38 14       ???
; 7f39 00       brk 
; 7f3a 00       brk 
; 7f3b 00       brk 
; 7f3c 00       brk 
; 7f3d 01 51    ora ($51,x)
; 7f3f 54       ???
; 7f40 04       ???
; 7f41 00       brk 
; 7f42 00       brk 
; 7f43 00       brk 
; 7f44 00       brk 
; 7f45 14       ???
; 7f46 d4       ???
; 7f47 c0 00    cpy #$00
; 7f49 00       brk 
; 7f4a 00       brk 
; 7f4b 00       brk 
; 7f4c 00       brk 
; 7f4d 45 45    eor $45
; 7f4f 00       brk 
; 7f50 00       brk 
; 7f51 00       brk 
; 7f52 00       brk 
; 7f53 00       brk 
; 7f54 00       brk 
; 7f55 15 15    ora $15,x
; 7f57 04       ???
; 7f58 04       ???
; 7f59 00       brk 
; 7f5a 00       brk 
; 7f5b 00       brk 
; 7f5c 00       brk 
; 7f5d 44       ???
; 7f5e 44       ???
; 7f5f 00       brk 
; 7f60 00       brk 
; 7f61 00       brk 
; 7f62 00       brk 
; 7f63 00       brk 
; 7f64 00       brk 
; 7f65 51 51    eor ($51),y
; 7f67 00       brk 
; 7f68 00       brk 
; 7f69 00       brk 
; 7f6a 00       brk 
; 7f6b 00       brk 
; 7f6c 00       brk 
; 7f6d 10 d4    bpl $7f43
; 7f6f c8       iny 
; 7f70 04       ???
; 7f71 00       brk 
; 7f72 00       brk 
; 7f73 00       brk 
; 7f74 00       brk 
; 7f75 00       brk 
; 7f76 50 51    bvc $7fc9
; 7f78 01 00    ora ($00,x)
; 7f7a 00       brk 
; 7f7b 00       brk 
; 7f7c 00       brk 
; 7f7d 00       brk 
; 7f7e 00       brk 
; 7f7f 40       rti 
; 7f80 45 05    eor $05
; 7f82 00       brk 
; 7f83 00       brk 
; 7f84 00       brk 
; 7f85 00       brk 
; 7f86 00       brk 
; 7f87 00       brk 
; 7f88 00       brk 
; 7f89 00       brk 
; 7f8a 00       brk 
; 7f8b 00       brk 
; 7f8c 00       brk 
; 7f8d 00       brk 
; 7f8e 00       brk 
; 7f8f 00       brk 
; 7f90 00       brk 
; 7f91 80       ???
; 7f92 00       brk 
; 7f93 04       ???
; 7f94 04       ???
; 7f95 00       brk 
; 7f96 00       brk 
; 7f97 00       brk 
; 7f98 20 a0 00 jsr $00a0
; 7f9b 41 41    eor ($41,x)
; 7f9d 00       brk 
; 7f9e 14       ???
; 7f9f 14       ???
; 7fa0 14       ???
; 7fa1 16 04    asl $04,x
; 7fa3 14       ???
; 7fa4 14       ???
; 7fa5 04       ???
; 7fa6 04       ???
; 7fa7 04       ???
; 7fa8 04       ???
; 7fa9 02       ???
; 7faa 00       brk 
; 7fab 00       brk 
; 7fac 00       brk 
; 7fad 00       brk 
; 7fae 00       brk 
; 7faf 0c       ???
; 7fb0 0b       ???
; 7fb1 ff       ???
; 7fb2 00       brk 
; 7fb3 00       brk 
; 7fb4 00       brk 
; 7fb5 00       brk 
; 7fb6 00       brk 
; 7fb7 cc cb bf cpy $bfcb
; 7fba 80       ???
; 7fbb c0 00    cpy #$00
; 7fbd 00       brk 
; 7fbe c0 8c    cpy #$8c
; 7fc0 cb       ???
; 7fc1 ff       ???
; 7fc2 00       brk 
; 7fc3 00       brk 
; 7fc4 00       brk 
; 7fc5 00       brk 
; 7fc6 00       brk 
; 7fc7 cc cb ff cpy $ffcb
; 7fca 00       brk 
; 7fcb 14       ???
; 7fcc 25 26    and $26
; 7fce 29 25    and #$25
; 7fd0 11 00    ora ($00),y
; 7fd2 00       brk 
; 7fd3 10 20    bpl $7ff5
; 7fd5 20 20 24 jsr $2420
; 7fd8 14       ???
; 7fd9 80       ???
; 7fda 00       brk 
; 7fdb 00       brk 
; 7fdc 00       brk 
; 7fdd 00       brk 
; 7fde 00       brk 
; 7fdf 00       brk 
; 7fe0 00       brk 
; 7fe1 80       ???
; 7fe2 00       brk 
; 7fe3 00       brk 
; 7fe4 00       brk 
; 7fe5 00       brk 
; 7fe6 00       brk 
; 7fe7 00       brk 
; 7fe8 00       brk 
; 7fe9 00       brk 
; 7fea 00       brk 
; 7feb 00       brk 
; 7fec 00       brk 
; 7fed 00       brk 
; 7fee 00       brk 
; 7fef 00       brk 
; 7ff0 00       brk 
; 7ff1 00       brk 
; 7ff2 00       brk 
; 7ff3 00       brk 
; 7ff4 00       brk 
; 7ff5 00       brk 
; 7ff6 00       brk 
; 7ff7 00       brk 
; 7ff8 00       brk 
; 7ff9 00       brk 
; 7ffa 00       brk 
; 7ffb 00       brk 
; 7ffc 00       brk 
; 7ffd 00       brk 
; 7ffe 00       brk 
; 7fff 00       brk 
; 8000 00       brk 
; 8001 00       brk 
; 8002 00       brk 
; 8003 00       brk 
; 8004 00       brk 
; 8005 00       brk 
; 8006 00       brk 
; 8007 00       brk 
; 8008 00       brk 
; 8009 00       brk 
; 800a 00       brk 
; 800b 00       brk 
; 800c 00       brk 
; 800d 00       brk 
; 800e 00       brk 
; 800f 00       brk 
; 8010 00       brk 
; 8011 02       ???
; 8012 04       ???
; 8013 04       ???
; 8014 04       ???
; 8015 04       ???
; 8016 04       ???
; 8017 04       ???
; 8018 04       ???
; 8019 02       ???
; 801a 14       ???
; 801b 24 24    bit $24
; 801d 24 20    bit $20
; 801f 10 00    bpl $8021
; 8021 00       brk 
; 8022 44       ???
; 8023 88       dey 
; 8024 88       dey 
; 8025 88       dey 
; 8026 54       ???
; 8027 10 00    bpl $8029
; 8029 00       brk 
; 802a 00       brk 
; 802b 00       brk 
; 802c 00       brk 
; 802d 00       brk 
; 802e 00       brk 
; 802f c3       ???
; 8030 c2       ???
; 8031 ff       ???
; 8032 00       brk 
; 8033 00       brk 
; 8034 00       brk 
; 8035 00       brk 
; 8036 00       brk 
; 8037 0c       ???
; 8038 0b       ???
; 8039 ff       ???
; 803a 00       brk 
; 803b 00       brk 
; 803c 00       brk 
; 803d 00       brk 
; 803e 00       brk 
; 803f 30 2f    bmi $8070
; 8041 ff       ???
; 8042 00       brk 
; 8043 00       brk 
; 8044 00       brk 
; 8045 00       brk 
; 8046 00       brk 
; 8047 c3       ???
; 8048 c2       ???
; 8049 7f       ???
; 804a 00       brk 
; 804b 00       brk 
; 804c 00       brk 
; 804d 00       brk 
; 804e 00       brk 
; 804f 00       brk 
; 8050 00       brk 
; 8051 80       ???
; 8052 00       brk 
; 8053 00       brk 
; 8054 00       brk 
; 8055 00       brk 
; 8056 00       brk 
; 8057 01 05    ora ($05,x)
; 8059 04       ???
; 805a 00       brk 
; 805b 00       brk 
; 805c 05 15    ora $15
; 805e 50 40    bvc $80a0
; 8060 00       brk 
; 8061 01 15    ora ($15,x)
; 8063 54       ???
; 8064 44       ???
; 8065 04       ???
; 8066 00       brk 
; 8067 00       brk 
; 8068 00       brk 
; 8069 00       brk 
; 806a 00       brk 
; 806b 00       brk 
; 806c 44       ???
; 806d 44       ???
; 806e 00       brk 
; 806f 00       brk 
; 8070 00       brk 
; 8071 00       brk 
; 8072 00       brk 
; 8073 00       brk 
; 8074 44       ???
; 8075 45 01    eor $01
; 8077 04       ???
; 8078 04       ???
; 8079 10 10    bpl $808b
; 807b 40       rti 
; 807c 84 44    sty $44
; 807e 00       brk 
; 807f 00       brk 
; 8080 00       brk 
; 8081 0c       ???
; 8082 0c       ???
; 8083 00       brk 
; 8084 44       ???
; 8085 44       ???
; 8086 00       brk 
; 8087 00       brk 
; 8088 00       brk 
; 8089 00       brk 
; 808a 00       brk 
; 808b 00       brk 
; 808c c4 c4    cpy $c4
; 808e 00       brk 
; 808f 0c       ???
; 8090 0c       ???
; 8091 04       ???
; 8092 04       ???
; 8093 04       ???
; 8094 44       ???
; 8095 44       ???
; 8096 04       ???
; 8097 04       ???
; 8098 04       ???
; 8099 00       brk 
; 809a 00       brk 
; 809b 00       brk 
; 809c 44       ???
; 809d 44       ???
; 809e 00       brk 
; 809f 0c       ???
; 80a0 0c       ???
; 80a1 0c       ???
; 80a2 0c       ???
; 80a3 00       brk 
; 80a4 c4 c4    cpy $c4
; 80a6 00       brk 
; 80a7 00       brk 
; 80a8 00       brk 
; 80a9 01 01    ora ($01,x)
; 80ab 00       brk 
; 80ac 44       ???
; 80ad 44       ???
; 80ae 00       brk 
; 80af 00       brk 
; 80b0 00       brk 
; 80b1 00       brk 
; 80b2 00       brk 
; 80b3 40       rti 
; 80b4 44       ???
; 80b5 14       ???
; 80b6 10 04    bpl $80bc
; 80b8 04       ???
; 80b9 00       brk 
; 80ba 00       brk 
; 80bb 00       brk 
; 80bc 44       ???
; 80bd 44       ???
; 80be 00       brk 
; 80bf 00       brk 
; 80c0 00       brk 
; 80c1 40       rti 
; 80c2 45 05    eor $05
; 80c4 44       ???
; 80c5 44       ???
; 80c6 00       brk 
; 80c7 00       brk 
; 80c8 00       brk 
; 80c9 00       brk 
; 80ca 00       brk 
; 80cb 40       rti 
; 80cc 54       ???
; 80cd 15 01    ora $01,x
; 80cf 00       brk 
; 80d0 00       brk 
; 80d1 20 40 48 jsr $4840
; 80d4 30 12    bmi $80e8
; 80d6 4c 52 14 jmp $1452
; 80d9 04       ???
; 80da 14       ???
; 80db 14       ???
; 80dc 14       ???
; 80dd 14       ???
; 80de aa       tax 
; 80df aa       tax 
; 80e0 00       brk 
; 80e1 0a       asl a
; 80e2 14       ???
; 80e3 30 4c    bmi $8131
; 80e5 bc 40 ac ldy $ac40,x
; 80e8 04       ???
; 80e9 02       ???
; 80ea 00       brk 
; 80eb 00       brk 
; 80ec 00       brk 
; 80ed 00       brk 
; 80ee 00       brk 
; 80ef 0c       ???
; 80f0 0b       ???
; 80f1 ff       ???
; 80f2 00       brk 
; 80f3 00       brk 
; 80f4 00       brk 
; 80f5 00       brk 
; 80f6 00       brk 
; 80f7 30 2f    bmi $8128
; 80f9 bf       ???
; 80fa 80       ???
; 80fb c0 00    cpy #$00
; 80fd 00       brk 
; 80fe c0 83    cpy #$83
; 8100 c2       ???
; 8101 ff       ???
; 8102 00       brk 
; 8103 00       brk 
; 8104 00       brk 
; 8105 00       brk 
; 8106 00       brk 
; 8107 0c       ???
; 8108 0b       ???
; 8109 ff       ???
; 810a 14       ???
; 810b 25 22    and $22
; 810d 22       ???
; 810e 25 14    and $14
; 8110 00       brk 
; 8111 00       brk 
; 8112 14       ???
; 8113 24 20    bit $20
; 8115 20 24 14 jsr $1424
; 8118 00       brk 
; 8119 80       ???
; 811a 00       brk 
; 811b 00       brk 
; 811c 00       brk 
; 811d 00       brk 
; 811e 00       brk 
; 811f 00       brk 
; 8120 00       brk 
; 8121 80       ???
; 8122 00       brk 
; 8123 00       brk 
; 8124 00       brk 
; 8125 00       brk 
; 8126 00       brk 
; 8127 00       brk 
; 8128 00       brk 
; 8129 00       brk 
; 812a 00       brk 
; 812b 00       brk 
; 812c 00       brk 
; 812d 00       brk 
; 812e 00       brk 
; 812f 00       brk 
; 8130 00       brk 
; 8131 00       brk 
; 8132 00       brk 
; 8133 00       brk 
; 8134 00       brk 
; 8135 00       brk 
; 8136 00       brk 
; 8137 00       brk 
; 8138 00       brk 
; 8139 00       brk 
; 813a 00       brk 
; 813b 00       brk 
; 813c 00       brk 
; 813d 00       brk 
; 813e 00       brk 
; 813f 00       brk 
; 8140 00       brk 
; 8141 00       brk 
; 8142 00       brk 
; 8143 00       brk 
; 8144 00       brk 
; 8145 00       brk 
; 8146 00       brk 
; 8147 00       brk 
; 8148 00       brk 
; 8149 00       brk 
; 814a 00       brk 
; 814b 00       brk 
; 814c 00       brk 
; 814d 00       brk 
; 814e 00       brk 
; 814f 00       brk 
; 8150 00       brk 
; 8151 02       ???
; 8152 04       ???
; 8153 04       ???
; 8154 04       ???
; 8155 04       ???
; 8156 04       ???
; 8157 04       ???
; 8158 04       ???
; 8159 02       ???
; 815a 14       ???
; 815b 24 20    bit $20
; 815d 20 24 14 jsr $1424
; 8160 00       brk 
; 8161 00       brk 
; 8162 54       ???
; 8163 64       ???
; 8164 20 20 20 jsr $2020
; 8167 10 00    bpl $8169
; 8169 00       brk 
; 816a 00       brk 
; 816b 00       brk 
; 816c 00       brk 
; 816d 00       brk 
; 816e 00       brk 
; 816f c0 bf    cpy #$bf
; 8171 ff       ???
; 8172 00       brk 
; 8173 00       brk 
; 8174 00       brk 
; 8175 00       brk 
; 8176 00       brk 
; 8177 c0 bf    cpy #$bf
; 8179 ff       ???
; 817a 00       brk 
; 817b 00       brk 
; 817c 00       brk 
; 817d 00       brk 
; 817e 00       brk 
; 817f c0 bf    cpy #$bf
; 8181 ff       ???
; 8182 00       brk 
; 8183 00       brk 
; 8184 00       brk 
; 8185 00       brk 
; 8186 00       brk 
; 8187 c0 bf    cpy #$bf
; 8189 7f       ???
; 818a 00       brk 
; 818b 00       brk 
; 818c 00       brk 
; 818d 00       brk 
; 818e 00       brk 
; 818f 00       brk 
; 8190 00       brk 
; 8191 80       ???
; 8192 10 20    bpl $81b4
; 8194 50 84    bvc $811a
; 8196 44       ???
; 8197 40       rti 
; 8198 40       rti 
; 8199 00       brk 
; 819a 00       brk 
; 819b 00       brk 
; 819c 00       brk 
; 819d 44       ???
; 819e 44       ???
; 819f 00       brk 
; 81a0 00       brk 
; 81a1 00       brk 
; 81a2 00       brk 
; 81a3 00       brk 
; 81a4 00       brk 
; 81a5 44       ???
; 81a6 44       ???
; 81a7 00       brk 
; 81a8 00       brk 
; 81a9 00       brk 
; 81aa 00       brk 
; 81ab 00       brk 
; 81ac 00       brk 
; 81ad 44       ???
; 81ae 44       ???
; 81af 04       ???
; 81b0 04       ???
; 81b1 10 10    bpl $81c3
; 81b3 40       rti 
; 81b4 40       rti 
; 81b5 44       ???
; 81b6 44       ???
; 81b7 00       brk 
; 81b8 00       brk 
; 81b9 00       brk 
; 81ba 00       brk 
; 81bb 00       brk 
; 81bc 00       brk 
; 81bd 44       ???
; 81be 44       ???
; 81bf 00       brk 
; 81c0 00       brk 
; 81c1 00       brk 
; 81c2 00       brk 
; 81c3 00       brk 
; 81c4 00       brk 
; 81c5 44       ???
; 81c6 44       ???
; 81c7 00       brk 
; 81c8 00       brk 
; 81c9 00       brk 
; 81ca 00       brk 
; 81cb 00       brk 
; 81cc 00       brk 
; 81cd 44       ???
; 81ce 44       ???
; 81cf 00       brk 
; 81d0 00       brk 
; 81d1 04       ???
; 81d2 c4 c4    cpy $c4
; 81d4 04       ???
; 81d5 48       pha 
; 81d6 72       ???
; 81d7 2e 04 00 rol $0004
; 81da c0 c0    cpy #$c0
; 81dc 00       brk 
; 81dd 44       ???
; 81de 44       ???
; 81df 00       brk 
; 81e0 00       brk 
; 81e1 00       brk 
; 81e2 00       brk 
; 81e3 00       brk 
; 81e4 00       brk 
; 81e5 44       ???
; 81e6 44       ???
; 81e7 00       brk 
; 81e8 00       brk 
; 81e9 00       brk 
; 81ea 00       brk 
; 81eb 00       brk 
; 81ec 00       brk 
; 81ed 44       ???
; 81ee 44       ???
; 81ef 00       brk 
; 81f0 00       brk 
; 81f1 01 01    ora ($01,x)
; 81f3 00       brk 
; 81f4 00       brk 
; 81f5 44       ???
; 81f6 44       ???
; 81f7 00       brk 
; 81f8 00       brk 
; 81f9 00       brk 
; 81fa 00       brk 
; 81fb 40       rti 
; 81fc 40       rti 
; 81fd 44       ???
; 81fe 44       ???
; 81ff 04       ???
; 8200 04       ???
; 8201 00       brk 
; 8202 00       brk 
; 8203 00       brk 
; 8204 00       brk 
; 8205 44       ???
; 8206 44       ???
; 8207 00       brk 
; 8208 00       brk 
; 8209 00       brk 
; 820a 00       brk 
; 820b 00       brk 
; 820c 00       brk 
; 820d 44       ???
; 820e 44       ???
; 820f 00       brk 
; 8210 00       brk 
; 8211 04       ???
; 8212 05 02    ora $02
; 8214 01 44    ora ($44,x)
; 8216 44       ???
; 8217 00       brk 
; 8218 00       brk 
; 8219 00       brk 
; 821a 00       brk 
; 821b 00       brk 
; 821c 40       rti 
; 821d 40       rti 
; 821e 40       rti 
; 821f 40       rti 
; 8220 40       rti 
; 8221 42       ???
; 8222 04       ???
; 8223 04       ???
; 8224 04       ???
; 8225 04       ???
; 8226 04       ???
; 8227 04       ???
; 8228 04       ???
; 8229 02       ???
; 822a 00       brk 
; 822b 00       brk 
; 822c 00       brk 
; 822d 00       brk 
; 822e 00       brk 
; 822f 00       brk 
; 8230 ff       ???
; 8231 ff       ???
; 8232 00       brk 
; 8233 00       brk 
; 8234 00       brk 
; 8235 00       brk 
; 8236 00       brk 
; 8237 00       brk 
; 8238 ff       ???
; 8239 ff       ???
; 823a 00       brk 
; 823b 00       brk 
; 823c 00       brk 
; 823d 00       brk 
; 823e 00       brk 
; 823f 00       brk 
; 8240 ff       ???
; 8241 ff       ???
; 8242 00       brk 
; 8243 00       brk 
; 8244 00       brk 
; 8245 00       brk 
; 8246 00       brk 
; 8247 00       brk 
; 8248 ff       ???
; 8249 ff       ???
; 824a 01 06    ora ($06,x)
; 824c 06 02    asl $02
; 824e 06 05    asl $05
; 8250 00       brk 
; 8251 00       brk 
; 8252 00       brk 
; 8253 00       brk 
; 8254 00       brk 
; 8255 00       brk 
; 8256 40       rti 
; 8257 40       rti 
; 8258 00       brk 
; 8259 80       ???
; 825a 00       brk 
; 825b 00       brk 
; 825c 00       brk 
; 825d 00       brk 
; 825e 00       brk 
; 825f 00       brk 
; 8260 00       brk 
; 8261 80       ???
; 8262 00       brk 
; 8263 00       brk 
; 8264 00       brk 
; 8265 00       brk 
; 8266 00       brk 
; 8267 00       brk 
; 8268 00       brk 
; 8269 00       brk 
; 826a 00       brk 
; 826b 00       brk 
; 826c 00       brk 
; 826d 00       brk 
; 826e 00       brk 
; 826f 00       brk 
; 8270 00       brk 
; 8271 00       brk 
; 8272 00       brk 
; 8273 00       brk 
; 8274 00       brk 
; 8275 00       brk 
; 8276 00       brk 
; 8277 00       brk 
; 8278 00       brk 
; 8279 00       brk 
; 827a 00       brk 
; 827b 00       brk 
; 827c 00       brk 
; 827d 00       brk 
; 827e 00       brk 
; 827f 00       brk 
; 8280 00       brk 
; 8281 00       brk 
; 8282 00       brk 
; 8283 00       brk 
; 8284 00       brk 
; 8285 00       brk 
; 8286 00       brk 
; 8287 00       brk 
; 8288 00       brk 
; 8289 00       brk 
; 828a 00       brk 
; 828b 00       brk 
; 828c 00       brk 
; 828d 00       brk 
; 828e 00       brk 
; 828f 00       brk 
; 8290 00       brk 
; 8291 02       ???
; 8292 04       ???
; 8293 04       ???
; 8294 04       ???
; 8295 04       ???
; 8296 04       ???
; 8297 04       ???
; 8298 04       ???
; 8299 02       ???
; 829a 10 20    bpl $82bc
; 829c 20 20 24 jsr $2420
; 829f 14       ???
; 82a0 00       brk 
; 82a1 00       brk 
; 82a2 54       ???
; 82a3 64       ???
; 82a4 20 20 20 jsr $2020
; 82a7 10 00    bpl $82a9
; 82a9 00       brk 
; 82aa 00       brk 
; 82ab 00       brk 
; 82ac 00       brk 
; 82ad 00       brk 
; 82ae 00       brk 
; 82af c3       ???
; 82b0 c2       ???
; 82b1 ff       ???
; 82b2 00       brk 
; 82b3 00       brk 
; 82b4 00       brk 
; 82b5 00       brk 
; 82b6 00       brk 
; 82b7 0c       ???
; 82b8 0b       ???
; 82b9 ff       ???
; 82ba 00       brk 
; 82bb 00       brk 
; 82bc 00       brk 
; 82bd 00       brk 
; 82be 00       brk 
; 82bf 30 2f    bmi $82f0
; 82c1 ff       ???
; 82c2 00       brk 
; 82c3 00       brk 
; 82c4 00       brk 
; 82c5 00       brk 
; 82c6 00       brk 
; 82c7 c0 bf    cpy #$bf
; 82c9 7f       ???
; 82ca 00       brk 
; 82cb 00       brk 
; 82cc 00       brk 
; 82cd 00       brk 
; 82ce 00       brk 
; 82cf 00       brk 
; 82d0 00       brk 
; 82d1 c0 50    cpy #$50
; 82d3 20 14 08 jsr $0814
; 82d6 05 01    ora $01
; 82d8 00       brk 
; 82d9 00       brk 
; 82da 00       brk 
; 82db 00       brk 
; 82dc 00       brk 
; 82dd 00       brk 
; 82de 40       rti 
; 82df 84 54    sty $54
; 82e1 10 00    bpl $82e3
; 82e3 00       brk 
; 82e4 00       brk 
; 82e5 01 01    ora ($01,x)
; 82e7 44       ???
; 82e8 44       ???
; 82e9 10 10    bpl $82fb
; 82eb 40       rti 
; 82ec 40       rti 
; 82ed 00       brk 
; 82ee 00       brk 
; 82ef 44       ???
; 82f0 44       ???
; 82f1 00       brk 
; 82f2 00       brk 
; 82f3 00       brk 
; 82f4 00       brk 
; 82f5 00       brk 
; 82f6 00       brk 
; 82f7 44       ???
; 82f8 44       ???
; 82f9 00       brk 
; 82fa 00       brk 
; 82fb 00       brk 
; 82fc 00       brk 
; 82fd 00       brk 
; 82fe 00       brk 
; 82ff 44       ???
; 8300 44       ???
; 8301 00       brk 
; 8302 00       brk 
; 8303 00       brk 
; 8304 00       brk 
; 8305 00       brk 
; 8306 00       brk 
; 8307 44       ???
; 8308 44       ???
; 8309 00       brk 
; 830a 00       brk 
; 830b 00       brk 
; 830c 00       brk 
; 830d 00       brk 
; 830e 00       brk 
; 830f 44       ???
; 8310 44       ???
; 8311 04       ???
; 8312 04       ???
; 8313 04       ???
; 8314 04       ???
; 8315 04       ???
; 8316 04       ???
; 8317 44       ???
; 8318 44       ???
; 8319 00       brk 
; 831a 00       brk 
; 831b 00       brk 
; 831c 00       brk 
; 831d 00       brk 
; 831e 00       brk 
; 831f 44       ???
; 8320 44       ???
; 8321 00       brk 
; 8322 00       brk 
; 8323 00       brk 
; 8324 00       brk 
; 8325 00       brk 
; 8326 00       brk 
; 8327 44       ???
; 8328 44       ???
; 8329 00       brk 
; 832a 00       brk 
; 832b 00       brk 
; 832c 00       brk 
; 832d 00       brk 
; 832e 00       brk 
; 832f 44       ???
; 8330 44       ???
; 8331 00       brk 
; 8332 00       brk 
; 8333 00       brk 
; 8334 00       brk 
; 8335 00       brk 
; 8336 00       brk 
; 8337 44       ???
; 8338 44       ???
; 8339 01 01    ora ($01,x)
; 833b 00       brk 
; 833c 00       brk 
; 833d 00       brk 
; 833e 00       brk 
; 833f 44       ???
; 8340 44       ???
; 8341 00       brk 
; 8342 00       brk 
; 8343 40       rti 
; 8344 40       rti 
; 8345 10 10    bpl $8357
; 8347 44       ???
; 8348 44       ???
; 8349 00       brk 
; 834a 00       brk 
; 834b 00       brk 
; 834c 00       brk 
; 834d 00       brk 
; 834e 00       brk 
; 834f 44       ???
; 8350 45 01    eor $01
; 8352 01 02    ora ($02,x)
; 8354 06 09    asl $09
; 8356 14       ???
; 8357 50 40    bvc $8399
; 8359 40       rti 
; 835a 40       rti 
; 835b 00       brk 
; 835c 00       brk 
; 835d 00       brk 
; 835e 00       brk 
; 835f 00       brk 
; 8360 00       brk 
; 8361 02       ???
; 8362 04       ???
; 8363 04       ???
; 8364 04       ???
; 8365 04       ???
; 8366 04       ???
; 8367 04       ???
; 8368 04       ???
; 8369 02       ???
; 836a 00       brk 
; 836b 00       brk 
; 836c 00       brk 
; 836d 00       brk 
; 836e 00       brk 
; 836f 00       brk 
; 8370 ff       ???
; 8371 ff       ???
; 8372 00       brk 
; 8373 00       brk 
; 8374 00       brk 
; 8375 00       brk 
; 8376 00       brk 
; 8377 00       brk 
; 8378 ff       ???
; 8379 ff       ???
; 837a 00       brk 
; 837b 00       brk 
; 837c 00       brk 
; 837d 00       brk 
; 837e 00       brk 
; 837f 00       brk 
; 8380 ff       ???
; 8381 ff       ???
; 8382 00       brk 
; 8383 00       brk 
; 8384 00       brk 
; 8385 00       brk 
; 8386 00       brk 
; 8387 00       brk 
; 8388 ff       ???
; 8389 04       ???
; 838a 05 05    ora $05
; 838c 09 09    ora #$09
; 838e 05 00    ora $00
; 8390 00       brk 
; 8391 40       rti 
; 8392 80       ???
; 8393 80       ???
; 8394 40       rti 
; 8395 40       rti 
; 8396 40       rti 
; 8397 00       brk 
; 8398 00       brk 
; 8399 80       ???
; 839a 00       brk 
; 839b 00       brk 
; 839c 00       brk 
; 839d 00       brk 
; 839e 00       brk 
; 839f 00       brk 
; 83a0 00       brk 
; 83a1 80       ???
; 83a2 00       brk 
; 83a3 00       brk 
; 83a4 00       brk 
; 83a5 00       brk 
; 83a6 00       brk 
; 83a7 00       brk 
; 83a8 00       brk 
; 83a9 00       brk 
; 83aa 00       brk 
; 83ab 00       brk 
; 83ac 00       brk 
; 83ad 00       brk 
; 83ae 00       brk 
; 83af 00       brk 
; 83b0 00       brk 
; 83b1 00       brk 
; 83b2 00       brk 
; 83b3 00       brk 
; 83b4 00       brk 
; 83b5 00       brk 
; 83b6 00       brk 
; 83b7 00       brk 
; 83b8 00       brk 
; 83b9 00       brk 
; 83ba 00       brk 
; 83bb 00       brk 
; 83bc 00       brk 
; 83bd 00       brk 
; 83be 00       brk 
; 83bf 00       brk 
; 83c0 00       brk 
; 83c1 00       brk 
; 83c2 00       brk 
; 83c3 00       brk 
; 83c4 00       brk 
; 83c5 00       brk 
; 83c6 00       brk 
; 83c7 00       brk 
; 83c8 00       brk 
; 83c9 00       brk 
; 83ca 00       brk 
; 83cb 00       brk 
; 83cc 00       brk 
; 83cd 00       brk 
; 83ce 00       brk 
; 83cf 00       brk 
; 83d0 00       brk 
; 83d1 02       ???
; 83d2 04       ???
; 83d3 04       ???
; 83d4 04       ???
; 83d5 04       ???
; 83d6 04       ???
; 83d7 04       ???
; 83d8 04       ???
; 83d9 02       ???
; 83da 15 26    ora $26,x
; 83dc 26 26    rol $26
; 83de 22       ???
; 83df 11 00    ora ($00),y
; 83e1 00       brk 
; 83e2 10 20    bpl $8404
; 83e4 20 20 24 jsr $2420
; 83e7 14       ???
; 83e8 00       brk 
; 83e9 00       brk 
; 83ea 00       brk 
; 83eb 00       brk 
; 83ec 00       brk 
; 83ed 00       brk 
; 83ee 00       brk 
; 83ef c3       ???
; 83f0 c2       ???
; 83f1 ff       ???
; 83f2 00       brk 
; 83f3 00       brk 
; 83f4 00       brk 
; 83f5 00       brk 
; 83f6 00       brk 
; 83f7 03       ???
; 83f8 02       ???
; 83f9 ff       ???
; 83fa 00       brk 
; 83fb 00       brk 
; 83fc 00       brk 
; 83fd 00       brk 
; 83fe 00       brk 
; 83ff 03       ???
; 8400 02       ???
; 8401 ff       ???
; 8402 00       brk 
; 8403 00       brk 
; 8404 00       brk 
; 8405 00       brk 
; 8406 00       brk 
; 8407 00       brk 
; 8408 ff       ???
; 8409 7f       ???
; 840a 00       brk 
; 840b 00       brk 
; 840c 00       brk 
; 840d 00       brk 
; 840e 00       brk 
; 840f 00       brk 
; 8410 00       brk 
; 8411 d5 aa    cmp $aa,x
; 8413 a5 a0    lda $a0
; 8415 a5 aa    lda $aa
; 8417 a5 a0    lda $a0
; 8419 54       ???
; 841a 05 01    ora $01
; 841c 00       brk 
; 841d 00       brk 
; 841e 00       brk 
; 841f 00       brk 
; 8420 00       brk 
; 8421 10 50    bpl $8473
; 8423 50 11    bvc $8436
; 8425 01 00    ora ($00,x)
; 8427 00       brk 
; 8428 00       brk 
; 8429 00       brk 
; 842a 00       brk 
; 842b 00       brk 
; 842c 40       rti 
; 842d 54       ???
; 842e 14       ???
; 842f 00       brk 
; 8430 00       brk 
; 8431 00       brk 
; 8432 00       brk 
; 8433 00       brk 
; 8434 00       brk 
; 8435 00       brk 
; 8436 50 51    bvc $8489
; 8438 01 00    ora ($00,x)
; 843a 00       brk 
; 843b 00       brk 
; 843c 00       brk 
; 843d 00       brk 
; 843e 00       brk 
; 843f 44       ???
; 8440 44       ???
; 8441 00       brk 
; 8442 00       brk 
; 8443 00       brk 
; 8444 00       brk 
; 8445 00       brk 
; 8446 00       brk 
; 8447 00       brk 
; 8448 51 51    eor ($51),y
; 844a 00       brk 
; 844b 00       brk 
; 844c 00       brk 
; 844d 00       brk 
; 844e 00       brk 
; 844f 00       brk 
; 8450 14       ???
; 8451 18       clc 
; 8452 04       ???
; 8453 04       ???
; 8454 04       ???
; 8455 04       ???
; 8456 04       ???
; 8457 04       ???
; 8458 49 45    eor #$45
; 845a 00       brk 
; 845b 00       brk 
; 845c 00       brk 
; 845d 00       brk 
; 845e 00       brk 
; 845f 00       brk 
; 8460 11 11    ora ($11),y
; 8462 00       brk 
; 8463 00       brk 
; 8464 00       brk 
; 8465 00       brk 
; 8466 00       brk 
; 8467 00       brk 
; 8468 44       ???
; 8469 44       ???
; 846a 00       brk 
; 846b 00       brk 
; 846c 00       brk 
; 846d 00       brk 
; 846e 00       brk 
; 846f 11 51    ora ($51),y
; 8471 40       rti 
; 8472 00       brk 
; 8473 00       brk 
; 8474 00       brk 
; 8475 00       brk 
; 8476 05 45    ora $45
; 8478 40       rti 
; 8479 00       brk 
; 847a 00       brk 
; 847b 00       brk 
; 847c 00       brk 
; 847d 14       ???
; 847e 14       ???
; 847f 00       brk 
; 8480 00       brk 
; 8481 01 01    ora ($01,x)
; 8483 05 55    ora $55
; 8485 50 00    bvc $8487
; 8487 00       brk 
; 8488 00       brk 
; 8489 04       ???
; 848a 44       ???
; 848b 40       rti 
; 848c 00       brk 
; 848d 00       brk 
; 848e 00       brk 
; 848f 00       brk 
; 8490 00       brk 
; 8491 00       brk 
; 8492 00       brk 
; 8493 00       brk 
; 8494 00       brk 
; 8495 00       brk 
; 8496 00       brk 
; 8497 00       brk 
; 8498 00       brk 
; 8499 55 aa    eor $aa,x
; 849b 95 80    sta $80,x
; 849d 95 aa    sta $aa,x
; 849f 56 02    lsr $02,x
; 84a1 03       ???
; 84a2 04       ???
; 84a3 04       ???
; 84a4 04       ???
; 84a5 04       ???
; 84a6 04       ???
; 84a7 04       ???
; 84a8 04       ???
; 84a9 02       ???
; 84aa 00       brk 
; 84ab 00       brk 
; 84ac 00       brk 
; 84ad 00       brk 
; 84ae 00       brk 
; 84af 00       brk 
; 84b0 ff       ???
; 84b1 ff       ???
; 84b2 00       brk 
; 84b3 00       brk 
; 84b4 00       brk 
; 84b5 00       brk 
; 84b6 00       brk 
; 84b7 00       brk 
; 84b8 ff       ???
; 84b9 ff       ???
; 84ba 00       brk 
; 84bb 00       brk 
; 84bc 00       brk 
; 84bd 00       brk 
; 84be 00       brk 
; 84bf 00       brk 
; 84c0 ff       ???
; 84c1 ff       ???
; 84c2 00       brk 
; 84c3 00       brk 
; 84c4 00       brk 
; 84c5 00       brk 
; 84c6 00       brk 
; 84c7 00       brk 
; 84c8 ff       ???
; 84c9 04       ???
; 84ca 05 05    ora $05
; 84cc 05 05    ora $05
; 84ce 05 00    ora $00
; 84d0 04       ???
; 84d1 44       ???
; 84d2 80       ???
; 84d3 80       ???
; 84d4 80       ???
; 84d5 80       ???
; 84d6 40       rti 
; 84d7 00       brk 
; 84d8 00       brk 
; 84d9 80       ???
; 84da 00       brk 
; 84db 00       brk 
; 84dc 00       brk 
; 84dd 00       brk 
; 84de 00       brk 
; 84df 00       brk 
; 84e0 00       brk 
; 84e1 80       ???
; 84e2 00       brk 
; 84e3 00       brk 
; 84e4 00       brk 
; 84e5 00       brk 
; 84e6 00       brk 
; 84e7 00       brk 
; 84e8 00       brk 
; 84e9 00       brk 
; 84ea 00       brk 
; 84eb 00       brk 
; 84ec 00       brk 
; 84ed 00       brk 
; 84ee 00       brk 
; 84ef 00       brk 
; 84f0 00       brk 
; 84f1 00       brk 
; 84f2 00       brk 
; 84f3 00       brk 
; 84f4 00       brk 
; 84f5 00       brk 
; 84f6 00       brk 
; 84f7 00       brk 
; 84f8 00       brk 
; 84f9 00       brk 
; 84fa 00       brk 
; 84fb 00       brk 
; 84fc 00       brk 
; 84fd 00       brk 
; 84fe 00       brk 
; 84ff 00       brk 
; 8500 00       brk 
; 8501 00       brk 
; 8502 00       brk 
; 8503 00       brk 
; 8504 00       brk 
; 8505 00       brk 
; 8506 00       brk 
; 8507 00       brk 
; 8508 00       brk 
; 8509 00       brk 
; 850a 00       brk 
; 850b 00       brk 
; 850c 00       brk 
; 850d 00       brk 
; 850e 00       brk 
; 850f 00       brk 
; 8510 00       brk 
; 8511 02       ???
; 8512 04       ???
; 8513 04       ???
; 8514 04       ???
; 8515 04       ???
; 8516 04       ???
; 8517 04       ???
; 8518 04       ???
; 8519 02       ???
; 851a 00       brk 
; 851b 33       ???
; 851c 48       pha 
; 851d 26 11    rol $11
; 851f 00       brk 
; 8520 aa       tax 
; 8521 aa       tax 
; 8522 00       brk 
; 8523 f0 4c    beq $8571
; 8525 ac 50 00 ldy $0050
; 8528 aa       tax 
; 8529 aa       tax 
; 852a 54       ???
; 852b a8       tay 
; 852c a8       tay 
; 852d a8       tay 
; 852e a8       tay 
; 852f 54       ???
; 8530 aa       tax 
; 8531 aa       tax 
; 8532 54       ???
; 8533 a8       tay 
; 8534 a8       tay 
; 8535 a8       tay 
; 8536 a8       tay 
; 8537 54       ???
; 8538 aa       tax 
; 8539 aa       tax 
; 853a 54       ???
; 853b a8       tay 
; 853c a8       tay 
; 853d a8       tay 
; 853e a8       tay 
; 853f 54       ???
; 8540 aa       tax 
; 8541 aa       tax 
; 8542 54       ???
; 8543 a8       tay 
; 8544 a8       tay 
; 8545 a8       tay 
; 8546 a8       tay 
; 8547 54       ???
; 8548 aa       tax 
; 8549 2a       rol a
; 854a 00       brk 
; 854b 00       brk 
; 854c 00       brk 
; 854d 20 38 2e jsr $2e38
; 8550 40       rti 
; 8551 ff       ???
; 8552 aa       tax 
; 8553 55 00    eor $00,x
; 8555 00       brk 
; 8556 00       brk 
; 8557 00       brk 
; 8558 aa       tax 
; 8559 aa       tax 
; 855a 00       brk 
; 855b 00       brk 
; 855c 00       brk 
; 855d 00       brk 
; 855e 00       brk 
; 855f 00       brk 
; 8560 aa       tax 
; 8561 aa       tax 
; 8562 00       brk 
; 8563 00       brk 
; 8564 00       brk 
; 8565 00       brk 
; 8566 00       brk 
; 8567 00       brk 
; 8568 aa       tax 
; 8569 aa       tax 
; 856a 00       brk 
; 856b 00       brk 
; 856c 00       brk 
; 856d 00       brk 
; 856e 00       brk 
; 856f 00       brk 
; 8570 aa       tax 
; 8571 aa       tax 
; 8572 00       brk 
; 8573 00       brk 
; 8574 00       brk 
; 8575 00       brk 
; 8576 00       brk 
; 8577 00       brk 
; 8578 aa       tax 
; 8579 aa       tax 
; 857a 00       brk 
; 857b 00       brk 
; 857c 00       brk 
; 857d 00       brk 
; 857e 00       brk 
; 857f 00       brk 
; 8580 aa       tax 
; 8581 aa       tax 
; 8582 0f       ???
; 8583 1b       ???
; 8584 1b       ???
; 8585 1b       ???
; 8586 1b       ???
; 8587 0f       ???
; 8588 aa       tax 
; 8589 aa       tax 
; 858a cc d8 18 cpy $18d8
; 858d 18       clc 
; 858e db       ???
; 858f cf       ???
; 8590 aa       tax 
; 8591 aa       tax 
; 8592 0c       ???
; 8593 18       clc 
; 8594 18       clc 
; 8595 18       clc 
; 8596 d8       cld 
; 8597 cc aa aa cpy $aaaa
; 859a fc       ???
; 859b 2c 60 60 bit $6060
; 859e 60       rts 
; 859f 30 aa    bmi $854b
; 85a1 aa       tax 
; 85a2 fc       ???
; 85a3 bc b0 b0 ldy $b0b0,x
; 85a6 bc fc aa ldy $aafc,x
; 85a9 aa       tax 
; 85aa 00       brk 
; 85ab 00       brk 
; 85ac 00       brk 
; 85ad 00       brk 
; 85ae 00       brk 
; 85af 00       brk 
; 85b0 aa       tax 
; 85b1 aa       tax 
; 85b2 00       brk 
; 85b3 00       brk 
; 85b4 00       brk 
; 85b5 00       brk 
; 85b6 00       brk 
; 85b7 00       brk 
; 85b8 aa       tax 
; 85b9 aa       tax 
; 85ba 00       brk 
; 85bb 00       brk 
; 85bc 00       brk 
; 85bd 00       brk 
; 85be 00       brk 
; 85bf 00       brk 
; 85c0 aa       tax 
; 85c1 aa       tax 
; 85c2 00       brk 
; 85c3 00       brk 
; 85c4 00       brk 
; 85c5 00       brk 
; 85c6 00       brk 
; 85c7 00       brk 
; 85c8 aa       tax 
; 85c9 aa       tax 
; 85ca 00       brk 
; 85cb 00       brk 
; 85cc 00       brk 
; 85cd 00       brk 
; 85ce 00       brk 
; 85cf 00       brk 
; 85d0 aa       tax 
; 85d1 aa       tax 
; 85d2 00       brk 
; 85d3 00       brk 
; 85d4 00       brk 
; 85d5 00       brk 
; 85d6 00       brk 
; 85d7 00       brk 
; 85d8 aa       tax 
; 85d9 ff       ???
; 85da aa       tax 
; 85db 55 00    eor $00,x
; 85dd 00       brk 
; 85de 00       brk 
; 85df 00       brk 
; 85e0 aa       tax 
; 85e1 ac 04 04 ldy $0404
; 85e4 04       ???
; 85e5 0c       ???
; 85e6 30 bc    bmi $85a4
; 85e8 40       rti 
; 85e9 aa       tax 
; 85ea 00       brk 
; 85eb 00       brk 
; 85ec 00       brk 
; 85ed 00       brk 
; 85ee 00       brk 
; 85ef 00       brk 
; 85f0 ff       ???
; 85f1 ff       ???
; 85f2 00       brk 
; 85f3 00       brk 
; 85f4 00       brk 
; 85f5 00       brk 
; 85f6 00       brk 
; 85f7 00       brk 
; 85f8 ff       ???
; 85f9 ff       ???
; 85fa 00       brk 
; 85fb 00       brk 
; 85fc 00       brk 
; 85fd 00       brk 
; 85fe 00       brk 
; 85ff 00       brk 
; 8600 ff       ???
; 8601 ff       ???
; 8602 00       brk 
; 8603 00       brk 
; 8604 00       brk 
; 8605 00       brk 
; 8606 00       brk 
; 8607 00       brk 
; 8608 ff       ???
; 8609 03       ???
; 860a 08       php 
; 860b 08       php 
; 860c 09 05    ora #$05
; 860e 00       brk 
; 860f 00       brk 
; 8610 aa       tax 
; 8611 aa       tax 
; 8612 40       rti 
; 8613 80       ???
; 8614 80       ???
; 8615 80       ???
; 8616 40       rti 
; 8617 00       brk 
; 8618 aa       tax 
; 8619 2a       rol a
; 861a 00       brk 
; 861b 00       brk 
; 861c 00       brk 
; 861d 00       brk 
; 861e 00       brk 
; 861f 00       brk 
; 8620 00       brk 
; 8621 80       ???
; 8622 00       brk 
; 8623 00       brk 
; 8624 00       brk 
; 8625 00       brk 
; 8626 00       brk 
; 8627 00       brk 
; 8628 00       brk 
; 8629 00       brk 
; 862a 00       brk 
; 862b 00       brk 
; 862c 00       brk 
; 862d 00       brk 
; 862e 00       brk 
; 862f 00       brk 
; 8630 00       brk 
; 8631 00       brk 
; 8632 00       brk 
; 8633 00       brk 
; 8634 00       brk 
; 8635 00       brk 
; 8636 00       brk 
; 8637 00       brk 
; 8638 00       brk 
; 8639 00       brk 
; 863a 00       brk 
; 863b 00       brk 
; 863c 00       brk 
; 863d 00       brk 
; 863e 00       brk 
; 863f 00       brk 
; 8640 00       brk 
; 8641 00       brk 
; 8642 00       brk 
; 8643 00       brk 
; 8644 00       brk 
; 8645 00       brk 
; 8646 00       brk 
; 8647 00       brk 
; 8648 00       brk 
; 8649 00       brk 
; 864a 00       brk 
; 864b 00       brk 
; 864c 00       brk 
; 864d 00       brk 
; 864e 00       brk 
; 864f 00       brk 
; 8650 00       brk 
; 8651 00       brk 
; 8652 00       brk 
; 8653 00       brk 
; 8654 00       brk 
; 8655 00       brk 
; 8656 00       brk 
; 8657 00       brk 
; 8658 00       brk 
; 8659 f5 83    sbc $83,x
; 865b 00       brk 
; 865c ff       ???
; 865d 00       brk 
; 865e ff       ???
; 865f 00       brk 
