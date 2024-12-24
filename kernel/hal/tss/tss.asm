global halInitTSS
extern dbgPuts
section .text
halInitTSS:
    push rdi
    mov rdi, str0
    call dbgPuts
    pop rdi
    ret

section .rodata
str0: db "TODO: Initialize TSS when we actually launch processes", 0x0a, 0