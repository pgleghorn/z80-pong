; pad left variables
PADRIGHTY:       defw 50
PADRIGHTX:       defw 230

; pad constants
PADRIGHT_UPPERLIMIT:   equ 5
PADRIGHT_LOWERLIMIT:   equ 166
PADRIGHT_HEIGHT:       equ 3

padright_print:
    call fetch_padright_coords
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

padright_erase:
    call fetch_padright_coords
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

; returns padright coords
; c - x coord
; d - y coord
fetch_padright_coords:
    ld a,(PADRIGHTX)
    ld c,a
    ld a,(PADRIGHTY)
    ld b,a
    ret

check_move_padright_up:
    ld bc,$DFFE
    in a,(c)
    and %00000001
    ret nz

    ld a,(PADRIGHTY)
    cp PADRIGHT_UPPERLIMIT
    ret c

    call padright_erase
    ld a,(PADRIGHTY)
    dec a
    dec a
    ;dec a
    ;dec a
    ld (PADRIGHTY), a
    call padright_print

    ret

check_move_padright_down:
    ld bc,$BFFE
    in a,(c)
    and %00000010
    ret nz
    
    ld a,(PADRIGHTY)
    cp PADRIGHT_LOWERLIMIT
    ret nc

    call padright_erase
    ld a,(PADRIGHTY)
    inc a
    inc a
    ;inc a
    ;inc a
    ld (PADRIGHTY), a
    call padright_print

    ret
