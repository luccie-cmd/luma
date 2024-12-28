global halEarlyInit
global halMidInit
extern dbgPuts
extern halInitGDT
extern halInitIDT
extern halInitTSS
extern halInitIRQ
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

halMidInit:
    push rdi
    mov rdi, str1
    call dbgPuts
    call halInitIRQ
    pop rdi
    ret

section .rodata
str0: db "Setting up early HAL", 0x0a, 0
str1: db "Setting up mid HAL", 0x0a, 0