; pad left variables
PADLEFTY:       defw 4
PADLEFTX:       defw 2

print_padleft:
    ld iy,(PADLEFTY)
    ld ix,(PADLEFTX)
    ld a,RED
    call print_pad
    ret

erase_padleft:
    ld iy,(PADLEFTY)
    ld ix,(PADLEFTX)
    ld a,BLUE
    call print_pad
    ret

check_move_padleft_up:
    ld bc,$FBFE
    in a,(c)
    and %00000001
    ret nz
    ld bc,(PADLEFTY)
    ld a,c
    cp PAD_UPPERLIMIT
    ret z
    dec bc
    ld (PADLEFTY), bc
    ret

check_move_padleft_down:
    ld bc,$FDFE
    in a,(c)
    and %00000001
    ret nz
    ld bc,(PADLEFTY)
    ld a,c
    cp PAD_LOWERLIMIT
    ret z
    inc bc
    ld (PADLEFTY), bc
    ret

padleft_check:
    ; is ball heading in the right direction?
    ;ld bc,(VELX)
    ;ld a,c
    ;sub 1
    ;ret z
    ; is ball x coord at the paddle?
    ld bc,(BALLX)
    ld de,(PADLEFTX)
    inc de
    ld a,e
    sub c
    ret nz
    ; is the ball y coord at or beyond the tip of the paddle?
    ld bc,(BALLY)
    ld de,(PADLEFTY)
    ld a,c
    sub e
    ret c
    ; is the ball y coord beyond the end of the paddle?
    ld bc,(BALLY)
    ld de,(PADLEFTY)
    ld a,c
    sub e
    sub 3
    ret nc
    ; otherwise, bounce
padleft_bounce:
    ld bc,1
    ld (VELX), bc
    ret