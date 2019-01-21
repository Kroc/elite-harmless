; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

.define SID_VOICE1_FREQ         $d400
.define SID_VOICE1_FREQ_LO      $d400
.define SID_VOICE1_FREQ_HI      $d401

.define SID_VOICE1_PULSE        $d402
.define SID_VOICE1_PULSE_LO     $d402
.define SID_VOICE1_PULSE_HI     $d403

.define SID_VOICE1_CTRL         $d404

.define SID_VOICE1_ATKDCY       $d405   ; attack & decay
.define SID_VOICE1_SUSREL       $d406   ; sustain & release

;-------------------------------------------------------------------------------

.define SID_VOICE2_FREQ         $d407
.define SID_VOICE2_FREQ_LO      $d407
.define SID_VOICE2_FREQ_HI      $d408

.define SID_VOICE2_PULSE        $d409
.define SID_VOICE2_PULSE_LO     $d409
.define SID_VOICE2_PULSE_HI     $d40a

.define SID_VOICE2_CTRL         $d40b

.define SID_VOICE2_ATKDCY       $d40c   ; attack & decay
.define SID_VOICE2_SUSREL       $d40d   ; sustain & release

;-------------------------------------------------------------------------------

.define SID_VOICE3_FREQ         $d40e
.define SID_VOICE3_FREQ_LO      $d40e
.define SID_VOICE3_FREQ_HI      $d40f

.define SID_VOICE3_PULSE        $d410
.define SID_VOICE3_PULSE_LO     $d410
.define SID_VOICE3_PULSE_HI     $d411

.define SID_VOICE3_CTRL         $d412

.define SID_VOICE3_ATKDCY       $d413   ; attack & decay
.define SID_VOICE3_SUSREL       $d414   ; sustain & release

;-------------------------------------------------------------------------------

.define SID_FILTER_FREQ_LO      $d415   ; filter cut off frequency (bits 0-2)
.define SID_FILTER_FREQ_HI      $d416   ; filter cut off frequency (bits 3-10)

.define SID_FILTER_CTRL         $d417

.define SID_VOLUME_CTRL         $d418

.define SID_VOICE3_WAVEOUT      $d41b   ; voice 3 waveform output (R/O)
.define SID_VOICE3_ADSROUT      $d41c   ; voice 3 ADSR output (R/O)