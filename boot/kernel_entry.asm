[bits 32]
[extern main]   ; declare external symbol 'main' for linker
call main       ; invoke main() from kernel
jmp $           ; hang forever when  return from kernel