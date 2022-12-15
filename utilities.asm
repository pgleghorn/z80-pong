

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
PAUSE_CONSTANT_LONG  equ 9000
PAUSE_CONSTANT_MEDIUM  equ 1000
PAUSE_CONSTANT_SHORT  equ 200

; screen constants
COLOR_SCREEN:       equ 0x5800
COLOR_SCREEN_SIZE:  equ 0x0300
BITMAP_SCREEN:      equ 0x4000
BITMAP_SCREEN_SIZE: equ 0x1800

SCREEN_WIDTH        equ 32
SCREEN_HEIGHT       equ 24


; simple delay
pause_short:
    ;push de
	ld de,PAUSE_CONSTANT_SHORT
    jr pause_l1
pause_long:
    ;push de
    ld de,PAUSE_CONSTANT_LONG
    jr pause_l1
pause_medium:
    ;push de
    ld de,PAUSE_CONSTANT_MEDIUM
    jr pause_l1
pause_l1:
	dec de
	ld a,d
	or e
	jr nz,pause_l1
    ;pop de
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

; fill screen attributes
; input
;  - A - attribute value
fill_attributes:
    ld bc,COLOR_SCREEN_SIZE
    ld hl,COLOR_SCREEN
    call fill_memory
    ret

; fill screen bitmap
; input
;  - A - row bitmap value
fill_bitmap:
    push bc
    push hl
    ld bc,BITMAP_SCREEN_SIZE
    ld hl,BITMAP_SCREEN
    call fill_memory
    pop hl
    pop bc
    ret

; input
; - HL - start address
; - BC - length
; - A - fill
fill_memory:
    push de
    ld (hl),a
    ld e,l
    ld d,h
    inc de
    dec bc
    ldir
    pop de
    ret

; Get screen address
; B = Y pixel position
; C = X pixel position
; Returns address in HL and pixel position within character in A
;
Get_Pixel_Address:
            LD A,B				; Calculate Y2,Y1,Y0
			AND %00000111			; Mask out unwanted bits
			OR %01000000			; Set base address of screen
			LD H,A				; Store in H
			LD A,B				; Calculate Y7,Y6
			RRA				; Shift to position
			RRA
			RRA
			AND %00011000			; Mask out unwanted bits
			OR H				; OR with Y2,Y1,Y0
			LD H,A				; Store in H
			LD A,B				; Calculate Y5,Y4,Y3
			RLA				; Shift to position
			RLA
			AND %11100000			; Mask out unwanted bits
			LD L,A				; Store in L
			LD A,C				; Calculate X4,X3,X2,X1,X0
			RRA				; Shift into position
			RRA
			RRA
			AND %00011111			; Mask out unwanted bits
			OR L				; OR with Y5,Y4,Y3
			LD L,A				; Store in L
			LD A,C
			AND 7
			RET

; Move HL down one pixel line
;
Pixel_Address_Down:	INC H				; Go down onto the next pixel line
			LD A,H				; Check if we have gone onto next character boundary
			AND 7
			RET NZ				; No, so skip the next bit
			LD A,L				; Go onto the next character line
			ADD A,32
			LD L,A
			RET C				; Check if we have gone onto next third of screen
			LD A,H				; Yes, so go onto next third
			SUB 8
			LD H,A
			RET