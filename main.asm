    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    DEVICE ZXSPECTRUM48

    ORG 0x4000
    defs 0x6000 - $
screen_top: defb    0

    include "utilities.asm"
    include "ball.asm"
    include "padleft.asm"
    include "padright.asm"
    include "block.asm"

 defs 0x8000 - $
 ORG $8000

main:
    di
    ld sp,stack_top
    ld a,%00000100
    call fill_attributes
    ld a,0
    call fill_bitmap

    call padleft_print
main_loop:
    call ball_erase_old
    call ball_print
    call padleft_print
    call padright_print

    call pause_short

    call ball_move
    call ball_bounce_walls
    call ball_bounce_padleft
    call ball_bounce_padright

    call check_move_padleft_up
    call check_move_padleft_down

    call check_move_padright_up
    call check_move_padright_down

    jr main_loop

STACK_SIZE: equ 100
    defw 0

stack_bottom:
    defs    STACK_SIZE * 2, 0

stack_top:
    defw 0
    
    SAVESNA "z80-pong.sna", main