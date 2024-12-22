global KernelMain
extern dbgPrintf
section .text
KernelMain:
    mov rdi, str0
    call dbgPrintf
    jmp $

section .rodata
str0: db "Hello Kernel", 0x0a, 0