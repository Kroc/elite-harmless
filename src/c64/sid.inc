; Elite C64 disassembly / Elite : Harmless, cc-by-nc-sa 2018-2019,
; see LICENSE.txt. "Elite" is copyright / trademark David Braben & Ian Bell,
; All Rights Reserved. <github.com/Kroc/elite-harmless>
;===============================================================================

.enum   voice_ctrl
        gate            = %00000001     ; 1 = on: atk-dcy-sus, 0 = off: release
        sync            = %00000010     ; 1 = sync enabled
        ring            = %00000100     ; 1 = ring modulation enabled
        test            = %00001000     ; 1 = disable / reset noise
        triangle        = %00010000     ; 1 = triangle waveform selected
        saw             = %00100000     ; 1 = saw waveform selected
        rect            = %01000000     ; 1 = rectangle waveform selected
        noise           = %10000000     ; 1 = noise enabled
.endenum

;-------------------------------------------------------------------------------

SID_REGISTERS                   = $d400 ; beginning of the SID registers

SID_VOICE1_FREQ                 = $d400
SID_VOICE1_FREQ_LO              = $d400
SID_VOICE1_FREQ_HI              = $d401

SID_VOICE1_PULSE                = $d402
SID_VOICE1_PULSE_LO             = $d402
SID_VOICE1_PULSE_HI             = $d403

SID_VOICE1_CTRL                 = $d404

SID_VOICE1_ATKDCY               = $d405 ; attack & decay
SID_VOICE1_SUSREL               = $d406 ; sustain & release

;-------------------------------------------------------------------------------

SID_VOICE2_FREQ                 = $d407
SID_VOICE2_FREQ_LO              = $d407
SID_VOICE2_FREQ_HI              = $d408

SID_VOICE2_PULSE                = $d409
SID_VOICE2_PULSE_LO             = $d409
SID_VOICE2_PULSE_HI             = $d40a

SID_VOICE2_CTRL                 = $d40b

SID_VOICE2_ATKDCY               = $d40c ; attack & decay
SID_VOICE2_SUSREL               = $d40d ; sustain & release

;-------------------------------------------------------------------------------

SID_VOICE3_FREQ                 = $d40e
SID_VOICE3_FREQ_LO              = $d40e
SID_VOICE3_FREQ_HI              = $d40f

SID_VOICE3_PULSE                = $d410
SID_VOICE3_PULSE_LO             = $d410
SID_VOICE3_PULSE_HI             = $d411

SID_VOICE3_CTRL                 = $d412

SID_VOICE3_ATKDCY               = $d413 ; attack & decay
SID_VOICE3_SUSREL               = $d414 ; sustain & release

;-------------------------------------------------------------------------------

SID_FILTER_FREQ_LO              = $d415 ; filter cut off frequency (bits 0-2)
SID_FILTER_FREQ_HI              = $d416 ; filter cut off frequency (bits 3-10)

SID_FILTER_CTRL                 = $d417

SID_VOLUME_CTRL                 = $d418

SID_VOICE3_WAVEOUT              = $d41b ; voice 3 waveform output (R/O)
SID_VOICE3_ADSROUT              = $d41c ; voice 3 ADSR output (R/O)