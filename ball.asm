BALLX:   defw 150
BALLY:   defw 30

OLDBALLX:   defw 150
OLDBALLY:   defw 30


BALLVX:           defw 1
BALLVX_ITERATOR     defw 1
BALLVX_MAX          defw 1
BALLVY:           defw -1
BALLVY_ITERATOR:    defw 1
BALLVY_MAX:        defw 4

ball_print:
    call fetch_ball_coords
    call block_print
    ret

ball_erase:
    call fetch_ball_coords
    call block_erase
    ret

ball_erase_old:
    ld a,(OLDBALLX)
    ld c,a
    ld a,(OLDBALLY)
    ld b,a
    call block_erase
    ret

ball_move:
ball_save_position:
    call fetch_ball_coords
    ld a,c
    ld (OLDBALLX), a
    ld a,b
    ld (OLDBALLY), a

ball_move_check_x:
    ; update BALLVX_ITERATOR - when zero, then update actual BALLVX
    ld a,(BALLVX_ITERATOR)
    dec a
    ld (BALLVX_ITERATOR), a
    jr nz,ball_move_check_y
    ; BALLVX_ITERATOR is zero - so reset the iterator and move
    ld a,(BALLVX_MAX)
    ld (BALLVX_ITERATOR), a
    ld a,(BALLVX)
    ld b,a
    ld a,(BALLX)
    add a,b
    ld (BALLX), a
ball_move_check_y
    ; update BALLVY_ITERATOR - when zero, then update actual BALLVY
    ld a,(BALLVY_ITERATOR)
    dec a
    ld (BALLVY_ITERATOR), a
    ret nz
    ; BALLVY_ITERATOR is zero - so reset the iterator and move
    ld a,(BALLVY_MAX)
    ld (BALLVY_ITERATOR), a
    ld a,(BALLVY)
    ld b,a
    ld a,(BALLY)
    add a,b
    ld (BALLY), a
    ret

ball_bounce_walls:
    nop
ball_bounce_east_wall:
    ld a,(BALLX)
    cp 248
    jr nz,ball_bounce_west_wall
    call ball_invert_vx
    ld a,(BALLX)
    dec a
    ld (BALLX),a
ball_bounce_west_wall:
    ld a,(BALLX)
    cp 0
    jr nz,ball_bounce_north_wall
    call ball_invert_vx
    ld a,(BALLX)
    inc a
    ld (BALLX), a
ball_bounce_north_wall:
    ld a,(BALLY)
    cp 0
    jr nz,ball_bounce_south_wall
    call ball_invert_vy
    ld a,(BALLY)
    inc a
    ld (BALLY), a
ball_bounce_south_wall:
    ld a,(BALLY)
    cp 184
    jr nz,ball_bounce_done
    call ball_invert_vy
    ld a,(BALLY)
    dec a
    ld (BALLY), a
ball_bounce_done:
    ret

ball_invert_vy:
    ld a,(BALLVY)
    neg
    ld (BALLVY),a
    ret
ball_invert_vx:
    ld a,(BALLVX)
    neg
    ld (BALLVX),a
    ret

; fetch ball coords
; c - x coord
; b - y coord
fetch_ball_coords:
    ld a,(BALLX)
    ld c,a
    ld a,(BALLY)
    ld b,a
    ret

ball_bounce_padleft:
    ld a,(BALLVX)
    or a
    ret ns ; ball is not travelling left
    ld a,(PADLEFTX)
    add a,8
    ld b,a
    ld a,(BALLX)
    sub b
    ret nz ; ballx is not aligned to the paddle
    ld a,(PADLEFTY)
    sub 8 ; bit of flex
    jr nc,padleft_not_at_top
    ld a,0
padleft_not_at_top:
    ld b,a
    ld a,(BALLY)
    sub b

    jr z,ball_bounce_padleft_inrange1
    jr nc,ball_bounce_padleft_inrange1
    ret ; bally is lower than the paddle

ball_bounce_padleft_inrange1:
    ld a,(PADLEFTY)
    add 24
    ld b,a
    ld a,(BALLY)
    sub b

    jr z,ball_bounce_padleft_inrange2
    jr c,ball_bounce_padleft_inrange2
    ret

