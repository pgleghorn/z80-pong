; pad right variables
PADRIGHTY:       defw 15
PADRIGHTX:       defw 29

print_padright:
    ld iy,(PADRIGHTY)
    ld ix,(PADRIGHTX)
    ld a,GREEN
    call print_pad
    ret

erase_padright:
    ld iy,(PADRIGHTY)
    ld ix,(PADRIGHTX)
    ld a,BLUE
    call print_pad
    ret

check_move_padright_up:
    ld bc,$DFFE
    in a,(c)
    and %00000001
    ret nz
    ld bc,(PADRIGHTY)
    ld a,c
    cp PAD_UPPERLIMIT
    ret z
    dec bc
    ld (PADRIGHTY), bc
    ret

check_move_padright_down:
    ld bc,$BFFE
    in a,(c)
    and %00000010
    ret nz
    ld bc,(PADRIGHTY)
    ld a,c
    cp PAD_LOWERLIMIT
    ret z
    inc bc
    ld (PADRIGHTY), bc
    ret

padright_check:
    ; is ball heading in the right direction?
    ;ld bc,(VELX)
    ;ld a,c
    ;sub 1
    ;ret z
    ; is ball x coord at the paddle?
    ld bc,(BALLX)
    ld de,(PADRIGHTX)
    dec de
    ld a,e
    sub c
    ret nz
    ; is the ball y coord at or beyond the tip of the paddle?
    ld bc,(BALLY)
    ld de,(PADRIGHTY)
    ld a,c
    sub e
    ret c
    ; is the ball y coord beyond the end of the paddle?
    ld bc,(BALLY)
    ld de,(PADRIGHTY)
    ld a,c
    sub e
    sub 3
    ret nc
    ; otherwise, bounce
padright_bounce:
    ld bc,0
    ld (VELX), bc
    ret