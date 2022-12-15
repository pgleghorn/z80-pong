; erase an 8x8 block at the specified coordinate
; input
;  - c - x coordinate
;  - b - y coordinate
block_erase:
    push bc
    call block_get_address_and_align
block_erase_rows:
    ld a,(hl)
    xor d
    ld (hl),a
    inc hl
    ld a,(hl)
    xor e
    ld (hl),a
    dec hl
    call Pixel_Address_Down
    djnz block_erase_rows
    pop bc
    ret

; print an 8x8 block at the specified coordinate
; input
;  - c - x coordinate
;  - b - y coordinate
block_print:
    push bc
    call block_get_address_and_align
block_print_rows
    ld a,(hl)
    or d
    ld (hl),a
    inc hl
    ld a,(hl)
    or e
    ld (hl),a
    dec hl
    call Pixel_Address_Down
    djnz block_print_rows
    pop bc
    ret

block_get_address_and_align:
    call Get_Pixel_Address
    ld d,255
    ld e,0
    ld b,a
    or a
    jr z,block_doesnt_need_aligning
block_needs_aligning:
    srl de
    djnz block_needs_aligning
block_doesnt_need_aligning:
    ld b,8
    ret