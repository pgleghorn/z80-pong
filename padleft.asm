; pad left variables
PADLEFTY:       defw 50
PADLEFTX:       defw 20

; pad constants
PADLEFT_UPPERLIMIT:   equ 5
PADLEFT_LOWERLIMIT:   equ 166
PADLEFT_HEIGHT:       equ 3

padleft_print:
    call fetch_padleft_coords
    call block_print
    ld a,b
    add 8
    ld b,a
    call block_print
    ld a,b
    add 8
    ld b,a
    call block_print
    ret

padleft_erase:
    call fetch_padleft_coords
    call block_erase
    ld a,b
    add 8
    ld b,a
    call block_erase
    ld a,b
    add 8
    ld b,a
    call block_erase
    ret

; returns padleft coords
; c - x coord
; d - y coord
fetch_padleft_coords:
    ld a,(PADLEFTX)
    ld c,a
    ld a,(PADLEFTY)
    ld b,a
    ret

check_move_padleft_up:
    ld bc,$FBFE
    in a,(c)
    and %00000001
    ret nz

    ld a,(PADLEFTY)
    cp PADLEFT_UPPERLIMIT
    ret c

    call padleft_erase
    ld a,(PADLEFTY)
    dec a
    dec a
    ;dec a
    ;dec a
    ld (PADLEFTY), a
    call padleft_print

    ret

check_move_padleft_down:
    ld bc,$FDFE
    in a,(c)
    and %00000001
    ret nz
    
    ld a,(PADLEFTY)
    cp PADLEFT_LOWERLIMIT
    ret nc

    call padleft_erase
    ld a,(PADLEFTY)
    inc a
    inc a
    ;inc a
    ;inc a
    ld (PADLEFTY), a
    call padleft_print

    ret
