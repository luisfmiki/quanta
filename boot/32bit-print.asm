[bits 32]

; define some constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f ; the color byte for each character

; prints a null-terminated string pointed to by EDX
print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY   ; set edx to the start of video memory

print_string_pm_loop:
    mov al, [ebx]           ; store the char at EBX in al
    mov ah, WHITE_ON_BLACK  ; store the attributes in ah

    cmp al, 0               ; if (al == 0), then it's end of string
    je print_string_pm_done

    mov [edx], ax           ; store the char and attributes at current char cell
    add ebx, 1              ; increment ebx to the next char in string
    add edx, 2              ; move to next character cell in video memory

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret