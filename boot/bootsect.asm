[org 0x7c00]
KERNEL_OFFSET equ 0x1000    ; This is the memory offset to which we will load our kernel

mov [BOOT_DRIVE], dl        ; remember dl(boot drive) for later
mov bp, 0x9000              ; set up the stack away from boot sector data
mov sp, bp

mov bx, MSG_REAL_MODE       
call print_string
call print_ln

call load_kernel
call switch_to_pm           ; disable interrupts, load GDT
jmp $

%include "boot/print_string.asm"
%include "boot/print_hex.asm"
%include "boot/disk_load.asm"
%include "boot/32bit-gdt.asm"
%include "boot/32bit-print.asm"
%include "boot/32bit-switch.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL      ; print messsage to say kernel is loading
    call print_string
    call print_ln

    mov bx, KERNEL_OFFSET       ; read from disk and store in 0x1000
    mov dh, 15                   ; set-up parameters for our disk_load routine
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret           

[bits 32]
BEGIN_PM:                       ; enter 32bit mode
    mov ebx, MSG_PROT_MODE
    call print_string_pm
    call KERNEL_OFFSET          ; give control to the kernel
    jmp $                       ; hang if kernel return control to this routine (if ever)

BOOT_DRIVE db 0 ; It is a good idea to store it in memory because 'dl' may get overwritten
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0

; bootsector padding
times 510 - ($-$$) db 0
dw 0xaa55