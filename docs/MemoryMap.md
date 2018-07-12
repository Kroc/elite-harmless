# Elite Memory Map #

          .             .
          :             :
    $0300 +-------------+
          | ?           |     Some heap space?
    $0400 |-------------|
          |             |     variable space
          |             |     (extact details incomplete)
    $0700 |-------------|
          | TEXT_FLIGHT |     compressed text
          |             |
          |             |
    $0B00 |-------------|
          | DATA_FONT   |     font graphics
          |             |
    $0E00 |-------------|
          | TEXT_DOCKED |     compressed text
          |             |
          |             |
          |             |
          |             |
          |             |
          |             |
          |             |
          |             |
          |             |
          |             |
          |             |
          |             |
          |             |
    $1D00 |-------------|
          | CODE_1D00   |     variable space
    $1D21 |-------------|



------------    ----------------------------------------------------------------

$4000..$6000    HIGH-RESOLUTION BITMAP SCREEN:

$6000..$6400    MENU-SCREEN COLOUR MAP:
                this is the 1K of colour map information for the bitmap screen,
                when Elite is displaying menu screens (no HUD), such as when
                docked

$6400..$6800    MAIN-SCREEN COLOUR MAP:
                this is the 1K of colour map information for the bitmap screen,
                when Elite is displaying the main flight screen (3D graphics)

$6800..$69C0    SPRITE GRAPHICS:
                contains sprite definitions; 4 crosshairs, an explosion(?),
                and two trumble images

$6A00..$CCE0    CODE/DATA? (GMA6.PRG)

------------    ----------------------------------------------------------------

$D000..$EF90    SHIP MODELS:
                3D vector data for the various ships / objects in the game

$EF90..$F890    HUD IMAGE (COPY):
                copied from $7D7A..$867A by GMA4.PRG.
                this appears to be a backup-copy of the HUD.
                this is probably used for keeping the radar intact when
                erasing and drawing the poles on the radar; could sprite
                multiplexing be used to avoid this?

$F900..         ?