ball_bounce_padleft_inrange2:
    call ball_invert_vx
    ld a,(BALLX)
    inc a
    ld (BALLX), a

    ld a,(PADLEFTY)
    sub 8
    ld b,a
    ld a,(BALLY)
    sub b
    call bounce_by_4_segments
    ret

bounce_by_4_segments:
    ; 0, 8, 16, 24, 32
    sub 8
    jr c,range_24_32
    sub 8
    jr c,range_16_24
    sub 8
    jr c,range_8_16
range_0_8:
    nop
    ld a,1
    ld (BALLVY_MAX), a
    ld a,1
    ld (BALLVY), a
    ret
range_8_16:
    nop
    ld a,2
    ld (BALLVY_MAX), a
    ld a,1
    ld (BALLVY), a
    ret
range_16_24:
    nop
    ld a,2
    ld (BALLVY_MAX), a
    ld a,-1
    ld (BALLVY), a
    ret
range_24_32:
    nop
    ld a,1
    ld (BALLVY_MAX), a
    ld a,-1
    ld (BALLVY), a
    ret

bounce_by_8_segments:
    ; 0, 4, 8, 12, 16, 20, 24, 28, 32
    sub 4
    jp c,range_28_32
    sub 4
    jp c,range_24_28
    sub 4
    jp c,range_20_24
    sub 4
    jp c,range_16_20
    sub 4
    jp c,range_12_16
    sub 4
    jp c,range_8_12
    sub 4
    jp c,range_4_8
range_0_4:
    nop
    ld a,1
    ld (BALLVY_MAX), a
    ld a,3
    ld (BALLVX_MAX), a
    ld a,1
    ld (BALLVY), a
    ret
range_4_8:
    nop
    ld a,2
    ld (BALLVY_MAX), a
    ld a,1
    ld (BALLVX_MAX), a
    ld a,1
    ld (BALLVY), a
    ret
range_8_12:
    nop
    ld a,3
    ld (BALLVY_MAX), a
    ld a,1
    ld (BALLVX_MAX), a
    ld a,1
    ld (BALLVY), a
    ret
range_12_16:
    nop
    ld a,4
    ld (BALLVY_MAX), a
    ld a,1
    ld (BALLVX_MAX), a
    ret
range_16_20:
    nop
    ld a,4
    ld (BALLVY_MAX), a
    ld a,1
    ld (BALLVX_MAX), a
    ld a,-1
    ld (BALLVY), a
    ret
range_20_24:
    nop
    ld a,3
    ld (BALLVY_MAX), a
    ld a,1
    ld (BALLVX_MAX), a
    ld a,-1
    ld (BALLVY), a
    ret
range_24_28:
    nop
    ld a,2
    ld (BALLVY_MAX), a
    ld a,1
    ld (BALLVX_MAX), a
    ld a,-1
    ld (BALLVY), a
    ret
range_28_32:
    nop
    ld a,1
    ld (BALLVY_MAX), a
    ld a,3
    ld (BALLVX_MAX), a
    ld a,-1
    ld (BALLVY), a
    ret


ball_bounce_padright:
    ld a,(BALLVX)
    or a
    ret s ; ball is not travelling right
    ld a,(PADRIGHTX)
    sub 8
    ld b,a
    ld a,(BALLX)
    sub b
    ret nz ; ballx is not aligned to the paddle
    ld a,(PADRIGHTY)
    sub 8 ; bit of flex
    jr nc,padright_not_at_top
    ld a,0
padright_not_at_top:
    ld b,a
    ld a,(BALLY)
    sub b

    jr z,ball_bounce_padright_inrange1
    jr nc,ball_bounce_padright_inrange1
    ret ; bally is lower than the paddle

ball_bounce_padright_inrange1:
    ld a,(PADRIGHTY)
    add 24
    ld b,a
    ld a,(BALLY)
    sub b

    jr z,ball_bounce_padright_inrange2
    jr c,ball_bounce_padright_inrange2
    ret

ball_bounce_padright_inrange2:
    call ball_invert_vx
    ld a,(BALLX)
    dec a
    ld (BALLX), a

    ld a,(PADRIGHTY)
    sub 8
    ld b,a
    ld a,(BALLY)
    sub b
    call bounce_by_4_segments
    ret
