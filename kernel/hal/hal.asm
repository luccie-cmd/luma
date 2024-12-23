global halEarlyInit
extern dbgPuts
extern abort
section .text
halEarlyInit:
    mov rdi, str0
    call dbgPuts
    ret

section .rodata
str0: db "Setting up early HAL", 0x0a, 0