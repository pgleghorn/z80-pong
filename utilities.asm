; pad constants
PAD_UPPERLIMIT:   equ 0
PAD_LOWERLIMIT:   equ 21
PAD_HEIGHT:       equ 3

; color constants
BLACK:          equ 0<<3
BLUE:           equ 1<<3
RED:            equ 2<<3
MAGENTA:        equ 3<<3
GREEN:          equ 4<<3
CYAN:           equ 5<<3
YELLOW:         equ 6<<3
WHITE:          equ 7<<3

; pause constant
PAUSE_CONSTANT  equ 9000

; screen constants
COLOR_SCREEN:       equ 0x5800
COLOR_SCREEN_SIZE:  equ 0x0300

SCREEN_WIDTH        equ 32
SCREEN_HEIGHT       equ 24


; simple delay
short_pause:
	ld bc,PAUSE_CONSTANT
short_pause_l1:
	dec bc
	ld a,b
	or c
	jr nz,short_pause_l1
	ret

; return the screen address of a given coordinate
; input
; - IY - y coord
; - IX - x coord
; output
; - HL - screen address of the coordinate
locate_coord:
    ; address onscreen = (y * 32) + x + screen base
    add iy,iy
    add iy,iy
    add iy,iy
    add iy,iy
    add iy,iy
    ld bc,iy
    
    add ix,bc

    ld bc,COLOR_SCREEN
    add ix,bc

    ld hl,ix
    ret

; print a pad at the given coordinate
; input
; - IY - y coord
; - IX - x coord
; - A - colour
print_pad:
    call locate_coord
    ld (hl),a
    ld bc,SCREEN_WIDTH
    add hl,bc
    ld (hl),a
    add hl,bc
    ld (hl),a
    ret

clear_background:
    ld a,BLUE
    ld bc,COLOR_SCREEN_SIZE
    ld hl,COLOR_SCREEN
    ld (hl),a
    ld e,l
    ld d,h
    inc de
    dec bc
    ldir
    ret