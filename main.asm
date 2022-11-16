    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    DEVICE ZXSPECTRUM48

    ORG 0x4000
    defs 0x6000 - $
screen_top: defb    0

    include "utilities.asm"
    include "ball.asm"
    include "padleft.asm"
    include "padright.asm"

 defs 0x8000 - $
 ORG $8000

main:
    ld sp,stack_top
    call clear_background

main_loop:
    call print_ball
    call print_padleft
    call print_padright

    call short_pause

    call erase_padleft
    call erase_padright
    call erase_ball
    call move_ball

    call south_wall_check
    call north_wall_check
    call east_wall_check
    call west_wall_check

    call check_move_padleft_down
    call check_move_padleft_up

    call check_move_padright_down
    call check_move_padright_up

    call padright_check
    call padleft_check

    jr main_loop

STACK_SIZE: equ 100
    defw 0

stack_bottom:
    defs    STACK_SIZE * 2, 0

stack_top:
    defw 0
    
    SAVESNA "z80-pong.sna", main