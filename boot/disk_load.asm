; load 'dh' sectors from drive 'dl' into ES:BX
disk_load:
    pusha
    push dx

    mov ah, 0x02    ; ah <- int 0x13 function. 0x02 = 'read'
    mov al, dh      ; read DH sectors, number (0x01 .. 0x80) 
    mov cl, 0x02    ; cl <- sector (0x01 .. 0x11), 0x01 is the boot sector
    mov ch, 0x00    ; select cylinder 0
    mov dh, 0x00    ; select head

    int 0x13        ; BIOS interrupt
    jc disk_error   ; jump if error (i.e. carry flag set)

    pop dx          ; restore dx from stack
    cmp al, dh      ; if al (sectors read) != dh (sectors expected)
    jne sectors_error
    popa
    ret

disk_error:
    mov bx, DISK_ERROR
    call print_string
    call print_ln
    mov dh, ah      ; ah = error code, dl = disk drive that dropped error
    call print_hex
    jmp disk_loop

sectors_error:
    mov bx, SECTORS_ERROR
    call print_string

disk_loop:
    jmp $

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0
