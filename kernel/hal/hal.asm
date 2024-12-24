global halEarlyInit
extern dbgPuts
extern halInitGDT
extern halInitIDT
extern halInitTSS
extern abort
section .text
halEarlyInit:
    push rdi
    mov rdi, str0
    call dbgPuts
    call halInitIDT
    call halInitGDT
    call halInitTSS
    pop rdi
    ret

section .rodata
str0: db "Setting up early HAL", 0x0a, 0