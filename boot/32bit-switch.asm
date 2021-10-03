[bits 16]
switch_to_pm:
    cli                     ; disable interrupts
    lgdt [gdt_descriptor]   ; load our global descriptor table
    mov eax, cr0            ; to make the switch to protected mode, we set
    or eax, 0x1             ; the first bit of cr0, a control register
    mov cr0, eax

    jmp CODE_SEG:init_pm

[bits 32]   ; we are now using 32-bit instructions
init_pm:
    mov ax, DATA_SEG        ; now in PM, old segments are meaningless,
    mov ds, ax              ; so we point our segment registers to the
    mov ss, ax              ; data selector we defined in our gdt
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000        ; update our stack position so it is right
    mov esp, ebp            ; at the top of the free space

    call BEGIN_PM           ; call a well-known label with useful code