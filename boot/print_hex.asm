print_hex:
    pusha
    mov cx, 0


hex_loop:
    cmp cx, 4
    je end 
    
    ; convert last char of 'dx' to ascii
    mov ax, dx
    and ax, 0x000f  ; mask
    add ax, 0x30    ; add 48 to conevert number to ascii
    cmp al, 0x39    ; if > 9, add extra 8 to represent 'A' to 'F'
    jle step2
    add al, 7       ; 'A' is ASCII 65 instead of 58, so 65-58=7

step2:
    ; get the correct position of the string to place our ASCII char
    ; bx <- base address + string length - index of char
    mov bx, HEX_OUT + 5 ; base + length
    sub bx, cx
    mov [bx], al    ; copy the ASCII char on 'al' to the position pointed by 'bx'
    ror dx, 4       ; 0x1234 -> 0x4123 ->0x3412 -> 0x2341 -> 0x1234

    ; increment index and loop
    add cx, 1
    jmp hex_loop

end:
    mov bx, HEX_OUT
    call print_string

    popa
    ret

HEX_OUT:
    db '0x0000',0 ; reserve memory for new string
    