print_string:
    pusha           ; save registers to stack

start:
    mov al, [bx]    ; 'bx' is the base address for the string
    cmp al, 0
    je done

    ; the part where we print with the BIOS help
    mov ah, 0x0e
    int 0x10        ; 'al' already contains the char

    ; increment pointer and do next loop
    add bx, 1
    jmp start

done:
    popa            ; retreive regisers from stack
    ret             ; return to caller address

print_ln:
    pusha

    mov ah, 0x0e
    mov al, 0x0a ; newline char
    int 0x10
    mov al, 0x0d ; carriage return
    int 0x10

    popa
    ret