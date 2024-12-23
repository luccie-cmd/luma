global abort
extern dbgPuts
section .text
abort:
    mov rdi, str0
    call dbgPuts
    cli
    jmp $

section .rodata
str0: db 0x0a, "Aborting luma!!!", 0x0a, 0