global handleInt
extern abort
extern dbgPrintf
section .text
handleInt:
    push rdi
    push rsi
    mov rsi, QWORD [rdi+0xA8]
    mov rdi, str2
    call dbgPrintf
    pop rsi
    pop rdi
    cmp QWORD [rdi+0xA8], 32
    jg userHandler
    lea rsi, intJumpTable
    mov rax, [rdi+0xA8]
    shl rax, 3
    add rsi, rax
    jmp QWORD [rsi]
    
userHandler:
    mov rsi, [rdi+0xA8]
    mov rdi, str1
    call dbgPrintf
    call abort

unhandledInt:
    mov rsi, [rdi+0xA8]
    mov rdi, str0
    call dbgPrintf
    call abort

intJumpTable:
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt
    dq unhandledInt

section .rodata
str0: db "TODO: handle exception 0x%lx", 0x0a, 0
str1: db "TODO: Handle user interrupt 0x%lx", 0x0a, 0
str2: db "Got interrupt #0x%lx", 0x0a, 0