; ball variables
BALLX:          defw 8
BALLY:          defw 2

VELX:           defw 1
VELY:           defw 0

print_ball:
    ld iy,(BALLY)
    ld ix,(BALLX)
    call locate_coord
    ld (hl),WHITE
    ret

erase_ball:
    ld iy,(BALLY)
    ld ix,(BALLX)
    call locate_coord
    ld (hl),BLUE
    ret

move_ball:
    ld iy,(BALLY)
    ld bc,(VELY)
    ld a,b
    or c
    jr z,move_ball_up
    jr move_ball_down
move_ball_up:
    inc iy
    ld (BALLY), iy
    jr move_ball_continue1
move_ball_down:
    dec iy
    ld (BALLY), iy
move_ball_continue1:
    ld ix,(BALLX)
    ld bc,(VELX)
    ld a,b
    or c
    jr z,move_ball_left
    jr move_ball_right
move_ball_left:
    dec ix
    ld (BALLX), ix
    jr move_ball_continue2
move_ball_right:
    inc ix
    ld (BALLX), ix
move_ball_continue2:
    ret

south_wall_check:
    ld bc,(BALLY)
    ld a,23
    sub c
    jp z,south_wall_bounce
    ret
south_wall_bounce:
    ld bc,1
    ld (VELY), bc
    ret

north_wall_check:
    ld bc,(BALLY)
    ld a,0
    sub c
    jp z,north_wall_bounce
    ret
north_wall_bounce:
    ld bc,0
    ld (VELY), bc
    ret

east_wall_check:
    ld bc,(BALLX)
    ld a,31
    sub c
    jp z,east_wall_bounce
    ret
east_wall_bounce:
    ld bc,0
    ld (VELX), bc
    ret

west_wall_check:
    ld bc,(BALLX)
    ld a,0
    sub c
    jp z,west_wall_bounce
    ret
west_wall_bounce:
    ld bc,1
    ld (VELX), bc
    ret



